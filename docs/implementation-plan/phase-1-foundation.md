# Phase 1: Foundation & Authentication

## Goal
Set up the core infrastructure: data models, API client with interceptors, authentication service, token management, and role-based routing. After this phase, a user can log in with email+password and be routed to the correct dashboard by role.

---

## Task 1.1: Add Dependencies

**File:** `pubspec.yaml`

Add the following dependencies:

```yaml
dependencies:
  dio: ^5.4.0                        # HTTP client
  flutter_secure_storage: ^9.0.0     # Secure token storage
  shared_preferences: ^2.2.2         # Non-sensitive prefs
  json_annotation: ^4.8.1            # JSON serialization annotations
  intl: ^0.19.0                      # Date/number formatting
  cached_network_image: ^3.3.1       # Image caching
  shimmer: ^3.0.0                    # Loading shimmer effect

dev_dependencies:
  json_serializable: ^6.7.1          # JSON code generation
  build_runner: ^2.4.8               # Code generator runner
```

**Verification:** `flutter pub get` succeeds.

---

## Task 1.2: Create Enums

### 1.2.1 User Role Enum
**File:** `lib/core/enums/user_role.dart`

```dart
enum UserRole {
  clinicAdmin('clinic_admin'),
  veterinarian('veterinarian'),
  staff('staff');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => throw ArgumentError('Unknown role: $role'),
    );
  }
}
```

### 1.2.2 Appointment Status Enum
**File:** `lib/core/enums/appointment_status.dart`

```dart
enum AppointmentStatus {
  pending('pending'),
  scheduled('scheduled'),
  confirmed('confirmed'),
  checkedIn('checked_in'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  final String value;
  const AppointmentStatus(this.value);

  static AppointmentStatus fromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => throw ArgumentError('Unknown status: $status'),
    );
  }
}
```

### 1.2.3 Reminder Type Enum
**File:** `lib/core/enums/reminder_type.dart`

```dart
enum ReminderType {
  appointment('appointment'),
  vaccination('vaccination'),
  medication('medication'),
  checkup('checkup'),
  grooming('grooming'),
  deworming('deworming'),
  custom('custom');

  final String value;
  const ReminderType(this.value);

  static ReminderType fromString(String type) {
    return ReminderType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => throw ArgumentError('Unknown reminder type: $type'),
    );
  }
}
```

### 1.2.4 Document Type Enum
**File:** `lib/core/enums/document_type.dart`

```dart
enum DocumentType {
  labResult('lab_result'),
  xray('xray'),
  intakeForm('intake_form'),
  referralLetter('referral_letter'),
  other('other');

  final String value;
  const DocumentType(this.value);

  static DocumentType fromString(String type) {
    return DocumentType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => throw ArgumentError('Unknown document type: $type'),
    );
  }
}
```

---

## Task 1.3: Create Data Models

All models should use `json_serializable` with `@JsonSerializable()` annotation and include `factory fromJson` and `toJson` methods.

### 1.3.1 API Response Wrapper
**File:** `lib/core/models/api_response.dart`

Generic wrapper matching the backend response format:
```dart
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final ApiError? error;
}

class ApiError {
  final String code;
  final String message;
  final List<ApiErrorDetail>? details;
}

class ApiErrorDetail {
  final List<String> path;
  final String message;
  final String code;
}
```

### 1.3.2 Pagination Model
**File:** `lib/core/models/pagination.dart`

```dart
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta pagination;
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool? hasNext;
  final bool? hasPrev;
}
```

### 1.3.3 User Model
**File:** `lib/core/models/auth/user.dart`

Follow pet_app pattern — plain class with `fromJson`/`toJson`, computed getters.

Fields from API:
- `id` (String/UUID)
- `role` (String) — current active role
- `roles` (List<String>) — all assigned roles (for role switching)
- `clinicId` (String? - null for super_admin)
- `firstName` (String)
- `lastName` (String)
- `email` (String?)
- `phone` (String?)
- `avatarUrl` (String?)
- `specialization` (String? - for veterinarians)
- `bio` (String? - for veterinarians)
- `isActive` (bool)
- `createdAt` (DateTime?)

