# Phase 6: Polish & Cross-Cutting Concerns

## Goal
Add finishing touches: global error handling, connectivity awareness, image upload flows, search improvements, push notification setup, and overall UX polish. This phase hardens the app for production readiness.

**Depends on:** Phase 5 (Clinic Admin Features) must be complete.

---

## Task 6.1: Global Error Handling

### 6.1.1 Error Interceptor Enhancement
**Modify:** `lib/core/network/api_client.dart`

Enhance the Dio error interceptor:
- Map all HTTP status codes to custom exceptions (already defined in Phase 1)
- Handle network errors (SocketException, TimeoutException) → `NetworkException`
- Handle certificate errors → show user-friendly message
- Log errors in debug mode

### 6.1.2 Base ViewModel Error Handling Mixin
**File:** `lib/ui/common/error_handling_mixin.dart`

Create a mixin for ViewModels that provides:
```dart
mixin ErrorHandlingMixin on BaseViewModel {
  String? errorMessage;
  bool hasError = false;

  Future<T?> runSafe<T>(Future<T> Function() action, {
    String? fallbackMessage,
    VoidCallback? onError,
  }) async {
    try {
      clearError();
      final result = await action();
      return result;
    } on UnauthorizedException {
      // Already handled by auth interceptor (redirect to login)
      return null;
    } on ForbiddenException {
      setError('You do not have permission to perform this action.');
    } on NotFoundException {
      setError('The requested resource was not found.');
    } on ValidationException catch (e) {
      setError(e.firstFieldError ?? e.message);
    } on NetworkException {
      setError('No internet connection. Please check your network.');
    } on ApiException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(fallbackMessage ?? 'Something went wrong. Please try again.');
    }
    onError?.call();
    return null;
  }

  void setError(String message) {
    errorMessage = message;
    hasError = true;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    hasError = false;
  }
}
```

Update all ViewModels to use this mixin and wrap API calls in `runSafe()`.

---

## Task 6.2: Connectivity Awareness

### 6.2.1 Add Dependency
**File:** `pubspec.yaml`
```yaml
dependencies:
  connectivity_plus: ^5.0.2    # Network connectivity monitoring
```

### 6.2.2 Connectivity Service
**File:** `lib/services/connectivity_service.dart`

- Monitor connectivity changes via `Connectivity().onConnectivityChanged`
- Properties:
  - `bool isConnected`
  - `Stream<bool> connectivityStream`
- Methods:
  - `checkConnectivity()` → bool
  - `init()` → Start listening

Register in app.locator, initialize in main.dart.

### 6.2.3 Offline Banner Widget
**File:** `lib/ui/widgets/offline_banner.dart`

A widget that shows at the top of the screen when offline:
- Red/orange banner: "No internet connection"
- Auto-hides when connection restored
- Can be wrapped around Scaffold body

### Usage in Views:
Wrap the main Scaffold body with an offline-aware widget:
```dart
Column(
  children: [
    OfflineBanner(),
    Expanded(child: mainContent),
  ],
)
```

---

## Task 6.3: Image Upload Flows (Avatar & Pet Photos)

### 6.3.1 Add Dependencies
**File:** `pubspec.yaml`
```yaml
dependencies:
  image_picker: ^1.0.7         # Camera/gallery image selection
  image_cropper: ^5.0.1        # Crop images before upload
```

### 6.3.2 Image Upload Service
**File:** `lib/services/image_upload_service.dart`

Generic image upload service using the S3 presigned URL pattern:

```dart
class ImageUploadService {
  /// Upload image for a pet photo
  Future<String> uploadPetPhoto(String petId, File imageFile) async {
    // 1. Get presigned URL: POST /api/mobile/pets/{petId}/photo/presigned-url
    // 2. Upload to S3: PUT to presigned URL
    // 3. Confirm: PATCH /api/mobile/pets/{petId}/photo
    // 4. Return final photoUrl
  }

  /// Upload image for user avatar
  Future<String> uploadAvatar(File imageFile) async {
    // Similar flow with profile avatar endpoints
  }

  /// Pick and crop image
  Future<File?> pickAndCropImage({
    required ImageSource source, // camera or gallery
    double? maxWidth,
    double? maxHeight,
    CropAspectRatio? aspectRatio,
  }) async {
    // 1. Pick image using image_picker
    // 2. Crop using image_cropper
    // 3. Return cropped file
  }
}
```

