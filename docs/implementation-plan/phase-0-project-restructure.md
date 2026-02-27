# Phase 0: Project Restructure & Convention Alignment

## Goal
Restructure the pet-partner project to match the proven architecture and conventions from the pet_app reference project. This includes upgrading linting, aligning folder structure, adding CLAUDE.md, configuring environment injection, setting up lefthook, and migrating existing code to follow the one-class-per-file and service-locator conventions.

**This phase must be completed FIRST before any feature work begins.**

**Reference project:** `/Users/lokeshkumar/Documents/project/flutter/pet_app`

---

## Task 0.1: Upgrade Dependencies to Match pet_app

**File:** `pubspec.yaml`

### Replace and add dependencies:

```yaml
name: partner
description: Veterinary clinic management app for staff, admin, and veterinarians.
publish_to: 'none'
version: 0.1.0

environment:
  sdk: '>=3.0.3 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # UI
  google_fonts: ^8.0.2
  pinput: ^4.0.0

  # State Management & Architecture
  stacked: ^3.4.0
  stacked_services: ^1.1.0

  # Networking
  dio: ^5.0.0

  # Storage
  flutter_secure_storage: ^10.0.0
  shared_preferences: ^2.2.0

  # Utils
  intl: ^0.20.2
  url_launcher: ^6.2.0
  image_picker: ^1.1.0
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  connectivity_plus: ^5.0.2
  file_picker: ^6.1.1
  path_provider: ^2.1.2

dev_dependencies:
  build_runner: ^2.4.5
  flutter_test:
    sdk: flutter
  very_good_analysis: ^10.1.0
  mockito: ^5.4.1
  stacked_generator: ^2.0.0
  golden_toolkit: ^0.15.0
  lefthook: ^1.6.1

flutter:
  uses-material-design: true
```

**Key changes from current:**
- `flutter_lints` → `very_good_analysis` (strict linting)
- `stacked_generator` upgraded from `^1.3.3` → `^2.0.0`
- Remove `stacked_shared: any` (not needed)
- Add `dio`, `flutter_secure_storage`, `shared_preferences`, `intl`
- Add `image_picker`, `cached_network_image`, `shimmer`
- Add `connectivity_plus`, `file_picker`, `path_provider`, `url_launcher`
- Add `very_good_analysis`, `lefthook`

Run: `flutter pub get`

---

## Task 0.2: Update analysis_options.yaml

**File:** `analysis_options.yaml`

Replace current content with:

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.mocks.dart"
    - "**/*.freezed.dart"
    - lib/app/app.locator.dart
    - lib/app/app.router.dart
    - lib/app/app.bottomsheets.dart
    - lib/app/app.dialogs.dart
    - "**/*.form.dart"

linter:
  rules:
    public_member_api_docs: false
```

---

## Task 0.3: Update stacked.json

**File:** `stacked.json`

The current stacked.json already matches pet_app. Verify it contains:

```json
{
  "bottom_sheets_path": "ui/bottom_sheets",
  "dialogs_path": "ui/dialogs",
  "line_length": 80,
  "locator_name": "locator",
  "prefer_web": false,
  "register_mocks_function": "registerServices",
  "services_path": "services",
  "stacked_app_file_path": "app/app.dart",
  "test_helpers_file_path": "helpers/test_helpers.dart",
  "test_services_path": "services",
  "test_views_path": "viewmodels",
  "test_widgets_path": "widget_models",
  "v1": false,
  "views_path": "ui/views",
  "widgets_path": "ui/widgets/common"
}
```

Note: `services_path` must be `"services"` (not `"core/services"`) since the Stacked generator resolves relative to `lib/`. So services go in `lib/services/` not `lib/core/services/`.

**Important:** This means the folder structure differs slightly from the overview document. Services live at `lib/services/` (not `lib/core/services/`) to match Stacked generator expectations. Models, config, and enums still live under `lib/core/`.

---

## Task 0.4: Create Environment Configuration

### 0.4.1 Create .env.json
**File:** `.env.json`

```json
{
  "API_BASE_URL": "http://10.0.2.2:3000"
}
```

Note: Port 3000 (Next.js backend default), not 3001.

### 0.4.2 Create .env.json.example
**File:** `.env.json.example`

```json
{
  "API_BASE_URL": "http://10.0.2.2:3000"
}
```

### 0.4.3 Add to .gitignore
Ensure `.env.json` is in `.gitignore` (but NOT `.env.json.example`).

### 0.4.4 Create API Config
**File:** `lib/core/config/api_config.dart`

```dart
class ApiConfig {
  // Loaded at compile time via --dart-define-from-file=.env.json
  // Android emulator: 10.0.2.2 maps to host machine's localhost
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  // Auth endpoints (mobile — returns JWT, not session cookies)
  static const String mobileLoginEndpoint =
      '/api/mobile/auth/login';
  static const String refreshTokenEndpoint =
      '/api/mobile/auth/refresh';
  static const String mobileLogoutEndpoint =
      '/api/mobile/auth/logout';
  static const String switchRoleEndpoint =
      '/api/mobile/auth/switch-role';
  static const String profileEndpoint = '/api/profile';