Computed getters:
- `String get fullName => '$firstName $lastName';`
- `UserRole get activeRole => UserRole.fromString(role);`
- `List<UserRole> get availableRoles => roles.map(UserRole.fromString).toList();`
- `bool get hasMultipleRoles => roles.length > 1;`

### 1.3.4 Clinic Model
**File:** `lib/core/models/clinic.dart`

Fields:
- `id` (String)
- `name` (String)
- `slug` (String)
- `phone` (String?)
- `email` (String?)
- `address` (ClinicAddress)
- `branding` (ClinicBranding?)
- `isActive` (bool)
- `subscriptionStatus` (String?)
- `subscriptionPlan` (String?)
- `createdAt` (DateTime)

Sub-models:
```dart
class ClinicAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
}

class ClinicBranding {
  final String? primaryColor;
  final String? logoUrl;
}
```

### 1.3.5 Pet Model
**File:** `lib/core/models/pet.dart`

Fields:
- `id` (String)
- `name` (String)
- `species` (String)
- `breed` (String?)
- `gender` (String?) - male/female/unknown
- `color` (String?)
- `dateOfBirth` (DateTime?)
- `weight` (double?)
- `weightUnit` (String?) - kg/lbs
- `photoUrl` (String?)
- `isActive` (bool)
- `isDeceased` (bool)
- `microchipNumber` (String?)
- `allergies` (List<String>)
- `chronicConditions` (List<String>)
- `currentMedications` (List<String>)
- `notes` (String?)
- `createdAt` (DateTime)
- `updatedAt` (DateTime)

### 1.3.6 Pet Owner Model
**File:** `lib/core/models/pet_owner.dart`

Fields:
- `id` (String)
- `userId` (String)
- `firstName` (String)
- `lastName` (String)
- `phone` (String)
- `email` (String?)
- `avatarUrl` (String?)
- `petCount` (int?)
- `createdAt` (DateTime)

### 1.3.7 Appointment Model
**File:** `lib/core/models/appointment.dart`

Fields:
- `id` (String)
- `clinicId` (String)
- `petId` (String)
- `ownerId` (String?)
- `veterinarianId` (String?)
- `title` (String)
- `description` (String?)
- `appointmentType` (String?)
- `status` (AppointmentStatus)
- `scheduledStart` (DateTime)
- `scheduledEnd` (DateTime)
- `durationMinutes` (int?)
- `roomNumber` (String?)
- `preAppointmentNotes` (String?)
- `postAppointmentNotes` (String?)
- `actualStart` (DateTime?)
- `actualEnd` (DateTime?)
- `cancelledBy` (String?)
- `cancelledAt` (DateTime?)
- `cancellationReason` (String?)
- `pet` (Pet?) - nested
- `owner` (PetOwner?) - nested
- `veterinarian` (User?) - nested

### 1.3.8 Medical Record Model
**File:** `lib/core/models/medical_record.dart`

Fields:
- `id` (String)
- `petId` (String)
- `petName` (String?)
- `petPhotoUrl` (String?)
- `visitDate` (DateTime)
- `visitReason` (String?)
- `diagnosis` (String?)
- `treatment` (String?)
- `notes` (String?)
- `veterinarianId` (String?)
- `veterinarianName` (String?)
- `clinicId` (String?)
- `clinicName` (String?)
- `weightAtVisit` (double?)
- `weightUnit` (String?)
- `temperatureAtVisit` (double?)
- `temperatureUnit` (String?)
- `hasPrescriptions` (bool?)
- `hasDocuments` (bool?)
- `createdAt` (DateTime?)

### 1.3.9 Prescription Model
**File:** `lib/core/models/prescription.dart`

Fields:
- `id` (String)
- `petId` (String)
- `medicalRecordId` (String?)
- `veterinarianId` (String)
- `clinicId` (String)
- `medicationName` (String)
- `dosage` (String)
- `frequency` (String)
- `duration` (String?)
- `instructions` (String?)
- `isActive` (bool)
- `startDate` (DateTime?)
- `endDate` (DateTime?)
- `createdAt` (DateTime)

### 1.3.10 Vaccination Model
**File:** `lib/core/models/vaccination.dart`

