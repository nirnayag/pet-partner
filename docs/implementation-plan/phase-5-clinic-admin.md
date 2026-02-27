# Phase 5: Clinic Admin Role Features

## Goal
Implement clinic admin features: staff management, clinic settings/branding, reminder management (create/send), and reports/analytics dashboard. The clinic admin has full control over their clinic operations.

**Depends on:** Phase 4 (Staff Features) must be complete.

---

## Task 5.1: Create User Service (Staff Management)

**File:** `lib/services/user_service.dart`

Methods:
- `getUsers({int page, int limit, String? role, bool? isActive})` → PaginatedResponse<User>
  - GET `/api/users` with query params
  - Auto-scoped to clinic on backend
- `getUserById(String userId)` → User
  - GET `/api/users/{userId}`
- `createUser(Map<String, dynamic> data)` → User
  - POST `/api/users`
  - Fields: firstName, lastName, email, password, phone, role (veterinarian/staff), specialization (for vet), bio (for vet)
  - Backend auto-assigns clinicId from admin's session
- `updateUser(String userId, Map<String, dynamic> data)` → User
  - PATCH `/api/users/{userId}`
- `deactivateUser(String userId)` → void
  - DELETE `/api/users/{userId}` (soft delete/deactivate)
- `bulkCreateUsers(List<Map<String, dynamic>> users)` → BulkCreateResult
  - POST `/api/users/bulk`
  - Returns: total, successful, failed, per-row results

Register in app.locator as LazySingleton.

---

## Task 5.2: Create Clinic Service

**File:** `lib/services/clinic_service.dart`

Methods:
- `getClinicInfo()` → Clinic
  - GET `/api/clinic`
  - Returns current user's clinic details
- `updateClinicInfo(Map<String, dynamic> data)` → Clinic
  - PUT `/api/clinic`
  - Fields: name, email, phone, address
- `getClinicSettings()` → Map<String, dynamic>
  - GET `/api/settings`
  - Returns: timezone, appointmentDuration, allowOnlineBooking, notification preferences, etc.
- `updateClinicSettings(Map<String, dynamic> data)` → Map<String, dynamic>
  - PUT `/api/settings`
- `getClinicBranding()` → ClinicBranding
  - GET `/api/branding`
- `updateClinicBranding(Map<String, dynamic> data)` → ClinicBranding
  - PUT `/api/branding`

Register in app.locator as LazySingleton.

---

## Task 5.3: Create Reminder Service

**File:** `lib/services/reminder_service.dart`

Methods:
- `getReminders({int page, int limit, String? status, String? reminderType, String? petId, String? ownerId, String? startDate, String? endDate})` → PaginatedResponse<Reminder>
  - GET `/api/reminders` with query params
- `getReminderById(String reminderId)` → Reminder
  - GET `/api/reminders/{reminderId}`
- `createReminder(Map<String, dynamic> data)` → Reminder
  - POST `/api/reminders`
  - Fields: petId, ownerId, appointmentId (optional), reminderType, title, message, scheduledFor, channels, metadata
- `updateReminder(String reminderId, Map<String, dynamic> data)` → Reminder
  - PATCH `/api/reminders/{reminderId}`
- `deleteReminder(String reminderId)` → void
  - DELETE `/api/reminders/{reminderId}`
- `sendPendingReminders()` → SendResult
  - POST `/api/reminders/send`
  - Returns: total, sent, failed, errors
  - Permission: admin only (reminders:send)

Register in app.locator as LazySingleton.

---

## Task 5.4: Staff List View (New)

**New files:**
- `lib/ui/views/staff_list/staff_list_view.dart`
- `lib/ui/views/staff_list/staff_list_viewmodel.dart`

### Purpose:
Manage clinic staff members. Clinic admin only.

### ViewModel:
- Inject `UserService`
- Properties:
  - `List<User> staffMembers = []`
  - `bool isLoading = true`
  - `int currentPage = 1`
  - `bool hasMore = true`
  - `String? filterRole` (null = all, 'veterinarian', 'staff')
  - `bool? filterActive` (null = all, true = active, false = inactive)
- Methods:
  - `initialise()` → Load staff list
  - `loadMore()` → Pagination
  - `filterByRole(String? role)` → Apply role filter
  - `filterByStatus(bool? active)` → Apply active filter
  - `onStaffTapped(User user)` → Navigate to staff detail/edit
  - `addStaff()` → Navigate to staff form
  - `refresh()` → Reload

