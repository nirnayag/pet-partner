# Phase 4: Staff Role Features

## Goal
Implement front desk staff features: pet owner management (lookup, quick create, full CRUD), document management (view, upload, download), and staff-specific dashboard. Staff handles the reception workflow: checking in pet owners, managing appointments, and uploading intake documents.

**Depends on:** Phase 3 (Veterinarian Features) must be complete.

---

## Task 4.1: Create Document Service

**File:** `lib/services/document_service.dart`

Methods:
- `getDocuments({int page, int limit, String? petId, String? medicalRecordId, String? documentType, String? startDate, String? endDate})` → PaginatedResponse<Document>
  - GET `/api/documents` with query params
- `getDocumentById(String documentId)` → Document
  - GET `/api/documents/{documentId}`
- `uploadDocument({required File file, required String petId, required String documentType, required String title, String? description, String? medicalRecordId, List<String>? tags})` → Document
  - POST `/api/documents/upload` (multipart/form-data)
  - Use Dio's FormData with MultipartFile
- `updateDocument(String documentId, Map<String, dynamic> data)` → Document
  - PATCH `/api/documents/{documentId}`
  - Updates: title, description, documentType, tags
- `deleteDocument(String documentId)` → void
  - DELETE `/api/documents/{documentId}`
- `downloadDocument(String documentId)` → String (download URL)
  - GET `/api/documents/{documentId}/download`
  - Returns redirect URL or signed URL for file access

Register in app.locator as LazySingleton.

---

## Task 4.2: Pet Owner List View (New)

**New files:**
- `lib/ui/views/pet_owner_list/pet_owner_list_view.dart`
- `lib/ui/views/pet_owner_list/pet_owner_list_viewmodel.dart`

### Purpose:
List all pet owners in the clinic. Used by clinic_admin and staff.

### ViewModel:
- Inject `PetOwnerService`
- Properties:
  - `List<PetOwner> petOwners = []`
  - `bool isLoading = true`
  - `bool isLoadingMore = false`
  - `String searchQuery = ''`
  - `int currentPage = 1`
  - `bool hasMore = true`
  - `String? errorMessage`
- Methods:
  - `initialise()` → Load first page
  - `loadMore()` → Pagination
  - `searchOwners(String query)` → Debounced search (uses search param in API)
  - `onOwnerTapped(PetOwner owner)` → Navigate to pet owner detail
  - `refresh()` → Reset and reload

### View:
- Search bar at top
- List of pet owner cards:
  - Avatar (or initials)
  - Full name
  - Phone number
  - Email (if available)
  - Pet count badge
- FAB: "Add Pet Owner" (staff, admin)
- Pull-to-refresh + infinite scroll
- Empty state: "No pet owners found"

### Route Registration:
```dart
MaterialRoute(page: PetOwnerListView, path: '/pet-owner-list-view')
```

---

## Task 4.3: Pet Owner Detail View (New)

**New files:**
- `lib/ui/views/pet_owner_detail/pet_owner_detail_view.dart`
- `lib/ui/views/pet_owner_detail/pet_owner_detail_viewmodel.dart`

### Purpose:
View pet owner details and their pets. Staff and admin can edit owner info and manage their pets.

### ViewModel:
- Accept `String ownerId` parameter
- Inject `PetOwnerService`, `PetService`
- Properties:
  - `PetOwner? owner`
  - `List<Pet> ownerPets = []`
  - `bool isLoading = true`
  - `String? errorMessage`
- Methods:
  - `initialise()` → Fetch owner details + their pets
  - `editOwner()` → Navigate to pet owner form
  - `addPetForOwner()` → Navigate to pet form with ownerId
  - `viewPet(Pet pet)` → Navigate to patient profile
  - `deactivateOwner()` → Confirm dialog, call delete (soft delete)

### View Layout:
- **Header Section:**
  - Avatar (large)
  - Full name
  - Phone, email
  - Member since date
  - Edit button (icon)
- **Pets Section:**
  - "Pets ({count})" section header
  - Grid or list of pet cards
  - "Add Pet" button
- **Quick Actions:**
  - "Book Appointment" → Navigate to appointment form with owner pre-selected
  - "Call" → Launch phone dialer
  - "Email" → Launch email client

### Route Registration:
```dart
MaterialRoute(page: PetOwnerDetailView, path: '/pet-owner-detail-view')
```

---

## Task 4.4: Pet Owner Form View (New)

**New files:**
- `lib/ui/views/pet_owner_form/pet_owner_form_view.dart`
- `lib/ui/views/pet_owner_form/pet_owner_form_viewmodel.dart`

### Purpose:
Create or edit a pet owner profile. Used by staff and admin.

### ViewModel:
- Accept optional `PetOwner? owner` (null = create, non-null = edit)
- Inject `PetOwnerService`
- Properties:
  - Form controllers: firstName, lastName, phone, email
  - `bool isLoading = false`
  - `bool isEditMode`
  - `String? errorMessage`