Fields:
- `id` (String)
- `petId` (String)
- `veterinarianId` (String?)
- `clinicId` (String)
- `vaccineName` (String)
- `dateAdministered` (DateTime)
- `nextDueDate` (DateTime?)
- `batchNumber` (String?)
- `manufacturer` (String?)
- `notes` (String?)
- `createdAt` (DateTime)

### 1.3.11 Document Model
**File:** `lib/core/models/document.dart`

Fields:
- `id` (String)
- `petId` (String)
- `petName` (String?)
- `medicalRecordId` (String?)
- `name` (String)
- `fileUrl` (String)
- `fileType` (String)
- `fileSizeBytes` (int?)
- `documentType` (String?)
- `tags` (List<String>?)
- `uploadedAt` (DateTime)
- `uploadedBy` (String?)

### 1.3.12 Reminder Model
**File:** `lib/core/models/reminder.dart`

Fields:
- `id` (String)
- `clinicId` (String)
- `petId` (String?)
- `ownerId` (String?)
- `appointmentId` (String?)
- `reminderType` (ReminderType)
- `title` (String)
- `message` (String?)
- `scheduledFor` (DateTime)
- `status` (String)
- `channels` (List<String>?)
- `metadata` (Map<String, dynamic>?)
- `createdAt` (DateTime)

---

## Task 1.4: Create Constants

### 1.4.1 API Endpoints

**Already created in Phase 0** — `lib/core/config/api_config.dart` contains all endpoints following the pet_app pattern. Services should reference `ApiConfig.xxxEndpoint` instead of a separate endpoints file.

### 1.4.2 Storage Keys
**File:** `lib/core/constants/storage_keys.dart`

```dart
class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String clinicId = 'clinic_id';
  static const String userJson = 'user_json';
}
```

---

## Task 1.5: Create Network Layer

**Pattern:** Follow pet_app's `ApiClient` — single service wrapping Dio with token injection, 401 auto-refresh, and error mapping. No separate interceptor files.

### 1.5.1 ApiException
**File:** `lib/services/api_client.dart` (defined in same file as ApiClient, or in a separate `lib/core/models/api_exception.dart`)

```dart
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});
  final int? statusCode;
  final String message;
}
```

### 1.5.2 ApiClient Service
**File:** `lib/services/api_client.dart`

A Dio wrapper service following the pet_app pattern:

```dart
class ApiClient {
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: 'application/json',
    ));
  }

  late final Dio _dio;

  // Core HTTP methods
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data});
  Future<dynamic> put(String path, {dynamic data});
  Future<dynamic> patch(String path, {dynamic data});
  Future<dynamic> delete(String path);
}
```

**Token injection:** Before each request, read access token from `SecureStorageService` and attach `Authorization: Bearer <token>` header.

**401 handling with concurrent request lock:**
1. On 401 response, check if a refresh is already in progress (use `Completer`)
2. If first 401: call `AuthService.refreshToken()`, store new tokens, retry request
3. If concurrent 401: wait for the first refresh to complete, then retry
4. If refresh fails: clear tokens, navigate to login via `NavigationService`

**Error mapping:** Convert `DioException` → `ApiException` with user-friendly messages:
- Connection error → "Unable to connect to server"
- Timeout → "Request timed out"
- 400/422 → Extract validation error message from response body
- 403 → "You do not have permission"
- 404 → "Resource not found"
- 500 → "Server error"

Register in `app.dart` as `LazySingleton`.

---

## Task 1.6: Create Storage Services

**Pattern:** Follow pet_app — two separate services: `SecureStorageService` for tokens, `SharedPreferencesService` for non-sensitive data.

### 1.6.1 SecureStorageService
**File:** `lib/services/secure_storage_service.dart`

Wraps `flutter_secure_storage` for sensitive data (tokens):
- `saveAccessToken(String token)` → Future<void>
- `getAccessToken()` → Future<String?>
- `saveRefreshToken(String token)` → Future<void>
- `getRefreshToken()` → Future<String?>
- `clearTokens()` → Future<void>
- `hasTokens()` → Future<bool>

Register in app.locator as `LazySingleton`.

### 1.6.2 SharedPreferencesService
**File:** `lib/services/shared_preferences_service.dart`

