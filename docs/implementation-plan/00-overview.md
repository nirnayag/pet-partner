# Pet Partner - Flutter Implementation Plan Overview

## Current State

The Flutter app currently has:
- 10 UI screens (startup, login, register, OTP verify, home, schedule, patient registry, patient profile, appointment detail, doctor profile)
- Stacked MVVM architecture with code generation
- Green veterinary theme with Manrope font
- Bottom navigation (Home, Patients, Calendar, Profile)
- **No API integration** - all data is hardcoded
- **No models/entities** defined
- **No authentication** - placeholder flows only
- **No local storage** for tokens or preferences

## Target State

Multi-role Flutter application supporting three clinic-side roles:
1. **Clinic Admin** - Full clinic management (settings, staff, appointments, records, reports)
2. **Staff** - Front desk operations (appointments, patients, documents)
3. **Veterinarian** - Clinical work (appointments, medical records, prescriptions, vaccinations)

## Architecture Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State Management | Stacked (MVVM) | Already in use, keep consistency |
| HTTP Client | Dio | Interceptors for auth tokens, refresh logic, error handling |
| Local Storage | flutter_secure_storage + shared_preferences | Secure for tokens, shared_prefs for settings |
| Code Generation | Stacked Generator | Already configured |
| Image Handling | cached_network_image + image_picker | Cache images, pick from gallery/camera |
| Forms | flutter_form_builder + form_builder_validators | Consistent form handling |
| Date/Time | intl | Already available via flutter_localizations |
| PDF Viewing | flutter_pdfview or syncfusion | View prescription PDFs |
| File Upload | dio multipart | S3 presigned URL pattern |

## Phase Breakdown

| Phase | Name | Description | Files |
|-------|------|-------------|-------|
| 0 | Project Restructure | Align with pet_app conventions, upgrade linting, CLAUDE.md, lefthook, folder structure | [phase-0-project-restructure.md](./phase-0-project-restructure.md) |
| 1 | Foundation & Auth | Core infrastructure, models, API client, authentication | [phase-1-foundation.md](./phase-1-foundation.md) |
| 2 | Shared Features | Pets, appointments (shared across roles), navigation | [phase-2-shared-features.md](./phase-2-shared-features.md) |
| 3 | Veterinarian Role | Medical records, prescriptions, vaccinations | [phase-3-veterinarian.md](./phase-3-veterinarian.md) |
| 4 | Staff Role | Front desk operations, documents, pet owner management | [phase-4-staff.md](./phase-4-staff.md) |
| 5 | Clinic Admin Role | Clinic settings, staff management, reports, reminders | [phase-5-clinic-admin.md](./phase-5-clinic-admin.md) |
| 6 | Polish & Cross-cutting | Error handling, offline hints, image uploads, search, notifications | [phase-6-polish.md](./phase-6-polish.md) |

**Dependency graph and parallel execution strategy:** [dependency-graph.md](./dependency-graph.md)

## Reference Project

This project follows the architecture and conventions of the **pet_app** project at:
`/Users/lokeshkumar/Documents/project/flutter/pet_app`

Key conventions inherited:
- **Stacked MVVM** with service locator (`get_it`)
- **very_good_analysis** strict linting (80 char line length)
- **One class per file** (extract private widgets to `widgets/` subdirectory)
- **`@FormView` + `FormViewModel`** for all forms with manual validation
- **`ListenableServiceMixin`** for reactive services
- **`setBusy()`/`setBusyForObject()`** for loading states
- **`lefthook`** pre-commit hook running `flutter analyze`
- **`.env.json` + `--dart-define-from-file`** for environment config
- **`ApiClient`** wrapping Dio with token injection and 401 auto-refresh
- **Test helpers** with `registerServices()`/`locator.reset()` pattern

## Backend API Requirements

Some backend endpoints need to be created before the Flutter app can fully function.
See **[backend-api-requirements.md](./backend-api-requirements.md)** for full specs.

| # | API | Priority | Blocks Flutter? |
|---|-----|----------|-----------------|
| 1 | `POST /api/mobile/auth/login` (email+password → JWT) | **CRITICAL** | Yes — Phase 1 |
| 2 | `GET /api/dashboard` (clinic role dashboard) | Medium | No |
| 3 | `POST /api/mobile/auth/switch-role` + DB migration | Medium | No |
| 4 | `GET /api/reports` (analytics) | Low | No |

## API Base URLs

