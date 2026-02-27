# Phase 3: Veterinarian Role Features

## Goal
Implement the clinical features used by veterinarians: medical records (create/edit), prescriptions (create/edit/PDF), and vaccinations (create/edit). These features connect to the patient profile tabs and are accessible from the appointment detail view.

**Depends on:** Phase 2 (Shared Features) must be complete.

---

## Task 3.1: Create Medical Record Service

**File:** `lib/services/medical_record_service.dart`

Methods:
- `getMedicalRecords({int page, int limit, String? petId})` → PaginatedResponse<MedicalRecord>
  - GET `/api/medical-records` with query params
  - Clinic-scoped on backend
- `getMedicalRecordById(String recordId)` → MedicalRecord
  - GET `/api/medical-records/{recordId}`
- `createMedicalRecord(Map<String, dynamic> data)` → MedicalRecord
  - POST `/api/medical-records`
  - Required fields: petId, visitDate, visitReason
  - Optional: diagnosis, treatment, notes, weightAtVisit, temperatureAtVisit, appointmentId
  - Backend auto-sets veterinarianId from session
- `updateMedicalRecord(String recordId, Map<String, dynamic> data)` → MedicalRecord
  - PATCH `/api/medical-records/{recordId}`
- `deleteMedicalRecord(String recordId)` → void
  - DELETE `/api/medical-records/{recordId}`
- `getPetMedicalRecords(String petId)` → List<MedicalRecord>
  - GET `/api/pets/{petId}/medical-records`

Register in app.locator as LazySingleton.

---

## Task 3.2: Create Prescription Service

**File:** `lib/services/prescription_service.dart`

Methods:
- `getPrescriptions({int page, int limit, String? petId, String? veterinarianId, String? medicalRecordId, bool? isActive})` → PaginatedResponse<Prescription>
  - GET `/api/prescriptions` with query params
- `getPrescriptionById(String prescriptionId)` → Prescription
  - GET `/api/prescriptions/{prescriptionId}`
- `createPrescription(Map<String, dynamic> data)` → Prescription
  - POST `/api/prescriptions`
  - Fields: petId, medicalRecordId (optional), medicationName, dosage, frequency, duration, instructions, startDate, endDate
- `updatePrescription(String prescriptionId, Map<String, dynamic> data)` → Prescription
  - PATCH `/api/prescriptions/{prescriptionId}`
- `deletePrescription(String prescriptionId)` → void
  - DELETE `/api/prescriptions/{prescriptionId}`
- `downloadPrescriptionPdf(String prescriptionId)` → Uint8List
  - GET `/api/prescriptions/{prescriptionId}/pdf`
  - Returns raw PDF bytes for display or save
- `getPetPrescriptions(String petId)` → List<Prescription>
  - GET `/api/pets/{petId}/prescriptions`

Register in app.locator as LazySingleton.

---

## Task 3.3: Create Vaccination Service

**File:** `lib/services/vaccination_service.dart`

Methods:
- `getVaccinations({int page, int limit, String? petId, String? veterinarianId, String? vaccineName})` → PaginatedResponse<Vaccination>
  - GET `/api/vaccinations` with query params
- `getVaccinationById(String vaccinationId)` → Vaccination
  - GET `/api/vaccinations/{vaccinationId}`
- `createVaccination(Map<String, dynamic> data)` → Vaccination
  - POST `/api/vaccinations`
  - Fields: petId, vaccineName, dateAdministered, nextDueDate, batchNumber, manufacturer, notes
- `updateVaccination(String vaccinationId, Map<String, dynamic> data)` → Vaccination
  - PATCH `/api/vaccinations/{vaccinationId}`
- `deleteVaccination(String vaccinationId)` → void
  - DELETE `/api/vaccinations/{vaccinationId}`
- `getPetVaccinations(String petId)` → List<Vaccination>
  - GET `/api/pets/{petId}/vaccinations`

Register in app.locator as LazySingleton.

---

## Task 3.4: Medical Record Form View (New)

**New files:**
- `lib/ui/views/medical_record_form/medical_record_form_view.dart`
- `lib/ui/views/medical_record_form/medical_record_form_viewmodel.dart`

### Purpose:
Create or edit a medical record. Primary users: veterinarian and clinic_admin.

### ViewModel:
- Accept parameters:
  - `MedicalRecord? record` (null = create, non-null = edit)
  - `String? petId` (required for create, auto-populated for edit)
  - `String? appointmentId` (optional, links record to appointment)