  // Clinic endpoints
  static const String clinicEndpoint = '/api/clinic';
  static const String settingsEndpoint = '/api/settings';
  static const String brandingEndpoint = '/api/branding';
  static const String publicClinicsEndpoint = '/api/clinics/public';

  // User/Staff management endpoints
  static const String usersEndpoint = '/api/users';
  static String userByIdEndpoint(String id) => '/api/users/$id';
  static const String usersBulkEndpoint = '/api/users/bulk';

  // Appointment endpoints
  static const String appointmentsEndpoint = '/api/appointments';
  static String appointmentByIdEndpoint(String id) =>
      '/api/appointments/$id';
  static String appointmentStatusEndpoint(String id) =>
      '/api/appointments/$id/status';
  static String appointmentApproveEndpoint(String id) =>
      '/api/appointments/$id/approve';
  static const String pendingAppointmentsEndpoint =
      '/api/appointments/pending';
  static const String availabilityEndpoint =
      '/api/appointments/availability';
  static String appointmentHistoryEndpoint(String id) =>
      '/api/appointments/$id/history';

  // Pet endpoints
  static const String petsEndpoint = '/api/pets';
  static String petByIdEndpoint(String id) => '/api/pets/$id';
  static String petMedicalRecordsEndpoint(String petId) =>
      '/api/pets/$petId/medical-records';
  static String petMedicalSummaryEndpoint(String petId) =>
      '/api/pets/$petId/medical-summary';
  static String petPrescriptionsEndpoint(String petId) =>
      '/api/pets/$petId/prescriptions';
  static String petVaccinationsEndpoint(String petId) =>
      '/api/pets/$petId/vaccinations';

  // Pet Owner endpoints
  static const String petOwnersEndpoint = '/api/pet-owners';
  static String petOwnerByIdEndpoint(String id) =>
      '/api/pet-owners/$id';
  static const String petOwnerLookupByPhoneEndpoint =
      '/api/pet-owners/lookup-by-phone';
  static const String petOwnerQuickCreateEndpoint =
      '/api/pet-owners/quick-create';

  // Medical Record endpoints
  static const String medicalRecordsEndpoint =
      '/api/medical-records';
  static String medicalRecordByIdEndpoint(String id) =>
      '/api/medical-records/$id';

  // Prescription endpoints
  static const String prescriptionsEndpoint = '/api/prescriptions';
  static String prescriptionByIdEndpoint(String id) =>
      '/api/prescriptions/$id';
  static String prescriptionPdfEndpoint(String id) =>
      '/api/prescriptions/$id/pdf';

  // Vaccination endpoints
  static const String vaccinationsEndpoint = '/api/vaccinations';
  static String vaccinationByIdEndpoint(String id) =>
      '/api/vaccinations/$id';

  // Document endpoints
  static const String documentsEndpoint = '/api/documents';
  static String documentByIdEndpoint(String id) =>
      '/api/documents/$id';
  static const String documentsUploadEndpoint =
      '/api/documents/upload';
  static String documentDownloadEndpoint(String id) =>
      '/api/documents/$id/download';

  // Reminder endpoints
  static const String remindersEndpoint = '/api/reminders';
  static String reminderByIdEndpoint(String id) =>
      '/api/reminders/$id';
  static const String remindersSendEndpoint = '/api/reminders/send';