```
Development: http://localhost:3000
Production: TBD
```

## Authentication Flow (Clinic-side Roles)

Unlike pet owners (who use OTP), clinic-side users authenticate via **email + password**:

```
1. POST /api/mobile/auth/login (NEW endpoint — see backend-api-requirements.md)
   → Returns { accessToken, refreshToken, user }
2. Store tokens in SecureStorageService
3. Token refresh: POST /api/mobile/auth/refresh
4. All subsequent requests: Authorization: Bearer <accessToken>
```

**Backend dependency:** The `POST /api/mobile/auth/login` endpoint must be created first. See [backend-api-requirements.md](./backend-api-requirements.md) API 1.

## Role Switching

A user may hold multiple roles (e.g., a vet who is also clinic admin). The system supports:

- **`user.role`** — the currently active role (used in JWT, determines permissions)
- **`user.roles`** — array of all assigned roles the user can switch between
- **Switch flow:** `POST /api/mobile/auth/switch-role` → returns new tokens with updated role
- **Flutter UI:** Role switcher dropdown in the app bar or profile screen

**Backend dependency:** DB migration + switch-role endpoint. See [backend-api-requirements.md](./backend-api-requirements.md) API 3.

## Role-Permission Matrix (Quick Reference)

| Feature | Clinic Admin | Veterinarian | Staff |
|---------|:---:|:---:|:---:|
| View all clinic appointments | Yes | Own only | Yes |
| Create/manage appointments | Yes | No | Yes |
| Approve pending appointments | Yes | No | Yes |
| View medical records | Yes | Yes | View only |
| Create/edit medical records | Yes | Yes | No |
| Manage prescriptions | Yes | Yes | No |
| Manage vaccinations | Yes | Yes | Yes |
| Upload documents | Yes | Yes | Yes |
| Manage staff | Yes | No | No |
| Clinic settings | Yes | No | No |
| Reports & analytics | Yes | No | No |
| Send reminders | Yes | No | No |
| Create reminders | Yes | Yes | Yes |
| Manage pet owners | Yes | No | Yes (create/view) |

## Folder Structure (Target)

Matches the **pet_app** reference project conventions. Services live at `lib/services/` (not `lib/core/services/`) because the Stacked generator resolves `services_path` relative to `lib/`.