- Inject `MedicalRecordService`, `PetService`
- Properties:
  - Form controllers: visitDate, visitReason, diagnosis, treatment, notes, weightAtVisit, weightUnit, temperatureAtVisit, temperatureUnit
  - `Pet? pet` (fetched for display)
  - `bool isLoading = false`
  - `bool isEditMode`
  - `String? errorMessage`
- Methods:
  - `initialise()` → If editing, populate form. Fetch pet details.
  - `saveRecord()` → Validate form, call API (create or update), navigate back with result
  - `deleteRecord()` → Confirm dialog, call delete, navigate back

### View Layout:
- **Header:** Pet info card (photo, name, species, breed) - read-only
- **Form fields:**
  - Visit Date (date picker, defaults to today)
  - Visit Reason (text, required)
  - Diagnosis (multiline text)
  - Treatment (multiline text)
  - Notes (multiline text)
  - Weight at Visit + Unit (number field + kg/lbs toggle)
  - Temperature at Visit + Unit (number field + celsius/fahrenheit toggle)
- **Actions:**
  - "Save" button (primary)
  - "Delete" button (edit mode only, with confirmation dialog)
- AppBar title: "New Medical Record" or "Edit Medical Record"

### Route Registration:
```dart
MaterialRoute(page: MedicalRecordFormView, path: '/medical-record-form-view')
```

---

## Task 3.5: Medical Record Detail Bottom Sheet (Enhance Existing)

**Modify:** `lib/ui/bottom_sheets/medical_record/medical_record_sheet.dart` and `medical_record_sheet_model.dart`

### Current State:
Existing bottom sheet with hardcoded data.

### Changes:
- Accept `MedicalRecord record` as parameter
- Display all record fields from the model
- Show associated prescriptions (fetched from API)
- Show associated documents (fetched from API)
- Role-based actions:
  - **Veterinarian/Clinic Admin:** "Edit Record" button → Navigate to MedicalRecordFormView
  - **Veterinarian/Clinic Admin:** "Add Prescription" button → Navigate to PrescriptionFormView
  - **Staff:** View only, no edit buttons
- Sections:
  1. Visit Info (date, reason, veterinarian name)
  2. Vitals (weight, temperature)
  3. Diagnosis
  4. Treatment
  5. Notes
  6. Prescriptions list (clickable)
  7. Documents list (clickable)

---

## Task 3.6: Prescription List View (New)

**New files:**
- `lib/ui/views/prescription_list/prescription_list_view.dart`
- `lib/ui/views/prescription_list/prescription_list_viewmodel.dart`

### Purpose:
List prescriptions for a pet or for the clinic. Accessible from patient profile "Medications" tab and from standalone navigation.

### ViewModel:
- Accept optional `String? petId` (filter by pet)
- Inject `PrescriptionService`, `AuthService`
- Properties:
  - `List<Prescription> prescriptions = []`
  - `bool isLoading = true`
  - `int currentPage = 1`
  - `bool hasMore = true`
  - `bool? filterActive` (null = all, true = active, false = inactive)
- Methods:
  - `initialise()` → Load prescriptions
  - `loadMore()` → Pagination
  - `toggleActiveFilter(bool? value)` → Filter active/inactive
  - `onPrescriptionTapped(Prescription p)` → Show detail bottom sheet or navigate
  - `downloadPdf(String prescriptionId)` → Download and open PDF
  - `refresh()` → Reload

### View:
- List of prescription cards showing:
  - Medication name
  - Dosage + frequency
  - Duration (start - end date)
  - Active/Inactive badge
  - Pet name (if not filtered by pet)
  - Prescribing vet name
- Filter chips: All, Active, Inactive
- FAB: "Add Prescription" (veterinarian/clinic_admin only)
- Pull-to-refresh and pagination

### Route Registration:
```dart
MaterialRoute(page: PrescriptionListView, path: '/prescription-list-view')
```

---

## Task 3.7: Prescription Form View (New)

**New files:**
- `lib/ui/views/prescription_form/prescription_form_view.dart`
- `lib/ui/views/prescription_form/prescription_form_viewmodel.dart`

### Purpose:
Create or edit a prescription. Used by veterinarian and clinic_admin.