  // Timeout configurations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

---

## Task 0.5: Create Folder Structure

Create the following directory structure (create empty directories and placeholder files):

```
lib/
├── main.dart                       # Existing (will be updated)
├── app/
│   └── app.dart                    # Existing (will be updated)
├── core/
│   ├── config/
│   │   ├── api_config.dart         # Created in Task 0.4
│   │   └── app_constants.dart      # App-wide constants
│   ├── enums/                      # Created in Phase 1
│   ├── models/                     # Created in Phase 1
│   └── utils/
│       └── ui_helpers.dart         # Move from ui/common/
├── services/                       # Service layer (NOT core/services)
│   └── (created in Phase 1+)
├── ui/
│   ├── common/
│   │   ├── app_colors.dart         # Existing
│   │   └── app_strings.dart        # Existing
│   ├── views/                      # Existing screens
│   ├── widgets/
│   │   └── common/                 # Shared widgets
│   ├── bottom_sheets/              # Existing
│   └── dialogs/                    # Existing
```

Key moves:
- `lib/ui/common/ui_helpers.dart` → `lib/core/utils/ui_helpers.dart`
- Create `lib/core/config/` directory
- Create `lib/core/enums/` directory
- Create `lib/core/models/` directory
- Create `lib/services/` directory (top-level, not under core)

Update all imports after moving files.

---

## Task 0.6: Create app_constants.dart

**File:** `lib/core/config/app_constants.dart`

```dart
class AppConstants {
  // Snackbar
  static const Duration snackbarDuration =
      Duration(seconds: 3);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File upload
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> supportedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  ];

  // Search
  static const int searchDebounceMs = 300;

  // Presigned URL
  static const int presignedUrlExpirySeconds = 300; // 5 min
}
```

---

## Task 0.7: Create app_text_styles.dart

**File:** `lib/core/constants/app_text_styles.dart`

Extract text styles that are currently inline in views into a centralized file, following pet_app pattern:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle get heading => GoogleFonts.manrope(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: const Color(kcDarkGreyColor),
      );

  static TextStyle get headingSmall => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: const Color(kcDarkGreyColor),
      );

  // Body
  static TextStyle get bodyRegular => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(kcDarkGreyColor),
      );

  static TextStyle get bodySmall => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(kcMediumGrey),
      );

  // Buttons
  static TextStyle get button => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  // Labels
  static TextStyle get label => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(kcDarkGreyColor),
      );

  // Captions
  static TextStyle get caption => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: const Color(kcMediumGrey),
      );
}
```

---

## Task 0.8: Setup Lefthook (Pre-commit Linting)

### 0.8.1 Create lefthook.yml
**File:** `lefthook.yml`

```yaml
pre-commit:
  commands:
    flutter-analyze:
      run: bash ./flutter_analyze_wrapper.sh --no-pub
      fail_text: "Flutter analyze found errors. Please fix them and try again."
```

### 0.8.2 Create flutter_analyze_wrapper.sh
**File:** `flutter_analyze_wrapper.sh`

Copy from pet_app project but update the dart SDK path to be dynamic:

```bash
#!/bin/bash
# Wrapper to run dart analyze avoiding cache permission issues

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Filter out --no-pub flag which dart analyze doesn't support
args=$(echo "$@" | sed 's/--no-pub//g')

# Find dart binary from flutter
DART_BIN=$(which dart 2>/dev/null || echo "dart")

output=$($DART_BIN analyze --no-fatal-warnings $args 2>&1)
exit_code=$?

# Filter telemetry/permission noise
filtered=$(echo "$output" | grep -v "FileSystemException" | grep -v "dart-flutter-telemetry" | grep -v -i "operation not permitted" | grep -v "setLastModifiedSync" | grep -v "UserProperty" | grep -v "#[0-9]" | grep -v "asynchronous suspension" | grep -v "^$")

echo "$filtered"

if echo "$filtered" | grep -q -E "(error|warning)" && [ "$exit_code" -ne 0 ]; then
  exit 1
fi

if echo "$filtered" | grep -q "issues found" && ! echo "$filtered" | grep -q "No issues found"; then
  if echo "$filtered" | grep -q -E "error|warning"; then
    exit 1
  fi
fi