Register in app.locator as LazySingleton.

### 6.3.3 Integrate into Views

**Patient Profile:**
- Tap on pet photo → show bottom sheet: "Take Photo" / "Choose from Gallery" / "Remove Photo"
- Pick → crop (square) → upload → refresh pet data
- Show upload progress

**Doctor Profile:**
- Tap on avatar → same flow
- Pick → crop (circle) → upload → refresh profile

**Pet Form:**
- Add photo section at the top
- Optional during create, can add later

---

## Task 6.4: Search Improvements

### 6.4.1 Debounced Search Helper
**File:** `lib/utils/debouncer.dart`

```dart
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
```

### 6.4.2 Update Search in Views

Apply debounced search (300ms delay) to:
- **Patient Registry** - search pets by name
- **Pet Owner List** - search owners by name/phone
- **Staff List** - search staff by name/email

### 6.4.3 Global Search (Optional Enhancement)
Could add a global search screen accessible from home that searches across:
- Pets
- Pet Owners
- Appointments
- Staff

This is a nice-to-have and can be deferred.

---

## Task 6.5: Pull-to-Refresh Pattern

### Standardize across all list views:

All list views should implement `RefreshIndicator`:
```dart
RefreshIndicator(
  onRefresh: () => viewModel.refresh(),
  child: ListView.builder(...),
)
```

Views to update:
- Patient Registry
- Schedule
- Pending Appointments
- Pet Owner List
- Document List
- Prescription List
- Vaccination List
- Reminder List
- Staff List

---

## Task 6.6: Date/Time Formatting Utilities

**File:** `lib/utils/date_utils.dart`

```dart
class AppDateUtils {
  /// "Feb 27, 2026"
  static String formatDate(DateTime date);

  /// "2:30 PM"
  static String formatTime(DateTime date);

  /// "Feb 27, 2026 at 2:30 PM"
  static String formatDateTime(DateTime date);

  /// "2:30 PM - 3:00 PM"
  static String formatTimeRange(DateTime start, DateTime end);

  /// "2 years 3 months" (for pet age)
  static String calculateAge(DateTime dateOfBirth);

  /// "Today", "Tomorrow", "Yesterday", or formatted date
  static String friendlyDate(DateTime date);

  /// "3 hours ago", "2 days ago" (relative time)
  static String timeAgo(DateTime date);

  /// "In 2 days", "In 3 hours" (upcoming relative time)
  static String timeUntil(DateTime date);
}
```

Update all views to use these utilities instead of inline formatting.

---

## Task 6.7: Form Validation Utilities

**File:** `lib/utils/validators.dart`

```dart
class Validators {
  static String? required(String? value, [String fieldName = 'This field']);
  static String? email(String? value);
  static String? phone(String? value);
  static String? minLength(String? value, int min);
  static String? maxLength(String? value, int max);
  static String? password(String? value); // min 8 chars
  static String? number(String? value);
  static String? positiveNumber(String? value);
}
```

Update all form views to use these validators for consistent validation.

---

## Task 6.8: Snackbar/Toast Notifications

### 6.8.1 Notification Helper
**File:** `lib/ui/common/app_snackbar.dart`

```dart
class AppSnackbar {
  static void showSuccess(BuildContext context, String message);
  static void showError(BuildContext context, String message);
  static void showInfo(BuildContext context, String message);
  static void showWarning(BuildContext context, String message);
}
```

Style:
- Success: Green background
- Error: Red background
- Info: Blue background
- Warning: Orange background
- Duration: 3 seconds
- Position: Bottom
- Dismiss on swipe

### 6.8.2 Integrate into All Actions

Show snackbars after:
- Successful create/update/delete operations
- Login success/failure
- Status updates on appointments
- Reminder send results
- Upload completion
- Error scenarios (network errors, validation failures)

---

## Task 6.9: Confirmation Dialogs

### 6.9.1 Confirmation Dialog Helper
**Modify:** `lib/ui/dialogs/info_alert/info_alert_dialog.dart` or create new

