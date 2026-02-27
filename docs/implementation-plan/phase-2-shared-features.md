# Phase 2: Shared Features (Pets & Appointments)

## Goal
Implement the pet and appointment features that are shared across all three roles. Connect the existing UI screens to real API data. After this phase, users can view/manage pets and appointments with proper API integration.

**Depends on:** Phase 1 (Foundation & Auth) must be complete.

---

## Task 2.1: Create Pet Service

**File:** `lib/services/pet_service.dart`

Methods:
- `getPets({int page, int limit, String? species, bool? isActive})` → PaginatedResponse<Pet>
  - GET `/api/pets` with query params
  - Clinic-scoped on backend (auto-filtered by user's clinicId)
- `getPetById(String petId)` → Pet
  - GET `/api/pets/{petId}`
- `createPet(Map<String, dynamic> data)` → Pet
  - POST `/api/pets`
  - Used by: clinic_admin, staff, veterinarian
- `updatePet(String petId, Map<String, dynamic> data)` → Pet
  - PATCH `/api/pets/{petId}`
- `deletePet(String petId)` → void
  - DELETE `/api/pets/{petId}` (soft delete)
- `getPetMedicalSummary(String petId)` → Map<String, dynamic>
  - GET `/api/pets/{petId}/medical-summary`

Register in app.locator as LazySingleton.

---

## Task 2.2: Create Pet Owner Service

**File:** `lib/services/pet_owner_service.dart`

Methods:
- `getPetOwners({int page, int limit, String? search})` → PaginatedResponse<PetOwner>
  - GET `/api/pet-owners` with query params
- `getPetOwnerById(String ownerId)` → PetOwner
  - GET `/api/pet-owners/{ownerId}`
- `createPetOwner(Map<String, dynamic> data)` → PetOwner
  - POST `/api/pet-owners`
- `updatePetOwner(String ownerId, Map<String, dynamic> data)` → PetOwner
  - PATCH `/api/pet-owners/{ownerId}`
- `lookupByPhone(String phone)` → PetOwner?
  - GET `/api/pet-owners/lookup-by-phone?phone={phone}`
  - Returns null if not found
- `quickCreate(Map<String, dynamic> data)` → PetOwner
  - POST `/api/pet-owners/quick-create`

Register in app.locator as LazySingleton.

---

## Task 2.3: Create Appointment Service

**File:** `lib/services/appointment_service.dart`

Methods:
- `getAppointments({int page, int limit, String? status, String? petId, String? veterinarianId, String? date})` → PaginatedResponse<Appointment>
  - GET `/api/appointments` with query params
  - For veterinarians: backend auto-filters to their assigned appointments
- `getAppointmentById(String appointmentId)` → Appointment
  - GET `/api/appointments/{appointmentId}`
- `createAppointment(Map<String, dynamic> data)` → Appointment
  - POST `/api/appointments`
  - Used by: clinic_admin, staff
- `updateAppointment(String appointmentId, Map<String, dynamic> data)` → Appointment
  - PATCH `/api/appointments/{appointmentId}`
- `updateAppointmentStatus(String appointmentId, String status)` → Appointment
  - PATCH `/api/appointments/{appointmentId}/status`
  - Body: `{ "status": status }`
- `approveAppointment(String appointmentId)` → Appointment
  - PATCH `/api/appointments/{appointmentId}/approve`
- `getPendingAppointments({int page, int limit})` → PaginatedResponse<Appointment>
  - GET `/api/appointments/pending`
- `getAvailability({required String clinicId, String? vetId, required String date, int? slotDuration})` → List<TimeSlot>
  - GET `/api/appointments/availability`
- `getAppointmentHistory(String appointmentId)` → List<AppointmentHistoryEntry>
  - GET `/api/appointments/{appointmentId}/history`

Register in app.locator as LazySingleton.

---

## Task 2.4: Connect Patient Registry to API

**Modify:** `lib/ui/views/patient_registry/patient_registry_view.dart` and `patient_registry_viewmodel.dart`

### ViewModel Changes:
- Inject `PetService`
- Replace hardcoded pet list with API data
- Properties:
  - `List<Pet> pets = []`
  - `bool isLoading = true`
  - `bool isLoadingMore = false`
  - `String? errorMessage`
  - `String searchQuery = ''`
  - `int currentPage = 1`
  - `bool hasMore = true`
- Methods:
  - `initialise()` → Call `loadPets()`
  - `loadPets()` → Fetch first page from API
  - `loadMorePets()` → Fetch next page (pagination)
  - `searchPets(String query)` → Debounced search
  - `refresh()` → Reset and reload
  - `onPetTapped(Pet pet)` → Navigate to patient profile with petId

### View Changes:
- Show shimmer loading while `isLoading` is true
- Show error state with retry if `errorMessage` is set
- Show empty state if pets list is empty
- Implement pull-to-refresh
- Implement infinite scroll for pagination
- Display pet data from model (name, breed, species, weight, photoUrl)
- Show owner name if available
- Role-based FAB: show "Add Pet" button for roles with `pets:create` permission

---

## Task 2.5: Connect Patient Profile to API

**Modify:** `lib/ui/views/patient_profile/patient_profile_view.dart` and `patient_profile_viewmodel.dart`

### ViewModel Changes:
- Accept `petId` as constructor parameter (passed via navigation)
- Inject `PetService`
- Properties:
  - `Pet? pet`
  - `bool isLoading = true`
  - `String? errorMessage`
  - `int currentTabIndex = 0` (keep existing)
- Methods:
  - `initialise()` → Fetch pet details by ID
  - `changeTab(int index)` → Switch tabs (existing)

### View Changes:
- Replace hardcoded pet data with `viewModel.pet` fields
- Tabs remain: General, Medical Records, Vaccinations, Lab Reports, Medications
- Tab content will be connected to APIs in later phases (Phase 3 for medical data)
- Show loading shimmer while fetching
- Show error state with retry
- Role-based: Show "Edit" button for roles with `pets:update` permission

---

## Task 2.6: Create Pet Form View (New)

**New files:**
- `lib/ui/views/pet_form/pet_form_view.dart`
- `lib/ui/views/pet_form/pet_form_viewmodel.dart`

### Purpose:
Create/edit pet profiles. Used by clinic_admin, staff, and veterinarian roles.

### ViewModel:
- Accept optional `Pet? pet` parameter (null = create, non-null = edit)
- Accept optional `String? ownerId` parameter (for linking pet to owner)
- Inject `PetService`
- Properties:
  - Form controllers for: name, species, breed, gender, color, dateOfBirth, weight, allergies, chronicConditions, notes
  - `bool isLoading = false`
  - `bool isEditMode` (derived from pet != null)
  - `String? errorMessage`
- Methods:
  - `initialise()` → If editing, populate controllers from pet data
  - `savePet()` → Validate form, call create/update API, navigate back on success

### View:
- Form fields:
  - Name (required)
  - Species (required, dropdown: Dog, Cat, Bird, Rabbit, Other)
  - Breed (text)
  - Gender (radio: Male, Female, Unknown)
  - Color (text)
  - Date of Birth (date picker)
  - Weight + unit (number + dropdown: kg/lbs)
  - Allergies (chip input or comma-separated text)
  - Chronic Conditions (chip input)
  - Notes (multiline text)
  - **Mark as Deceased** (edit mode only):
    - Switch/toggle, shown only if pet is currently alive
    - On toggle: show confirmation dialog "This action cannot be undone. The pet will be marked as deceased and deactivated."
    - On confirm: call `PetService.updatePet(petId, { isDeceased: true })`
    - Backend auto-sets `isActive = false`
    - After marking: navigate back, show snackbar "Pet marked as deceased"
  - **Active/Inactive toggle** (edit mode only, admin only):
    - Switch to deactivate/reactivate pet
    - Not shown if pet is deceased (deceased = permanently inactive)
- Save button with loading state
- AppBar title: "Add Pet" or "Edit Pet"

### Pet Card Visual Indicators:
Update pet cards across the app to show:
- **Deceased pets:** Greyed out card with "Deceased" badge, memorial icon
- **Inactive pets:** Dimmed with "Inactive" label
- **Active pets:** Normal display (default)

### Route Registration:
Add to `app.dart`:
```dart
MaterialRoute(page: PetFormView, path: '/pet-form-view')
```

---

## Task 2.7: Connect Schedule View to API

**Modify:** `lib/ui/views/schedule/schedule_view.dart` and `schedule_viewmodel.dart`

### ViewModel Changes:
- Inject `AppointmentService` and `AuthService`
- Properties:
  - `List<Appointment> appointments = []`
  - `DateTime selectedDate = DateTime.now()`
  - `bool isLoading = true`
  - `String? errorMessage`
- Methods:
  - `initialise()` → Load appointments for today
  - `onDateSelected(DateTime date)` → Update selectedDate, reload appointments
  - `loadAppointments()` → Fetch appointments for selectedDate
    - For veterinarian: API auto-filters to their appointments only
    - For staff/admin: Shows all clinic appointments
  - `onAppointmentTapped(Appointment apt)` → Navigate to appointment detail
  - `refresh()` → Reload

### View Changes:
- Keep existing calendar widget
- Replace hardcoded appointment list with API data
- Show appointment cards with: time, pet name, owner name, vet name, type, status badge
- Show loading shimmer
- Show empty state for dates with no appointments
- Role-based: Show "Add Appointment" FAB for staff and clinic_admin only

---

## Task 2.8: Connect Appointment Detail View to API

**Modify:** `lib/ui/views/appointment_detail/appointment_detail_view.dart` and `appointment_detail_viewmodel.dart`

### ViewModel Changes:
- Accept `appointmentId` as constructor parameter
- Inject `AppointmentService`, `AuthService`
- Properties:
  - `Appointment? appointment`
  - `bool isLoading = true`
  - `String? errorMessage`
  - `UserRole? currentRole`
- Methods:
  - `initialise()` → Fetch appointment details
  - `updateStatus(AppointmentStatus newStatus)` → Call status update API
  - `approveAppointment()` → Call approve API (admin/staff only)

### View Changes:
- Replace hardcoded data with `viewModel.appointment`
- Display: title, description, type, status, scheduled time, duration
- Show pet info section (name, species, breed, photo)
- Show owner info section (name, phone)
- Show veterinarian info section (name, specialization)
- Show pre/post appointment notes
- Role-based action buttons:
  - **Clinic Admin / Staff:**
    - "Check In" (pending/confirmed → checked_in)
    - "Start" (checked_in → in_progress)
    - "Complete" (in_progress → completed)
    - "Cancel" with reason dialog
    - "Approve" for pending appointments
  - **Veterinarian:**
    - "Start Consult" (checked_in → in_progress)
    - "Complete" (in_progress → completed)
    - "Add Medical Record" → Navigate to medical record form (Phase 3)
- Show appointment history timeline (expandable section)

---

## Task 2.9: Create Appointment Form View (New)

**New files:**
- `lib/ui/views/appointment_form/appointment_form_view.dart`
- `lib/ui/views/appointment_form/appointment_form_viewmodel.dart`

### Purpose:
Create/edit appointments. Used by clinic_admin and staff roles.

### ViewModel:
- Accept optional `Appointment? appointment` (null = create, non-null = edit)
- Inject `AppointmentService`, `PetService`, `PetOwnerService`
- Properties:
  - Form controllers for: title, description, appointmentType, scheduledStart, scheduledEnd, durationMinutes, roomNumber, preAppointmentNotes
  - `PetOwner? selectedOwner`
  - `Pet? selectedPet`
  - `User? selectedVet`
  - `List<Pet> availablePets = []`
  - `bool isLoading = false`
- Methods:
  - `searchOwnerByPhone(String phone)` → Lookup pet owner, populate availablePets
  - `selectOwner(PetOwner owner)` → Set owner, fetch their pets
  - `selectPet(Pet pet)` → Set pet
  - `selectVet(User vet)` → Set veterinarian
  - `saveAppointment()` → Validate, call API, navigate back

### View:
- Pet Owner selection:
  - Phone lookup field with search button
  - Show owner card if found
  - "Quick Create" button if not found → opens pet owner quick create form
- Pet selection:
  - Dropdown of owner's pets
  - "Add Pet" button to create new
- Veterinarian selection (optional):
  - Dropdown of clinic veterinarians
- Appointment details:
  - Title (text)
  - Type (dropdown: checkup, vaccination, dental, grooming, surgery, emergency)
  - Date picker
  - Time picker (start)
  - Duration (dropdown: 15, 30, 45, 60 min)
  - Room number (optional text)
  - Pre-appointment notes (multiline text)
- Save button

### Route Registration:
Add to `app.dart`:
```dart
MaterialRoute(page: AppointmentFormView, path: '/appointment-form-view')
```

---

## Task 2.10: Booking Success View (New)

**New files:**
- `lib/ui/views/booking_success/booking_success_view.dart`
- `lib/ui/views/booking_success/booking_success_viewmodel.dart`

### Purpose:
Confirmation screen shown after successfully creating or rescheduling an appointment. Follows the pet_app pattern (`BookingSuccessView`).

### ViewModel:
- Accept `Appointment appointment` parameter (the created appointment)
- Inject `NavigationService`, `LayoutService`
- Methods:
  - `goToHome()` → `_navigationService.clearStackAndShow(Routes.mainView)`
  - `viewAppointment()` → Navigate to appointment detail
  - `addToCalendar()` → Use `add_2_calendar` package to add event to device calendar (optional)

### View Layout:
- Success icon/animation (green checkmark)
- "Appointment Booked!" title
- Appointment summary card:
  - Pet name + photo
  - Date and time
  - Veterinarian name (if assigned)
  - Appointment type
  - Status: "Pending Approval" badge
- Action buttons:
  - "View Appointment" (outlined button)
  - "Back to Home" (primary button)
- Note text: "Your appointment is pending approval by clinic staff"

### Navigation:
- From `AppointmentFormView` on save success → push `BookingSuccessView`
- Back button disabled (use action buttons to navigate)

### Route Registration:
```dart
MaterialRoute(page: BookingSuccessView, path: '/booking-success-view')
```

---

## Task 2.11: Create Pending Appointments View (New)

**New files:**
- `lib/ui/views/pending_appointments/pending_appointments_view.dart`
- `lib/ui/views/pending_appointments/pending_appointments_viewmodel.dart`

### Purpose:
Show pending appointment requests from pet owners for clinic_admin and staff to approve/reject.

### ViewModel:
- Inject `AppointmentService`
- Properties:
  - `List<Appointment> pendingAppointments = []`
  - `bool isLoading = true`
  - `int currentPage = 1`
  - `bool hasMore = true`
- Methods:
  - `initialise()` → Load pending appointments
  - `loadMore()` → Pagination
  - `approveAppointment(String id)` → Call approve API, remove from list
  - `rejectAppointment(String id)` → Cancel with reason, remove from list
  - `viewDetails(Appointment apt)` → Navigate to appointment detail

### View:
- List of pending appointment cards
- Each card shows: pet name, owner name, requested time, type
- Swipe actions or buttons: Approve (green), Reject (red)
- Pull-to-refresh
- Empty state: "No pending appointment requests"
- Badge count on this view accessible from home dashboard

### Route Registration:
Add to `app.dart`:
```dart
MaterialRoute(page: PendingAppointmentsView, path: '/pending-appointments-view')
```

---

## Task 2.12: Connect Doctor Profile View to API

**Modify:** `lib/ui/views/doctor_profile/doctor_profile_view.dart` and `doctor_profile_viewmodel.dart`

### ViewModel Changes:
- Inject `AuthService`, `StorageService`
- Properties:
  - `User? currentUser`
  - `bool isLoading = true`
- Methods:
  - `initialise()` → Fetch profile from `/api/profile`
  - `logout()` → Call authService.logout()
  - Toggle notification preferences (keep existing, save to SharedPreferences for now)
  - `updateProfile(Map<String, dynamic> data)` → PUT `/api/profile`

### View Changes:
- Display user data: name, email, phone, avatar, role
- For veterinarian: show specialization and bio
- Keep notification toggles
- Add "Edit Profile" option
- Logout button (existing)

---

## Task 2.13: Update Stacked Configuration

**Modify:** `lib/app/app.dart`

Add all new routes and services:

```dart
@StackedApp(
  routes: [
    // Existing routes
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: MainView),            // NEW — bottom nav container
    MaterialRoute(page: HomeView),
    MaterialRoute(page: ScheduleView),
    MaterialRoute(page: PatientRegistryView),
    MaterialRoute(page: PatientProfileView),
    MaterialRoute(page: AppointmentDetailView),
    MaterialRoute(page: DoctorProfileView),
    // New routes (Phase 2)
    MaterialRoute(page: PetFormView),
    MaterialRoute(page: AppointmentFormView),
    MaterialRoute(page: BookingSuccessView),   // NEW — post-booking confirmation
    MaterialRoute(page: PendingAppointmentsView),
  ],
  dependencies: [
    // Existing
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: NavigationService),
    // Phase 1
    LazySingleton(classType: SecureStorageService),
    LazySingleton(classType: SharedPreferencesService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: LayoutService),
    // Phase 2
    LazySingleton(classType: PetService),
    LazySingleton(classType: PetOwnerService),
    LazySingleton(classType: AppointmentService),
  ],
)
```

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Task 2.14: Reusable Widgets

Create shared widgets used across the views above:

### 2.13.1 Appointment Card Widget
**File:** `lib/ui/widgets/appointment_card.dart`

Displays appointment summary in a card:
- Time slot (start - end)
- Pet name + species icon
- Owner name
- Veterinarian name
- Status badge (color-coded)
- Appointment type
- onTap callback

### 2.13.2 Pet Card Widget
**File:** `lib/ui/widgets/pet_card.dart`

Displays pet summary in a card:
- Pet photo (cached_network_image with placeholder)
- Name, species, breed
- Age (calculated from dateOfBirth)
- Weight
- Owner name
- Active/Inactive/Deceased indicator
- onTap callback

### 2.13.3 Status Badge Widget
**File:** `lib/ui/widgets/status_badge.dart`

Color-coded badge for appointment status:
- pending → orange
- scheduled → blue
- confirmed → teal
- checked_in → blue
- in_progress → green (kcPrimaryColor)
- completed → grey
- cancelled → red
- no_show → dark grey

### 2.13.4 Empty State Widget
**File:** `lib/ui/widgets/empty_state.dart`

- Icon
- Title text
- Description text
- Optional action button

### 2.13.5 Error State Widget
**File:** `lib/ui/widgets/error_state.dart`

- Error icon
- Error message
- "Retry" button with callback

### 2.13.6 Loading Shimmer Widget
**File:** `lib/ui/widgets/loading_shimmer.dart`

Shimmer placeholder for:
- List items (card-shaped shimmer)
- Detail views (text block shimmer)
- Configurable count

---

## Verification Checklist

After completing Phase 2:

- [ ] PetService fetches paginated pet list from API
- [ ] Patient Registry shows real pet data with pagination and search
- [ ] Patient Profile loads pet details by ID
- [ ] Pet Form creates and edits pets successfully
- [ ] AppointmentService fetches appointments from API
- [ ] Schedule view shows appointments for selected date
- [ ] Appointment Detail shows full appointment data
- [ ] Appointment status can be updated (check-in, start, complete, cancel)
- [ ] Pending appointments can be approved/rejected (admin/staff)
- [ ] Appointment Form creates new appointments
- [ ] Pet owner lookup by phone works
- [ ] Doctor Profile shows real user data
- [ ] Profile can be updated
- [ ] Logout works and clears all stored data
- [ ] All role-based visibility rules work (FABs, action buttons)
- [ ] MainView IndexedStack preserves tab state when switching
- [ ] LayoutService updates bottom nav from any ViewModel
- [ ] Bottom nav items are role-specific (admin: 5, staff: 5, vet: 4)
- [ ] Booking Success screen shown after creating appointment
- [ ] Pet Form has "Mark as Deceased" toggle (edit mode, with confirmation)
- [ ] Deceased/inactive pets show visual indicators in cards
- [ ] Shimmer loading, empty states, and error states work
- [ ] Pull-to-refresh and pagination work on all list views
- [ ] App compiles and runs without errors