Wraps `shared_preferences` for non-sensitive data (user info, preferences):
- `saveUserRole(String role)` / `getUserRole()` → String?
- `saveUserId(String id)` / `getUserId()` → String?
- `saveClinicId(String id)` / `getClinicId()` → String?
- `saveUserName(String name)` / `getUserName()` → String?
- `saveAvatarUrl(String url)` / `getAvatarUrl()` → String?
- `clearAll()` → Future<void>

Register in app.locator as `LazySingleton`.

---

## Task 1.7: Create Auth Service

**File:** `lib/services/auth_service.dart`

Follow the pet_app `AuthService` pattern — orchestrates `ApiClient`, `SecureStorageService`, and `SharedPreferencesService`.

Methods:
- `login(String email, String password, {Map<String, String>? deviceInfo})` → User
  - POST to `ApiConfig.mobileLoginEndpoint` (`/api/mobile/auth/login`)
  - Request: `{ email, password, deviceInfo }`
  - On success:
    - Store accessToken and refreshToken via `SecureStorageService`
    - Store user role, name, clinicId via `SharedPreferencesService`
    - Return User model
  - On error: throw `ApiException`
- `refreshToken()` → void
  - POST to `ApiConfig.refreshTokenEndpoint` with stored refresh token
  - Store new tokens
  - Called by `ApiClient` on 401
- `switchRole(UserRole newRole)` → User
  - POST to `/api/mobile/auth/switch-role` with `{ role: newRole.value }`
  - Store new tokens (access + refresh are regenerated)
  - Update stored role in SharedPreferences
  - Return updated User model
- `logout()` → void
  - POST to `/api/mobile/auth/logout` with refresh token (revoke server-side)
  - Clear all SecureStorage + SharedPreferences
  - Navigate to login screen via `NavigationService`
- `getCurrentUser()` → User?
  - Return cached user from SharedPreferencesService
- `isLoggedIn()` → Future<bool>
  - Check if access token exists in SecureStorageService
- `getUserRole()` → UserRole?
  - Read from SharedPreferencesService
- `getAvailableRoles()` → List<UserRole>
  - Read from stored user data (user.roles array)

Register in app.locator as a `LazySingleton`.

**Backend dependency:** Requires `POST /api/mobile/auth/login` endpoint. See `backend-api-requirements.md` API 1.

---

## Task 1.8: Modify Login Screen for Email+Password

**Modify:** `lib/ui/views/login/login_view.dart` and `login_viewmodel.dart`

Current: Phone number input with "Send OTP" flow.
Change to: Email + Password input with "Sign In" button.

### Login View Changes:
- Replace phone field with email text field
- Add password text field (with show/hide toggle)
- Replace "Send OTP" button with "Sign In" button
- Add loading indicator during API call
- Add error message display (snackbar or inline)
- Keep the existing green theme and Manrope font
- Remove "Register" navigation (clinic staff are created by admin, not self-registered)

### Login ViewModel Changes:
- Add `emailController` and `passwordController`
- Add `isLoading` state
- Add `errorMessage` state
- `login()` method:
  1. Validate email + password are non-empty
  2. Call `authService.login(email, password)`
  3. On success: navigate based on role (see Task 1.9)
  4. On error: display appropriate error message
- `dispose()`: Dispose controllers

---

## Task 1.9: Role-Based Routing

### Modify Startup View
**Modify:** `lib/ui/views/startup/startup_viewmodel.dart`

Current: 3-second delay then navigate to login.
Change to:
1. Check `storageService.isLoggedIn()`
2. If logged in:
   - Get user role from storage
   - Fetch fresh profile from `/api/profile` to verify token validity
   - Navigate to role-appropriate home screen
3. If not logged in: Navigate to login screen

### Role-Based Navigation Helper
**File:** `lib/utils/permission_utils.dart`