exit 0
```

Make executable: `chmod +x flutter_analyze_wrapper.sh`

### 0.8.3 Install lefthook
Run: `lefthook install`

---

## Task 0.9: Fix Existing Code for very_good_analysis

After switching to `very_good_analysis`, the existing code will have lint violations. Fix them:

### Common fixes needed:
1. **Max line length 80 chars** — break long lines
2. **Explicit types on properties** — add type annotations where inferred
3. **`unawaited()` for fire-and-forget futures** — wrap in `unawaited()`
4. **`back<void>()`** — add type param to generic calls
5. **One class per file** — extract inline private widgets to `widgets/` subdirectory
6. **Remove unused imports**
7. **Prefer const constructors** where possible

### Process:
1. Run `flutter analyze`
2. Fix all errors and warnings
3. Run `flutter analyze` again until clean
4. Commit fixes

---

## Task 0.10: Restructure Existing Views to Follow pet_app Pattern

### 0.10.1 Extract Inline Widgets

For each existing view, check for private helper widgets defined inline. Move them to a `widgets/` subdirectory:

Example: If `home_view.dart` has `_AppointmentCard` widget inside it:
1. Create `lib/ui/views/home/widgets/appointment_card.dart`
2. Move the widget there, rename to `AppointmentCard` (remove underscore)
3. Import in `home_view.dart`

Apply to all views:
- `home/` → extract sections into `home/widgets/`
- `schedule/` → extract sections into `schedule/widgets/`
- `patient_profile/` → widgets already partially extracted, verify
- `patient_registry/` → extract card widgets
- `appointment_detail/` → extract sections
- `doctor_profile/` → extract sections
- `login/` → extract form widgets
- `verify_otp/` → keep or remove (OTP not used for clinic roles)

### 0.10.2 Move Shared Widgets to common/

Move reusable widgets used across multiple views to `lib/ui/widgets/common/`:
- `AppTextField` (styled text input)
- `PrimaryButton` (green button with loading)
- `StatusBadge` (appointment status)
- `BottomSheetHandle` (drag handle)
- Any other shared widgets

Each widget in its own file, one public class per file.

---

## Task 0.11: Create CLAUDE.md

**File:** `CLAUDE.md` (project root)

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Commands

\```bash
# Run the app (requires .env.json — copy from .env.json.example)
flutter run --dart-define-from-file=.env.json

# Run all tests
flutter test

# Run a single test file
flutter test test/viewmodels/home_viewmodel_test.dart

# Run with coverage
flutter test --coverage

# Update golden test screenshots
flutter test --update-goldens

# Analyze code (strict via very_good_analysis)
flutter analyze

# Regenerate Stacked code (router, locator, mocks)
dart run build_runner build --delete-conflicting-outputs

# Setup git hooks
lefthook install
\```

## Architecture

This app uses the **Stacked** framework with MVVM + service locator (get_it) pattern.

### Layer Responsibilities

- **`lib/app/`** — App-level configuration. `app.dart` is the single source of truth for routes, DI registrations, dialogs, and bottom sheets. `app.locator.dart` and `app.router.dart` are auto-generated — do not edit them directly.
- **`lib/core/`** — Shared foundational code: config, constants, enums, models, and utils.
- **`lib/services/`** — Business logic and external integrations. All services are registered as `LazySingleton` in `app.dart` and accessed via `locator<ServiceType>()`.
- **`lib/ui/views/<name>/`** — Each screen is a pair: `*_view.dart` (UI only, no logic) and `*_viewmodel.dart` (logic, state, navigation via `NavigationService`).
- **`lib/ui/widgets/common/`** — Shared reusable widgets.

### Roles

This app supports three clinic-side roles:
- **clinic_admin** — Full clinic management (settings, staff, appointments, records, reminders, reports)
- **veterinarian** — Clinical work (own appointments, medical records, prescriptions, vaccinations)
- **staff** — Front desk (all appointments, pet owner management, documents)

Authentication is email+password (not OTP). The backend auto-scopes data by clinicId from the JWT.

### Adding a New Screen

1. Create `lib/ui/views/<name>/<name>_view.dart` and `<name>_viewmodel.dart`
2. Add a `MaterialRoute` entry to `lib/app/app.dart`
3. Run `dart run build_runner build --delete-conflicting-outputs`

### Adding a New Service

1. Create `lib/services/<name>_service.dart`
2. Add a `LazySingleton` entry to `lib/app/app.dart`
3. Add a `MockSpec` to `test/helpers/test_helpers.dart` and a `getAndRegister*` helper
4. Run `dart run build_runner build --delete-conflicting-outputs`

### API & Environment

- API base URL injected at compile time from `.env.json` (not committed; copy from `.env.json.example`)
- `lib/core/config/api_config.dart` reads `API_BASE_URL` via `--dart-define-from-file`
- Default `http://10.0.2.2:3000` targets Android emulator's host machine
- `ApiClient` (`lib/services/api_client.dart`) wraps Dio, auto-injects Bearer token, handles 401 refresh