```
lib/
├── main.dart
├── app/
│   ├── app.dart                    # Single source of truth: routes, DI, dialogs, bottom sheets
│   ├── app.router.dart             # AUTO-GENERATED — do not edit
│   ├── app.locator.dart            # AUTO-GENERATED — do not edit
│   ├── app.bottomsheets.dart       # AUTO-GENERATED — do not edit
│   └── app.dialogs.dart            # AUTO-GENERATED — do not edit
├── core/
│   ├── config/
│   │   ├── api_config.dart         # API endpoints + base URL (from .env.json)
│   │   └── app_constants.dart      # App-wide constants (pagination, timeouts, etc.)
│   ├── constants/
│   │   ├── app_colors.dart         # Color palette
│   │   ├── app_text_styles.dart    # Text styles (Google Fonts/Manrope)
│   │   └── app_strings.dart        # String constants
│   ├── enums/
│   │   ├── user_role.dart          # clinic_admin, veterinarian, staff
│   │   ├── appointment_status.dart # pending, scheduled, confirmed, etc.
│   │   ├── reminder_type.dart      # appointment, vaccination, medication, etc.
│   │   └── document_type.dart      # lab_result, xray, intake_form, etc.
│   ├── models/
│   │   ├── auth/                   # Auth-related models (tokens, login response)
│   │   │   ├── user.dart
│   │   │   └── auth_tokens.dart
│   │   ├── pet/                    # Pet-related models
│   │   │   ├── pet.dart
│   │   │   └── paginated_pets.dart
│   │   ├── appointment/            # Appointment models
│   │   │   ├── appointment.dart
│   │   │   └── appointment_detail.dart
│   │   ├── medical/                # Medical records, prescriptions
│   │   │   ├── medical_record.dart
│   │   │   └── prescription.dart
│   │   ├── clinic.dart
│   │   ├── pet_owner.dart
│   │   ├── vaccination.dart
│   │   ├── document.dart
│   │   ├── reminder.dart
│   │   └── pagination.dart         # Reusable pagination model
│   └── utils/
│       ├── ui_helpers.dart         # Spacing constants, responsive sizing
│       ├── date_utils.dart         # Date formatting helpers
│       ├── validators.dart         # Form validation functions
│       └── permission_utils.dart   # Role/permission checking helpers
├── services/                       # Service layer (Stacked generator expects this path)
│   ├── api_client.dart             # Dio wrapper with token injection + 401 refresh
│   ├── secure_storage_service.dart # Token storage (flutter_secure_storage)
│   ├── shared_preferences_service.dart # Non-sensitive prefs
│   ├── auth_service.dart           # Login, logout, token refresh
│   ├── layout_service.dart         # Bottom nav index (ListenableServiceMixin)
│   ├── pet_service.dart            # Pets CRUD (ListenableServiceMixin)
│   ├── pet_owner_service.dart      # Pet owner management
│   ├── appointment_service.dart    # Appointments CRUD + status
│   ├── dashboard_service.dart      # Dashboard data aggregation
│   ├── medical_service.dart        # Medical records + prescriptions + vaccinations
│   ├── document_service.dart       # Document upload/download
│   ├── reminder_service.dart       # Reminders CRUD + send
│   ├── user_service.dart           # Staff management CRUD
│   ├── clinic_service.dart         # Clinic settings, branding
│   └── profile_service.dart        # User profile + avatar upload
├── ui/
│   ├── common/
│   │   └── role_guard.dart         # Widget to conditionally show by role
│   ├── widgets/
│   │   └── common/                 # Shared reusable widgets (one class per file)
│   │       ├── app_textfield.dart
│   │       ├── primary_button.dart
│   │       ├── app_dropdown.dart
│   │       ├── status_badge.dart
│   │       ├── empty_state.dart
│   │       ├── error_state.dart
│   │       ├── loading_shimmer.dart
│   │       ├── pet_card.dart
│   │       ├── appointment_card.dart
│   │       └── bottom_sheet_handle.dart
│   ├── views/
│   │   ├── startup/                # Splash → role-based routing
│   │   ├── auth/
│   │   │   └── login/              # Email+password login
│   │   │       ├── login_view.dart
│   │   │       ├── login_viewmodel.dart
│   │   │       └── widgets/        # Extracted form sections
│   │   ├── home/                   # Role-based dashboard
│   │   │   ├── home_view.dart
│   │   │   ├── home_viewmodel.dart
│   │   │   └── widgets/            # Header, stats, sections per role
│   │   ├── schedule/               # Calendar + appointment list
│   │   │   ├── schedule_view.dart
│   │   │   ├── schedule_viewmodel.dart
│   │   │   └── widgets/
│   │   ├── patient_registry/       # Pet list (all roles)
│   │   ├── patient_profile/        # Pet detail with tabs
│   │   │   └── widgets/
│   │   ├── appointment_detail/     # Single appointment view
│   │   │   └── widgets/
│   │   ├── profile/                # User profile + settings
│   │   │   └── widgets/
│   │   ├── edit_profile/           # @FormView for profile edit
│   │   │
│   │   │── # Veterinarian views
│   │   ├── medical_record_form/    # @FormView create/edit medical record
│   │   ├── prescription_list/
│   │   ├── prescription_form/      # @FormView create/edit prescription
│   │   ├── vaccination_list/
│   │   ├── vaccination_form/       # @FormView create/edit vaccination
│   │   │
│   │   │── # Staff views
│   │   ├── create_appointment/     # @FormView create appointment
│   │   ├── pending_appointments/
│   │   ├── pet_owner_list/
│   │   ├── pet_owner_form/         # @FormView create/edit pet owner
│   │   ├── create_pet/             # @FormView create/edit pet
│   │   ├── document_list/
│   │   ├── document_upload/
│   │   │
│   │   │── # Clinic Admin views
│   │   ├── staff_list/
│   │   ├── staff_form/             # @FormView create/edit staff
│   │   ├── clinic_settings/
│   │   ├── clinic_branding/
│   │   ├── reminder_list/
│   │   ├── reminder_form/          # @FormView create/edit reminder
│   │   └── reports/
│   ├── bottom_sheets/
│   └── dialogs/
├── .env.json                       # Git-ignored, copy from .env.json.example
├── .env.json.example               # Committed template
├── CLAUDE.md                       # Claude Code guidance
├── lefthook.yml                    # Pre-commit hooks
├── flutter_analyze_wrapper.sh      # Linting wrapper script
├── stacked.json                    # Stacked generator config
└── analysis_options.yaml           # very_good_analysis
```