```dart
class PermissionUtils {
  /// Returns the home route for a given role
  static String homeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.clinicAdmin:
        return Routes.homeView; // admin dashboard
      case UserRole.veterinarian:
        return Routes.homeView; // vet dashboard (filtered appointments)
      case UserRole.staff:
        return Routes.homeView; // staff dashboard (all appointments)
    }
  }

  /// Check if role has permission
  static bool hasPermission(UserRole role, String permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }

  static const Map<UserRole, Set<String>> _rolePermissions = {
    UserRole.clinicAdmin: {
      'clinic:manage', 'users:manage', 'pets:manage',
      'appointments:manage', 'medical-records:manage',
      'prescriptions:manage', 'documents:manage',
      'reminders:manage', 'reminders:send', 'reports:view',
    },
    UserRole.veterinarian: {
      'appointments:view', 'pets:view', 'pets:create', 'pets:update',
      'medical-records:manage', 'prescriptions:manage',
      'documents:manage', 'vaccinations:manage',
      'reminders:view', 'reminders:create', 'reminders:update',
    },
    UserRole.staff: {
      'appointments:view', 'appointments:create',
      'appointments:update', 'appointments:manage',
      'pets:view', 'pets:create', 'pets:update',
      'documents:view', 'documents:upload',
      'reminders:view', 'reminders:create',
    },
  };
}
```

---

## Task 1.10: Role Switcher Widget

**File:** `lib/ui/widgets/common/role_switcher.dart`

A dropdown widget that allows users with multiple roles to switch their active role.

### Widget:
```dart
class RoleSwitcher extends StatelessWidget {
  // Reads available roles from AuthService
  // Shows current active role
  // Dropdown to switch to another role
}
```

### Behavior:
- Only visible if `user.roles.length > 1` (user has multiple roles)
- Shows current role as selected value
- Dropdown options: all roles from `user.roles` array
- On selection:
  1. Show loading indicator
  2. Call `authService.switchRole(selectedRole)`
  3. On success: reload dashboard, update bottom nav, show snackbar "Switched to {role}"
  4. On error: show error snackbar, revert dropdown

### Display format:
- Role labels: "Clinic Admin", "Veterinarian", "Staff" (human-readable, not enum values)
- Optional: role icon next to label

### Placement:
- In the Home view app bar (next to greeting)
- Also accessible from Profile/Settings screen

### If only one role:
- Widget returns `SizedBox.shrink()` (hidden)

### Backend dependency:
- Requires `POST /api/mobile/auth/switch-role` endpoint
- Requires `roles` array in User model
- If backend not ready: hide switcher, operate in single-role mode (graceful fallback)

---

## Task 1.11: Create LayoutService

**File:** `lib/services/layout_service.dart`

Follow the pet_app pattern — a reactive service that manages bottom navigation state.

```dart
class LayoutService with ListenableServiceMixin {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void resetIndex() {
    _currentIndex = 0;
    notifyListeners();
  }
}
```

Register in `app.dart` as `LazySingleton(classType: LayoutService)`.

**Why:** This allows any ViewModel to change the bottom nav tab (e.g., after creating an appointment, switch to the calendar tab). It also preserves tab state when navigating back.

---

## Task 1.12: Create MainView Container (IndexedStack Pattern)

**New files:**
- `lib/ui/views/main/main_view.dart`
- `lib/ui/views/main/main_viewmodel.dart`

Follow the pet_app pattern — a container view that holds all bottom nav tabs using `IndexedStack`.

### MainViewModel:
- Inject `LayoutService`, `AuthService`
- Properties:
  - `int get currentIndex => _layoutService.currentIndex`
  - `UserRole? currentRole`
  - `List<Widget> get pages` — role-dependent tab pages
- Methods:
  - `initialise()` → Get current user role, build tab list
  - `setIndex(int index)` → `_layoutService.setIndex(index)`
- Listen to `LayoutService` changes via `ListenableServiceMixin`

### MainView:
```dart
class MainView extends StackedView<MainViewModel> {
  @override
  Widget builder(context, viewModel, child) {
    return Scaffold(
      body: IndexedStack(
        index: viewModel.currentIndex,
        children: viewModel.pages,
      ),
      bottomNavigationBar: _buildBottomNav(viewModel),
      floatingActionButton: _buildFab(viewModel),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}
```

### Tab Pages per Role:

**Clinic Admin (5 tabs):**
| Index | Tab | Icon | Page |
|-------|-----|------|------|
| 0 | Home | home | HomeView |
| 1 | Patients | pets | PatientRegistryView |
| 2 | (FAB) | add | → AppointmentFormView (push) |
| 3 | Staff | people | StaffListView |
| 4 | More | menu | AdminMenuView (settings, branding, reminders, reports, profile) |