### View:
- Filter chips: All, Veterinarians, Staff, Active, Inactive
- List of staff member cards:
  - Avatar (or initials with role-colored background)
  - Full name
  - Role badge (Veterinarian / Staff)
  - Email
  - Phone
  - Active/Inactive indicator
  - Specialization (for vets)
- FAB: "Add Staff Member"
- Pull-to-refresh
- Empty state: "No staff members found"

### Route Registration:
```dart
MaterialRoute(page: StaffListView, path: '/staff-list-view')
```

---

## Task 5.5: Staff Form View (New)

**New files:**
- `lib/ui/views/staff_form/staff_form_view.dart`
- `lib/ui/views/staff_form/staff_form_viewmodel.dart`

### Purpose:
Create or edit a staff member account. Clinic admin only.

### ViewModel:
- Accept optional `User? user` (null = create, non-null = edit)
- Inject `UserService`
- Properties:
  - Form controllers: firstName, lastName, email, phone, password (create only), role, specialization, bio
  - `bool isLoading = false`
  - `bool isEditMode`
  - `String? errorMessage`
  - `String selectedRole = 'staff'`
  - `bool showVetFields = false` (derived from selectedRole == 'veterinarian')
- Methods:
  - `initialise()` → If editing, populate form
  - `onRoleChanged(String role)` → Update selectedRole, toggle vet-specific fields
  - `saveStaff()`:
    - Validate form
    - If creating: Include password, call createUser
    - If editing: Exclude password, call updateUser
    - Navigate back on success
  - `deactivateStaff()` → Confirm dialog, call deactivateUser

### View Layout:
- **Form fields:**
  - First Name (text, required)
  - Last Name (text, required)
  - Email (email, required)
  - Phone (phone, optional)
  - Role (segmented control: Staff / Veterinarian)
  - Password (create mode only, with visibility toggle, min 8 chars)
  - **Veterinarian-specific fields** (shown when role = veterinarian):
    - Specialization (text - e.g., "General Practice", "Surgery", "Dermatology")
    - Bio (multiline text)
- **Actions:**
  - "Save" button
  - "Deactivate" button (edit mode, with confirmation)
  - "Activate" button (if user is currently inactive)

### Route Registration:
```dart
MaterialRoute(page: StaffFormView, path: '/staff-form-view')
```

---

## Task 5.6: Clinic Settings View (New)

**New files:**
- `lib/ui/views/clinic_settings/clinic_settings_view.dart`
- `lib/ui/views/clinic_settings/clinic_settings_viewmodel.dart`

### Purpose:
View and edit clinic information and operational settings. Clinic admin only.

### ViewModel:
- Inject `ClinicService`
- Properties:
  - `Clinic? clinic`
  - `Map<String, dynamic> settings = {}`
  - `bool isLoading = true`
  - `bool isSaving = false`
  - `String? errorMessage`
- Methods:
  - `initialise()` → Fetch clinic info + settings
  - `saveClinicInfo(Map<String, dynamic> data)` → Update clinic info
  - `saveSettings(Map<String, dynamic> data)` → Update settings

### View Layout (Sectioned):

**Section 1: Clinic Information**
- Clinic Name (text)
- Email (text)
- Phone (text)
- Address fields:
  - Street
  - City
  - State
  - Zip Code
  - Country
- "Save" button

**Section 2: Operational Settings**
- Timezone (dropdown)
- Default Appointment Duration (dropdown: 15, 30, 45, 60 min)
- Allow Online Booking (switch)
- "Save" button

**Section 3: Notification Preferences**
- Email notifications (switch)
- SMS notifications (switch)
- "Save" button

### Route Registration:
```dart
MaterialRoute(page: ClinicSettingsView, path: '/clinic-settings-view')
```

---

## Task 5.7: Clinic Branding View (New)

**New files:**
- `lib/ui/views/clinic_branding/clinic_branding_view.dart`
- `lib/ui/views/clinic_branding/clinic_branding_viewmodel.dart`

### Purpose:
Customize clinic branding (logo, colors). Clinic admin only.

### ViewModel:
- Inject `ClinicService`
- Properties:
  - `ClinicBranding? branding`
  - `bool isLoading = true`
  - `bool isSaving = false`
  - `Color? selectedColor`
  - `File? selectedLogo`
- Methods:
  - `initialise()` → Fetch current branding
  - `pickColor()` → Open color picker
  - `pickLogo()` → Open image picker
  - `saveBranding()` → Upload logo if changed, save branding

### View Layout:
- **Logo Section:**
  - Current logo preview (or placeholder)
  - "Change Logo" button (pick from gallery)
  - "Remove Logo" button
