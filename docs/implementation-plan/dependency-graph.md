# Phase Dependency Graph

## Visual Dependency Map

```
Phase 0 ──► Phase 1 ──► Phase 2 ──┬──► Phase 3 (Vet) ────┐
 (Restructure) (Foundation) (Shared)  ├──► Phase 4 (Staff) ───┼──► Phase 6 (Polish)
                                      └──► Phase 5 (Admin) ───┘
                                       ▲
                                       │
                                   PARALLEL OK
```

## Dependency Rules

### Strictly Sequential (MUST be in order)

```
Phase 0 → Phase 1 → Phase 2
```

**Why:**
- **Phase 0** creates the folder structure, linting, CLAUDE.md, env config — everything else builds on this
- **Phase 1** creates models, enums, API client, auth service, storage, MainView — Phase 2 imports all of these
- **Phase 2** creates PetService, AppointmentService, PetOwnerService, connects existing views to API — Phases 3/4/5 all use these services

### Parallel After Phase 2 (CAN run simultaneously)

```
Phase 3 (Veterinarian)  ─┐
Phase 4 (Staff)          ├── ALL THREE IN PARALLEL
Phase 5 (Clinic Admin)   ┘
```

**Why they're independent:**

| Phase | Creates | Uses from Phase 2 | Touches |
|-------|---------|-------------------|---------|
| 3 | MedicalRecordService, PrescriptionService, VaccinationService, 5 new views | PetService, AppointmentService | Patient Profile tabs (medical, Rx, vaccines) |
| 4 | DocumentService, 5 new views | PetOwnerService, PetService, AppointmentService | Patient Profile tabs (documents), Appointment Form |
| 5 | UserService, ClinicService, ReminderService, 7 new views | AppointmentService, PetService | Home dashboard (admin), bottom nav |

### Phase 6 — After ALL of 3, 4, 5

```
Phase 6 depends on: Phase 3 + Phase 4 + Phase 5
```

**Why:** Phase 6 applies polish (error handling, image upload, search, snackbars) across ALL views from all phases.

---

## Conflict Points When Running 3/4/5 in Parallel

These files are modified by multiple phases. Coordinate to avoid merge conflicts:

### 1. `lib/app/app.dart` (Route & Service Registration)

| Phase | Adds Routes | Adds Services |
|-------|-------------|---------------|
| 3 | MedicalRecordFormView, PrescriptionListView, PrescriptionFormView, VaccinationListView, VaccinationFormView | MedicalRecordService, PrescriptionService, VaccinationService |
| 4 | PetOwnerListView, PetOwnerDetailView, PetOwnerFormView, DocumentListView, DocumentUploadView | DocumentService |
| 5 | StaffListView, StaffFormView, ClinicSettingsView, ClinicBrandingView, ReminderListView, ReminderFormView, ReportsView | UserService, ClinicService, ReminderService |

**Resolution:** Each phase appends to the routes and dependencies lists. Merge by combining all additions. No ordering conflict — just additive.

### 2. `lib/ui/views/patient_profile/` (Patient Profile Tabs)

| Phase | Modifies |
|-------|----------|
| 3 | Adds Medical Records tab, Vaccinations tab, Prescriptions tab + lazy loading |
| 4 | Adds Documents tab + lazy loading |

**Resolution:** Phase 3 creates the tab infrastructure (lazy loading pattern, tab data properties in ViewModel). Phase 4 adds one more tab using the same pattern. If running in parallel, one agent creates the pattern and the other follows it.

**Recommendation:** Have Phase 3 handle the tab infrastructure first, then Phase 4 adds the documents tab. OR define the tab skeleton in Phase 2 (empty tabs with "Coming Soon") and let each phase fill its tabs.

### 3. `lib/ui/views/home/` (Dashboard Content)

| Phase | Modifies |
|-------|----------|
| 3 | Adds vet-specific dashboard content (Task 3.11) |
| 4 | Adds staff-specific dashboard content (Task 4.8) |
| 5 | Adds admin-specific dashboard content (Task 5.11) |