**Staff (5 tabs):**
| Index | Tab | Icon | Page |
|-------|-----|------|------|
| 0 | Home | home | HomeView |
| 1 | Patients | pets | PatientRegistryView |
| 2 | (FAB) | add | → AppointmentFormView (push) |
| 3 | Owners | people | PetOwnerListView |
| 4 | Profile | person | ProfileView |

**Veterinarian (4 tabs):**
| Index | Tab | Icon | Page |
|-------|-----|------|------|
| 0 | Home | home | HomeView |
| 1 | Patients | pets | PatientRegistryView |
| 2 | Schedule | calendar | ScheduleView |
| 3 | Profile | person | ProfileView |

### Route:
Replace the current `HomeView` initial route post-login with `MainView`:
```dart
MaterialRoute(page: MainView, path: '/main-view')
```

After login success: `_navigationService.clearStackAndShow(Routes.mainView)`

### Why IndexedStack:
- Preserves state of each tab (scroll position, loaded data)
- No rebuild when switching tabs
- Same pattern as pet_app's proven implementation

---

## Task 1.13: Modify Home View for Role-Based Dashboard (Content Only)

**Modify:** `lib/ui/views/home/home_view.dart` and `home_viewmodel.dart`

The home view should show different content based on user role:

### HomeViewModel Changes:
- Inject `AuthService` and `StorageService`
- On `initialise()`:
  1. Get current user and role
  2. Fetch dashboard data based on role
- Properties:
  - `User? currentUser`
  - `UserRole? userRole`
  - `bool isLoading`
  - `String? errorMessage`

### Home View Layout (all roles):
- Keep top section: greeting with user name + avatar
- Keep bottom navigation bar (adjust items per role)

### Bottom Navigation per Role:

**Clinic Admin:**
1. Home (dashboard)
2. Patients (registry)
3. Calendar (schedule)
4. Staff (staff management)
5. Profile (settings)

**Staff:**
1. Home (dashboard)
2. Patients (registry)
3. Calendar (schedule)
4. Profile (settings)
- Same as current but with appointment management focus

**Veterinarian:**
1. Home (my appointments)
2. Patients (registry - view only)
3. Calendar (my schedule)
4. Profile (settings)

---

## Task 1.14: Update Stacked App Configuration

**Modify:** `lib/app/app.dart`

Register new services:
```dart
@StackedApp(
  routes: [
    // ... existing routes ...
    // New routes will be added in subsequent phases
  ],
  dependencies: [
    LazySingleton(classType: StorageService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ApiClient),
    // ... existing services ...
  ],
)
```

Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Task 1.15: Create Role Guard Widget

**File:** `lib/ui/common/role_guard.dart`

A widget that conditionally shows content based on user role:

```dart
class RoleGuard extends StatelessWidget {
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget? fallback; // Optional: what to show if role doesn't match

  // Shows child only if current user's role is in allowedRoles
}
```

Usage:
```dart
RoleGuard(
  allowedRoles: [UserRole.clinicAdmin],
  child: StaffManagementButton(),
)
```

---

## Verification Checklist

After completing Phase 1:

- [ ] `flutter pub get` succeeds with all new dependencies
- [ ] All models have `fromJson`/`toJson` methods and serialize correctly
- [ ] API client creates Dio instance with correct base URL and interceptors
- [ ] Auth interceptor attaches token to requests
- [ ] Auth interceptor handles 401 by refreshing token
- [ ] StorageService reads/writes tokens to flutter_secure_storage
- [ ] AuthService.login() calls API, stores tokens, returns User
- [ ] AuthService.logout() clears storage, navigates to login
- [ ] Login screen shows email + password fields
- [ ] Login calls AuthService and navigates on success
- [ ] Startup screen checks login state and routes to correct dashboard
- [ ] Home view loads with current user info and role-appropriate content
- [ ] Bottom nav items change based on role
- [ ] RoleGuard widget hides/shows content per role
- [ ] `flutter pub run build_runner build` generates all code without errors
- [ ] App compiles and runs without errors