Create reusable confirmation dialog:
```dart
class ConfirmDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false, // Red confirm button for destructive actions
  });
}
```

### 6.9.2 Use for All Destructive Actions

Apply confirmation dialog to:
- Deactivate staff member
- Deactivate pet owner
- Delete medical record
- Delete prescription
- Delete vaccination
- Delete document
- Delete reminder
- Cancel appointment (with reason text field)
- Logout
- Mark pet as deceased

---

## Task 6.10: Loading States Standardization

### 6.10.1 Loading Overlay Widget
**File:** `lib/ui/widgets/loading_overlay.dart`

Full-screen semi-transparent overlay with spinner:
```dart
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message; // Optional "Saving..." text
}
```

### 6.10.2 Button Loading State
**File:** `lib/ui/widgets/app_button.dart`

Reusable button with built-in loading state:
```dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
}
```

When `isLoading = true`:
- Replace text with CircularProgressIndicator
- Disable button
- Keep same width (no layout shift)

Apply to all form save buttons.

---

## Task 6.11: Theme Consistency Pass

Review all views and ensure:

### Colors:
- Primary actions use `kcPrimaryColor`
- Destructive actions use red
- Status badges use defined status colors
- Backgrounds use `kcBackgroundColor`
- Text uses defined grey scale

### Typography:
- All text uses Google Fonts Manrope
- Font sizes use responsive utilities from ui_helpers
- Consistent weight usage (500 body, 600 medium, 700 bold, 800+ titles)

### Spacing:
- Consistent padding (16px standard, 24px section)
- Use defined spacing constants from ui_helpers
- Card border radius: 12-16px consistently

### Icons:
- Consistent icon set (Material icons throughout)
- Icon sizes: 20 (small), 24 (normal), 28 (medium), 32 (large)

---

## Task 6.12: Splash Screen & App Icon

### 6.12.1 Splash Screen
**Modify:** `lib/ui/views/startup/startup_view.dart`

- Show app logo (or clinic logo once logged in)
- App name "Pet Partner"
- Loading indicator
- Green primary color background

### 6.12.2 App Icon (Optional)
Use `flutter_launcher_icons` to set app icon:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
```

---

## Task 6.13: Remove Unused Screens

Clean up screens that are no longer needed:
- `register/` - Staff/vets don't self-register (admin creates accounts)
- `verify_otp/` - OTP is for pet owners only, not clinic staff

Remove routes from `app.dart` and delete the view files.

---

## Task 6.14: Environment Configuration

**File:** `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // Can be overridden with --dart-define for different environments
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> supportedImageTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
  static const int otpResendCooldown = 60; // seconds
  static const int searchDebounceMs = 300;
  static const int paginationLimit = 20;
}
```

Update `ApiClient` to use `AppConstants.apiBaseUrl` instead of hardcoded URL.

Run commands:
```bash
# Development
flutter run --dart-define=API_BASE_URL=http://localhost:3000

# Production
flutter run --dart-define=API_BASE_URL=https://api.petpartner.com
```

---

## Verification Checklist

After completing Phase 6:

- [ ] All API errors are caught and shown as user-friendly messages
- [ ] `runSafe()` is used in all ViewModels for API calls
- [ ] Offline banner appears when network is unavailable
- [ ] Pet photo upload (pick, crop, upload to S3, confirm) works
- [ ] User avatar upload works
- [ ] Debounced search works on all list views (300ms)
- [ ] Pull-to-refresh works on all list views
- [ ] Date/time formatting is consistent across the app
- [ ] Form validation messages are clear and consistent
- [ ] Success/error snackbars appear after all CRUD operations
- [ ] Confirmation dialogs appear for all destructive actions
- [ ] Loading overlays show during save operations
- [ ] Buttons show loading spinner when processing
- [ ] Theme is consistent (colors, fonts, spacing, border radius)
- [ ] Unused register and OTP screens are removed
- [ ] Environment config allows switching API base URL
- [ ] App runs with `--dart-define=API_BASE_URL=...`
- [ ] App compiles and runs without errors on both iOS and Android
- [ ] No hardcoded data remains in any view