**Resolution:** The HomeViewModel already switches content by role (Phase 1, Task 1.13). Each phase fills in the content for its role. These are separate code paths (`if role == vet`, `if role == staff`, `if role == admin`) so they don't conflict.

**Recommendation:** Phase 1 should create empty placeholder methods:
```dart
Widget _buildVetDashboard()  → "Coming Soon" // Filled by Phase 3
Widget _buildStaffDashboard() → "Coming Soon" // Filled by Phase 4
Widget _buildAdminDashboard() → "Coming Soon" // Filled by Phase 5
```

### 4. `pubspec.yaml` (Dependencies)

| Phase | Adds |
|-------|------|
| 4 | file_picker, url_launcher, path_provider |
| 5 | flutter_colorpicker |

**Resolution:** Simple additive merge. No conflicts.

### 5. `lib/ui/views/appointment_detail/` (Appointment Detail Actions)

| Phase | Modifies |
|-------|----------|
| 2 | Creates view with status buttons |
| 3 | Adds "Create Medical Record" button (vet/admin) |

**Resolution:** Phase 2 creates the view with role-based action buttons. Phase 3 adds one more action. No conflict if Phase 3 appends to the existing actions list.

---

## Recommended Execution Strategy

### Option A: Maximum Parallelism (3 agents)

```
Timeline:
─────────────────────────────────────────────────────►

Agent 1:  [Phase 0] → [Phase 1] → [Phase 2] → [Phase 3 Vet]     → [Phase 6]
Agent 2:                                        [Phase 4 Staff]   →
Agent 3:                                        [Phase 5 Admin]   →
                                                ▲
                                                │
                                      Phase 2 must complete first
```

**Coordination needed:**
- Agent 1 completes Phase 0→1→2 first (sequential, single agent)
- At Phase 2 completion, Agents 2 and 3 start
- All three agents merge into `app.dart` (routes + services)
- Phase 3 owns patient_profile tab infrastructure
- Phase 6 starts after all three complete

### Option B: Two Agents (Recommended)

```
Timeline:
─────────────────────────────────────────────────────►

Agent 1:  [Phase 0] → [Phase 1] → [Phase 2] → [Phase 3] → [Phase 6]
Agent 2:                                        [Phase 4] → [Phase 5]
```

**Why this is better:**
- Phase 0→1→2 is sequential anyway (one agent)
- Phase 3 (vet) and Phase 4 (staff) have the least overlap
- Phase 5 (admin) depends on some Phase 4 patterns (pet owner list used in admin dashboard)
- Phase 6 only needs one agent since it touches everything
- Fewer merge conflicts

### Option C: Single Agent, Fastest Sequential Path

```
Phase 0 → Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6
```

**When to use:** If only one coding agent is available. This is the safest path with zero merge conflicts.

---

## Backend API Parallelism

The backend APIs from `backend-api-requirements.md` can be developed **in parallel** with Flutter Phases 0-1:

```
Backend Agent:  [API 1: Login] → [API 3: Switch Role] → [API 2: Dashboard] → [API 4: Reports]
Flutter Agent:  [Phase 0]      → [Phase 1]             → [Phase 2]          → [Phase 3/4/5]
                                  ▲                        ▲
                                  │                        │
                         API 1 needed here        API 2 nice-to-have here
```

**Critical path:** API 1 (mobile login) must be ready before Flutter Phase 1 testing. Start backend work immediately.

---

## Summary Table

| Phase | Depends On | Can Parallel With | Duration Estimate |
|-------|-----------|-------------------|-------------------|
| 0 | Nothing | Nothing (must be first) | Small |
| 1 | Phase 0 | Backend API 1 | Medium |
| 2 | Phase 1 | Backend API 2, 3 | Medium-Large |
| 3 | Phase 2 | Phase 4, Phase 5 | Medium |
| 4 | Phase 2 | Phase 3, Phase 5 | Medium |
| 5 | Phase 2 | Phase 3, Phase 4 | Medium |
| 6 | Phase 3 + 4 + 5 | Nothing (last) | Medium |