### ViewModel:
- Accept parameters:
  - `Prescription? prescription` (null = create, non-null = edit)
  - `String? petId` (required for create)
  - `String? medicalRecordId` (optional, links to medical record)
- Inject `PrescriptionService`
- Properties:
  - Form controllers: medicationName, dosage, frequency, duration, instructions, startDate, endDate
  - `bool isLoading = false`
  - `bool isActive = true`
- Methods:
  - `initialise()` → If editing, populate form
  - `savePrescription()` → Validate, call API, navigate back
  - `deletePrescription()` → Confirm dialog, call delete API

### View Layout:
- **Form fields:**
  - Medication Name (text, required)
  - Dosage (text, required - e.g., "10mg")
  - Frequency (text, required - e.g., "Twice daily")
  - Duration (text - e.g., "7 days")
  - Start Date (date picker)
  - End Date (date picker)
  - Instructions (multiline text - e.g., "Take with food")
  - Active toggle (switch)
- **Actions:**
  - "Save" button
  - "Delete" button (edit mode only)
  - "Download PDF" button (edit mode only)

### Route Registration:
```dart
MaterialRoute(page: PrescriptionFormView, path: '/prescription-form-view')
```

---

## Task 3.8: Vaccination List View (New)

**New files:**
- `lib/ui/views/vaccination_list/vaccination_list_view.dart`
- `lib/ui/views/vaccination_list/vaccination_list_viewmodel.dart`

### Purpose:
List vaccination records for a pet. Accessible from patient profile "Vaccinations" tab.

### ViewModel:
- Accept optional `String? petId`
- Inject `VaccinationService`, `AuthService`
- Properties:
  - `List<Vaccination> vaccinations = []`
  - `bool isLoading = true`
  - `int currentPage = 1`
  - `bool hasMore = true`
- Methods:
  - `initialise()` → Load vaccinations
  - `loadMore()` → Pagination
  - `onVaccinationTapped(Vaccination v)` → Show detail or navigate to form
  - `refresh()` → Reload

### View:
- List of vaccination cards showing:
  - Vaccine name
  - Date administered
  - Next due date (with overdue indicator if past due)
  - Batch number
  - Manufacturer
  - Administering vet name
- Color coding:
  - Green: Up to date
  - Orange: Due soon (within 30 days)
  - Red: Overdue
- FAB: "Add Vaccination" (veterinarian/clinic_admin/staff)
- Pull-to-refresh

### Route Registration:
```dart
MaterialRoute(page: VaccinationListView, path: '/vaccination-list-view')
```

---

## Task 3.9: Vaccination Form View (New)

**New files:**
- `lib/ui/views/vaccination_form/vaccination_form_view.dart`
- `lib/ui/views/vaccination_form/vaccination_form_viewmodel.dart`

### Purpose:
Create or edit a vaccination record. Used by veterinarian, clinic_admin, and staff.

### ViewModel:
- Accept parameters:
  - `Vaccination? vaccination` (null = create, non-null = edit)
  - `String? petId` (required for create)
- Inject `VaccinationService`
- Properties:
  - Form controllers: vaccineName, dateAdministered, nextDueDate, batchNumber, manufacturer, notes
  - `bool isLoading = false`
- Methods:
  - `initialise()` → If editing, populate form
  - `saveVaccination()` → Validate, call API, navigate back
  - `deleteVaccination()` → Confirm, call API

### View Layout:
- **Form fields:**
  - Vaccine Name (text, required - e.g., "Rabies", "DHPP", "Bordetella")
  - Date Administered (date picker, defaults to today)
  - Next Due Date (date picker, optional)
  - Batch Number (text, optional)
  - Manufacturer (text, optional)
  - Notes (multiline text, optional)
- **Actions:**
  - "Save" button
  - "Delete" button (edit mode only)

### Route Registration:
```dart
MaterialRoute(page: VaccinationFormView, path: '/vaccination-form-view')
```

---

## Task 3.10: Connect Patient Profile Tabs to API

**Modify:** `lib/ui/views/patient_profile/patient_profile_view.dart` and related widget files

### Tab Connections:

**Tab 1: General Info + Medical Summary** (Enhanced from Phase 2)
- Shows pet details from API
- Below pet info, show **Medical Summary** section:
  - Fetch via `PetService.getPetMedicalSummary(petId)`
  - Display: total visits, last visit date, active prescriptions count, upcoming vaccinations count, known allergies, chronic conditions
  - Quick stats cards: "X Visits", "X Active Rx", "X Vaccines Due"
  - This gives a health-at-a-glance view without switching tabs