- **Color Section:**
  - Primary color display/preview
  - "Change Color" button → Color picker dialog
  - Live preview of selected color applied to sample elements
- **Preview Section:**
  - Mini preview showing how the branding will look (header bar with logo + color)
- "Save" button

### Route Registration:
```dart
MaterialRoute(page: ClinicBrandingView, path: '/clinic-branding-view')
```

---

## Task 5.8: Reminder List View (New)

**New files:**
- `lib/ui/views/reminder_list/reminder_list_view.dart`
- `lib/ui/views/reminder_list/reminder_list_viewmodel.dart`

### Purpose:
View and manage reminders. Admin has full CRUD + send; vet can create/view; staff can create/view.

### ViewModel:
- Inject `ReminderService`, `AuthService`
- Properties:
  - `List<Reminder> reminders = []`
  - `bool isLoading = true`
  - `int currentPage = 1`
  - `bool hasMore = true`
  - `String? filterStatus` (pending, sent, failed)
  - `String? filterType`
  - `UserRole? currentRole`
- Methods:
  - `initialise()` → Load reminders, get current role
  - `loadMore()` → Pagination
  - `filterByStatus(String? status)` → Apply status filter
  - `filterByType(String? type)` → Apply type filter
  - `onReminderTapped(Reminder r)` → Show detail or navigate to form
  - `deleteReminder(String id)` → Confirm + delete (admin only)
  - `sendPendingReminders()` → Call send API, show result (admin only)
  - `refresh()` → Reload

### View:
- Filter chips: All, Pending, Sent, Failed | Type filters
- List of reminder cards:
  - Title
  - Reminder type badge
  - Scheduled date/time
  - Status badge (pending → yellow, sent → green, failed → red)
  - Pet name
  - Owner name
  - Channels (email, sms, push icons)
- **Admin-only actions:**
  - "Send Pending" button in app bar (sends all pending reminders)
  - Delete button on each card
- FAB: "Create Reminder" (admin, vet, staff)
- Pull-to-refresh

### Route Registration:
```dart
MaterialRoute(page: ReminderListView, path: '/reminder-list-view')
```

---

## Task 5.9: Reminder Form View (New)

**New files:**
- `lib/ui/views/reminder_form/reminder_form_view.dart`
- `lib/ui/views/reminder_form/reminder_form_viewmodel.dart`

### Purpose:
Create or edit a reminder. Used by admin (full), vet (create/update), staff (create).

### ViewModel:
- Accept optional `Reminder? reminder` (null = create, non-null = edit)
- Accept optional `String? petId`, `String? ownerId`, `String? appointmentId`
- Inject `ReminderService`, `PetService`, `PetOwnerService`
- Properties:
  - Form controllers: title, message, scheduledFor
  - `String selectedType = 'appointment'`
  - `List<String> selectedChannels = ['email', 'push']`
  - `Pet? selectedPet`
  - `PetOwner? selectedOwner`
  - `bool isLoading = false`
- Methods:
  - `initialise()` → If editing, populate. If pre-filled params, fetch related data.
  - `selectPet()` → Pet picker
  - `selectOwner()` → Owner picker
  - `toggleChannel(String channel)` → Add/remove from selectedChannels
  - `saveReminder()` → Validate, call API, navigate back

### View Layout:
- **Form fields:**
  - Title (text, required)
  - Reminder Type (dropdown: appointment, vaccination, medication, checkup, grooming, deworming, custom)
  - Message (multiline text)
  - Scheduled For (date+time picker)
  - Pet (picker, optional)
  - Owner (picker - auto-set if pet selected and has known owner)
  - Channels (multi-select chips: Email, SMS, Push, In-App)
- **Actions:**
  - "Save" button
  - "Delete" button (edit mode, admin only)

### Route Registration:
```dart
MaterialRoute(page: ReminderFormView, path: '/reminder-form-view')
```

---

## Task 5.10: Reports View (New)

**New files:**
- `lib/ui/views/reports/reports_view.dart`
- `lib/ui/views/reports/reports_viewmodel.dart`

### Purpose:
Clinic-level analytics and reports. Clinic admin only.

### ViewModel:
- Inject `AppointmentService`, `PetService`, `UserService`
- Properties:
  - `Map<String, dynamic> stats = {}`
  - `bool isLoading = true`
  - `String selectedPeriod = 'week'` (week, month, year)
- Methods:
  - `initialise()` → Compute stats from available data
  - `changePeriod(String period)` → Recalculate stats