- Methods:
  - `initialise()` → If editing, populate form
  - `saveOwner()`:
    - Validate form (phone required, email format if provided)
    - If creating: Check if phone already exists via `lookupByPhone()`
      - If exists: Show dialog "Pet owner already exists" with option to view
      - If not: Call create API
    - If editing: Call update API
    - Navigate back on success
  - `lookupExisting()` → Quick phone lookup before creating

### View Layout:
- **Form fields:**
  - First Name (text, required, 2-50 chars)
  - Last Name (text, required, 2-50 chars)
  - Phone Number (phone input, required)
  - Email (email input, optional)
- **Actions:**
  - "Save" button
  - "Look Up" button (on phone field, check if exists)

### Route Registration:
```dart
MaterialRoute(page: PetOwnerFormView, path: '/pet-owner-form-view')
```

---

## Task 4.5: Document List View (New)

**New files:**
- `lib/ui/views/document_list/document_list_view.dart`
- `lib/ui/views/document_list/document_list_viewmodel.dart`

### Purpose:
View documents for a pet or medical record. Used by all roles (read access varies).

### ViewModel:
- Accept optional parameters: `String? petId`, `String? medicalRecordId`
- Inject `DocumentService`, `AuthService`
- Properties:
  - `List<Document> documents = []`
  - `bool isLoading = true`
  - `int currentPage = 1`
  - `bool hasMore = true`
  - `String? filterDocumentType`
- Methods:
  - `initialise()` → Load documents
  - `loadMore()` → Pagination
  - `filterByType(String? type)` → Apply document type filter
  - `onDocumentTapped(Document doc)` → Open document (download URL in browser/viewer)
  - `downloadDocument(Document doc)` → Get download URL, open externally
  - `refresh()` → Reload

### View:
- Filter chips: All, Lab Results, X-Rays, Intake Forms, Other
- List of document cards:
  - File type icon (PDF, image, etc.)
  - Document name/title
  - Pet name
  - Upload date
  - Uploaded by
  - File size
- Tap → Open/download document
- Long-press or swipe → Show action menu:
  - "Download" → Get download URL, open externally
  - "Edit Details" → Bottom sheet to update title, description, documentType, tags
  - "Delete" → Confirmation dialog, call `DocumentService.deleteDocument()` (vet, admin, or uploader only)
- FAB: "Upload Document" (staff, vet, admin - with `documents:upload` permission)
- Pull-to-refresh

### Route Registration:
```dart
MaterialRoute(page: DocumentListView, path: '/document-list-view')
```

---

## Task 4.6: Document Upload View (New)

**New files:**
- `lib/ui/views/document_upload/document_upload_view.dart`
- `lib/ui/views/document_upload/document_upload_viewmodel.dart`

### Purpose:
Upload a document for a pet/medical record. Used by staff, vet, admin.

### ViewModel:
- Accept optional: `String? petId`, `String? medicalRecordId`
- Inject `DocumentService`, `PetService`
- Properties:
  - `File? selectedFile`
  - `String? fileName`
  - `int? fileSize`
  - Form controllers: title, description, documentType, tags
  - `Pet? selectedPet`
  - `List<Pet> pets = []` (for pet picker if petId not pre-set)
  - `bool isUploading = false`
  - `double uploadProgress = 0.0`
  - `String? errorMessage`
- Methods:
  - `initialise()` → If petId provided, fetch pet. Otherwise, load pet list for picker.
  - `pickFile()` → Open file picker (images, PDFs)
  - `uploadDocument()`:
    1. Validate: file selected, title, documentType, petId
    2. Call DocumentService.uploadDocument() with multipart data
    3. Show upload progress
    4. On success: navigate back
    5. On error: show error message
  - `removeFile()` → Clear selected file

### View Layout:
- **Pet Selection** (if petId not pre-set):
  - Dropdown or searchable picker
- **File Selection:**
  - Tap-to-select area with file icon
  - Shows selected file name and size
  - "Remove" button to clear
- **Form Fields:**
  - Title (text, required)
  - Document Type (dropdown: Lab Result, X-Ray, Intake Form, Referral Letter, Other)
  - Description (multiline text, optional)
  - Tags (chip input, optional)
- **Upload Button:**
  - Shows progress indicator during upload
  - Disabled until all required fields filled

### Route Registration:
```dart
MaterialRoute(page: DocumentUploadView, path: '/document-upload-view')
```

---

## Task 4.7: Connect Patient Profile Documents Tab

**Modify:** `lib/ui/views/patient_profile/patient_profile_viewmodel.dart`

Add to the existing patient profile:

### New Tab: Documents
- Position: After existing tabs (Tab 5 or merge with an existing one)
- Fetch via `DocumentService.getDocuments(petId: petId)`
- Properties:
  - `List<Document> documents = []`
  - `bool isLoadingDocuments = false`