### Auth Flow

`LoginView` → email+password → `AuthService.login()` → tokens stored in `SecureStorageService` → role-based navigation to `HomeView`

### Code Style

- Linting via `very_good_analysis` (strict). Max line length: 80 characters.
- Generated files excluded from analysis.
- `public_member_api_docs` is disabled (app, not a package).

#### One Class Per File

Every Dart file must contain exactly **one public class**, named after the file.

- `State` classes are exempt — paired with their `StatefulWidget`.
- Private widgets in views → extract to `lib/ui/views/<name>/widgets/` and make public.

### Stacked Forms

Forms use Stacked code-generation:

```
lib/ui/views/<name>/
├── <name>_view.dart         # @FormView annotation + $<Name>View mixin
├── <name>_viewmodel.dart    # extends FormViewModel
├── <name>_view.form.dart    # AUTO-GENERATED
└── <name>_validators.dart   # Static validation functions
```

Always set `autoTextFieldValidation: false`. Validate manually on submit.

### Testing Patterns

- Unit tests: `test/viewmodels/` and `test/services/`
- `registerServices()` in `setUp`, `locator.reset()` in `tearDown`
- Mocks generated by mockito via `test/helpers/test_helpers.dart`
- Golden tests in `test/golden/`
```

---

## Task 0.12: Create Test Helpers Skeleton

**File:** `test/helpers/test_helpers.dart`

Create the mock registration pattern matching pet_app:

```dart
import 'package:mockito/annotations.dart';
import 'package:partner/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

// @stacked-mock-spec
@GenerateNiceMocks([
  MockSpec<NavigationService>(),
  MockSpec<DialogService>(),
  MockSpec<BottomSheetService>(),
  MockSpec<SnackbarService>(),
  // Add more as services are created
])
void registerServices() {
  getAndRegisterNavigationServiceMock();
  getAndRegisterDialogServiceMock();
  getAndRegisterBottomSheetServiceMock();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

MockNavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

// ... repeat for each service
```

Run: `dart run build_runner build --delete-conflicting-outputs`

---

## Task 0.13: Update main.dart

**Modify:** `lib/main.dart`

Align with pet_app pattern:

```dart
import 'package:flutter/material.dart';
import 'package:partner/app/app.bottomsheets.dart';
import 'package:partner/app/app.dialogs.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Partner',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
    );
  }
}
```

---

## Verification Checklist

After completing Phase 0:

- [ ] `flutter pub get` succeeds with all new dependencies
- [ ] `analysis_options.yaml` uses `very_good_analysis`
- [ ] `flutter analyze` runs clean (no errors or warnings)
- [ ] `stacked.json` matches pet_app configuration
- [ ] `.env.json` and `.env.json.example` exist
- [ ] `.env.json` is in `.gitignore`
- [ ] `api_config.dart` reads from `--dart-define-from-file`
- [ ] Folder structure matches: `core/config/`, `core/enums/`, `core/models/`, `core/utils/`, `services/`
- [ ] `ui_helpers.dart` moved to `core/utils/` with imports updated
- [ ] `app_text_styles.dart` created with centralized text styles
- [ ] `app_constants.dart` created with app-wide constants
- [ ] `lefthook.yml` and `flutter_analyze_wrapper.sh` created
- [ ] `lefthook install` succeeds
- [ ] `CLAUDE.md` created at project root
- [ ] All existing views have inline widgets extracted to `widgets/` subdirectories
- [ ] One public class per file convention followed in all existing code
- [ ] `test/helpers/test_helpers.dart` created with mock pattern
- [ ] `main.dart` follows pet_app pattern
- [ ] `dart run build_runner build --delete-conflicting-outputs` succeeds
- [ ] App compiles and runs with `flutter run --dart-define-from-file=.env.json`