**Tab 2: Medical Records**
- Fetch via `MedicalRecordService.getPetMedicalRecords(petId)`
- Show list of medical record cards (date, reason, diagnosis, vet name)
- Tap → Open MedicalRecordSheet bottom sheet
- Role-based: "Add Record" button for vet/admin

**Tab 3: Vaccinations**
- Fetch via `VaccinationService.getPetVaccinations(petId)`
- Show vaccination cards with status indicators
- Tap → Navigate to vaccination detail/edit
- Role-based: "Add Vaccination" for vet/admin/staff

**Tab 4: Prescriptions** (rename from "Lab Reports" or add as separate tab)
- Fetch via `PrescriptionService.getPetPrescriptions(petId)`
- Show prescription cards with active/inactive status
- Tap → Show prescription detail
- Role-based: "Add Prescription" for vet/admin
- "Download PDF" action on each prescription

**Tab 5: Documents** (optional - can be added or merged)
- Will be connected in Phase 4

### ViewModel Changes:
- Inject all three services
- Properties per tab:
  - `List<MedicalRecord> medicalRecords = []`
  - `List<Vaccination> vaccinations = []`
  - `List<Prescription> prescriptions = []`
  - `bool isLoadingMedicalRecords = false`
  - `bool isLoadingVaccinations = false`
  - `bool isLoadingPrescriptions = false`
- Methods:
  - `loadMedicalRecords()` → Called when tab 2 selected
  - `loadVaccinations()` → Called when tab 3 selected
  - `loadPrescriptions()` → Called when tab 4 selected
  - Lazy loading: only fetch when tab is first selected

---

## Task 3.11: Veterinarian Dashboard Enhancements

**Modify:** `lib/ui/views/home/home_view.dart` and `home_viewmodel.dart`

### Veterinarian-specific dashboard content:

**Top Section:**
- Greeting: "Good morning, Dr. {lastName}"
- Today's date
- Stats cards:
  - "My Appointments Today" (count)
  - "Pending Consults" (checked_in count)
  - "Completed Today" (completed count)

**Main Content:**
- "Current/Next Appointment" card (first checked_in or in_progress appointment)
  - "Continue Consult" or "Start Consult" button
- "Today's Schedule" list (remaining appointments for today)
  - Each card tappable → appointment detail
- Quick actions row:
  - "Add Medical Record" → Navigate to form with pet picker
  - "Prescriptions" → Navigate to prescription list

**Data Fetching:**
- `AppointmentService.getAppointments(date: today)` → auto-filtered to vet's appointments
- Stats derived from appointment list by counting statuses

---

## Task 3.12: Update Stacked Configuration

**Modify:** `lib/app/app.dart`

Add new routes and services:
```dart
// New routes
MaterialRoute(page: MedicalRecordFormView),
MaterialRoute(page: PrescriptionListView),
MaterialRoute(page: PrescriptionFormView),
MaterialRoute(page: VaccinationListView),
MaterialRoute(page: VaccinationFormView),

// New services
LazySingleton(classType: MedicalRecordService),
LazySingleton(classType: PrescriptionService),
LazySingleton(classType: VaccinationService),
```

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Verification Checklist

After completing Phase 3:

- [ ] MedicalRecordService CRUD operations work correctly
- [ ] PrescriptionService CRUD operations work correctly
- [ ] VaccinationService CRUD operations work correctly
- [ ] Medical Record Form creates and edits records
- [ ] Medical Record bottom sheet shows full record details with prescriptions
- [ ] Prescription List shows paginated prescriptions with active/inactive filter
- [ ] Prescription Form creates and edits prescriptions
- [ ] Prescription PDF download works
- [ ] Vaccination List shows vaccinations with due date color coding
- [ ] Vaccination Form creates and edits vaccinations
- [ ] Patient Profile tabs load data lazily from API
- [ ] Medical Records tab shows records with "Add" button for vet/admin
- [ ] Vaccinations tab shows records with status indicators
- [ ] Prescriptions tab shows active/inactive with PDF download
- [ ] Vet dashboard shows today's appointments (own only)
- [ ] "Start Consult" and "Continue Consult" work from dashboard
- [ ] Role guards prevent staff from creating medical records
- [ ] Navigation between appointment → medical record form works
- [ ] App compiles and runs without errors