- Methods:
  - `loadDocuments()` → Called when documents tab selected (lazy load)
  - `openDocument(Document doc)` → Download/open
  - `uploadDocument()` → Navigate to upload view with petId

### View:
- List of document cards (same as DocumentListView layout)
- "Upload" button for staff/vet/admin
- Empty state: "No documents yet"

---

## Task 4.8: Staff Dashboard Enhancements

**Modify:** `lib/ui/views/home/home_view.dart` and `home_viewmodel.dart`

### Staff-specific dashboard content:

**Top Section:**
- Greeting: "Good morning, {firstName}"
- Today's date
- Stats cards:
  - "Today's Appointments" (total count)
  - "Pending Approval" (pending count) - tappable → pending appointments
  - "Checked In" (checked_in count)
  - "Completed" (completed count)

**Main Content:**
- "Pending Approvals" section (if any):
  - Top 3 pending appointments with "Approve" quick action
  - "View All" link → Pending Appointments View
- "Today's Schedule" list:
  - All clinic appointments for today (not just one vet)
  - Each card shows: time, pet name, owner, assigned vet, status
  - Tap → appointment detail
- Quick actions row:
  - "New Appointment" → Appointment form
  - "Register Pet Owner" → Pet owner form
  - "Check In" → Opens today's appointments with check-in flow

**Data Fetching:**
- `AppointmentService.getAppointments(date: today)` → all clinic appointments
- `AppointmentService.getPendingAppointments()` → pending count + list

---

## Task 4.9: Enhance Appointment Form with Pet Owner Workflow

**Modify:** `lib/ui/views/appointment_form/appointment_form_viewmodel.dart`

Enhance the appointment form (created in Phase 2) with a better pet owner workflow for staff:

### Quick Create Pet Owner Flow:
When searching for a pet owner by phone and not found:
1. Show "Not found" message
2. "Quick Create" button that shows inline form:
   - First Name, Last Name, Phone (pre-filled), Email
   - Call `PetOwnerService.quickCreate()`
   - On success: auto-select the new owner, continue booking
3. After owner created, allow adding a pet immediately:
   - "This owner has no pets. Add a pet?" prompt
   - Inline pet creation form or navigate to pet form

### Availability Check:
After selecting vet and date:
1. Call `AppointmentService.getAvailability(clinicId, vetId, date)`
2. Show available time slots as a grid of tappable buttons
3. User selects a slot → auto-fills scheduledStart and scheduledEnd

---

## Task 4.10: Bottom Navigation for Staff

**Modify:** Home view bottom navigation for staff role

### Staff Bottom Navigation Items:
1. **Home** (dashboard) - Home icon
2. **Patients** (pet registry) - Pets icon
3. **+** (FAB - new appointment) - Add icon
4. **Owners** (pet owner list) - People icon
5. **Profile** (settings) - Person icon

### Navigation Updates:
- Add PetOwnerListView route to bottom nav
- FAB in center creates new appointment (navigate to AppointmentFormView)
- Badge on Home icon showing pending appointment count

---

## Task 4.11: Update Stacked Configuration

**Modify:** `lib/app/app.dart`

Add new routes and services:
```dart
// New routes
MaterialRoute(page: PetOwnerListView),
MaterialRoute(page: PetOwnerDetailView),
MaterialRoute(page: PetOwnerFormView),
MaterialRoute(page: DocumentListView),
MaterialRoute(page: DocumentUploadView),

// New services
LazySingleton(classType: DocumentService),
```

Note: `PetOwnerService` was already registered in Phase 2.

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Task 4.12: Add File Picker Dependency

**File:** `pubspec.yaml`

Add:
```yaml
dependencies:
  file_picker: ^6.1.1          # File selection for document upload
  url_launcher: ^6.2.2         # Open URLs, phone, email
  path_provider: ^2.1.2        # Get temp/download directories
```

Run: `flutter pub get`

---

## Verification Checklist

After completing Phase 4:

- [ ] DocumentService upload works with multipart/form-data
- [ ] DocumentService download returns accessible URL
- [ ] Pet Owner List shows paginated owners with search
- [ ] Pet Owner Detail shows owner info + their pets
- [ ] Pet Owner Form creates and edits pet owners
- [ ] Phone lookup works and shows existing owner if found
- [ ] Quick create flow works when owner not found during appointment booking
- [ ] Document List shows documents with type filtering
- [ ] Document Upload picks file, shows progress, uploads successfully
- [ ] Patient Profile documents tab loads and shows documents
- [ ] Staff dashboard shows today's appointments and pending count
- [ ] Pending approvals section shows on staff dashboard
- [ ] Staff bottom navigation has correct items (Home, Patients, +, Owners, Profile)
- [ ] Appointment form availability check shows time slots
- [ ] URL launcher opens phone dialer and email client
- [ ] File picker opens and returns selected file
- [ ] Role guards prevent staff from accessing medical record creation
- [ ] App compiles and runs without errors