### View Layout:

**Note:** The backend doesn't have a dedicated analytics endpoint yet. Stats can be computed from existing list endpoints by fetching data and aggregating client-side. This is a simplified version.

**Overview Cards:**
- Total Active Pets
- Total Pet Owners
- Total Staff Members
- Total Appointments (period)

**Appointment Stats Section:**
- Appointments by status (horizontal bar chart or stat cards):
  - Completed: X
  - Cancelled: X
  - No Show: X
- Appointments by type (pie chart or grid):
  - Checkup: X
  - Vaccination: X
  - Surgery: X
  - etc.

**Staff Performance (optional):**
- Appointments per veterinarian
- Simple table: Vet Name | Appointments | Completed

**Period Selector:**
- Segmented control: This Week / This Month / This Year

### Route Registration:
```dart
MaterialRoute(page: ReportsView, path: '/reports-view')
```

---

## Task 5.11: Clinic Admin Dashboard Enhancements

**Modify:** `lib/ui/views/home/home_view.dart` and `home_viewmodel.dart`

### Admin-specific dashboard content:

**Top Section:**
- Greeting: "Good morning, {firstName}"
- Clinic name subtitle
- Today's date

**Stats Overview Cards:**
- Today's Appointments (count)
- Pending Approval (count, tappable → pending appointments)
- Active Pets (count)
- Staff Members (count)

**Main Content Sections:**

**Section 1: Pending Actions**
- Pending appointment requests (top 3)
- "View All" → Pending Appointments View
- Quick approve/reject buttons

**Section 2: Today's Schedule**
- All appointments for today
- Tap → appointment detail

**Section 3: Quick Actions Grid**
- "Manage Staff" → Staff List
- "Clinic Settings" → Clinic Settings
- "Reminders" → Reminder List
- "Reports" → Reports View
- "Pet Owners" → Pet Owner List
- "Documents" → Document List

---

## Task 5.12: Admin Bottom Navigation

**Modify:** Home view bottom navigation for clinic_admin role

### Admin Bottom Navigation Items:
1. **Home** (dashboard) - Home icon
2. **Patients** (pet registry) - Pets icon
3. **+** (FAB - new appointment) - Add icon
4. **Staff** (staff list) - People icon
5. **Settings** (clinic settings menu) - Settings icon

The Settings tab could be a menu/page with links to:
- Clinic Settings
- Clinic Branding
- My Profile
- Reminders
- Reports
- Logout

---

## Task 5.13: Update Stacked Configuration

**Modify:** `lib/app/app.dart`

Add new routes and services:
```dart
// New routes
MaterialRoute(page: StaffListView),
MaterialRoute(page: StaffFormView),
MaterialRoute(page: ClinicSettingsView),
MaterialRoute(page: ClinicBrandingView),
MaterialRoute(page: ReminderListView),
MaterialRoute(page: ReminderFormView),
MaterialRoute(page: ReportsView),

// New services
LazySingleton(classType: UserService),
LazySingleton(classType: ClinicService),
LazySingleton(classType: ReminderService),
```

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Task 5.14: Add Color Picker Dependency

**File:** `pubspec.yaml`

Add:
```yaml
dependencies:
  flutter_colorpicker: ^1.0.3   # Color picker for branding
```

Run: `flutter pub get`

---

## Verification Checklist

After completing Phase 5:

- [ ] UserService CRUD operations work for staff members
- [ ] Staff List shows clinic staff with role/status filters
- [ ] Staff Form creates new staff (with password) and edits existing
- [ ] Staff can be deactivated/reactivated
- [ ] Vet-specific fields (specialization, bio) show when role = veterinarian
- [ ] ClinicService fetches and updates clinic info
- [ ] Clinic Settings view shows and saves clinic info + operational settings
- [ ] Clinic Branding view shows and saves logo + primary color
- [ ] ReminderService CRUD operations work
- [ ] Reminder List shows reminders with status/type filters
- [ ] Reminder Form creates reminders with type, channels, and scheduling
- [ ] "Send Pending" button sends all pending reminders (admin only)
- [ ] Reports view shows aggregated stats
- [ ] Period selector (week/month/year) changes report data
- [ ] Admin dashboard shows stats, pending actions, today's schedule, quick actions
- [ ] Admin bottom navigation has correct items (Home, Patients, +, Staff, Settings)
- [ ] Settings menu links to all admin-specific views
- [ ] Role guards prevent non-admin from accessing staff management, settings, reports
- [ ] App compiles and runs without errors
