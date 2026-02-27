# Backend API Requirements for Pet Partner (Flutter Clinic App)

## Context

The Flutter app (pet-partner) serves **clinic_admin**, **veterinarian**, and **staff** roles.
The backend is a Next.js app at:
```
/Users/lokeshkumar/Documents/project/vet-clinic/next-js-boilerplate/
```

Most APIs already exist. This document specifies the **missing endpoints** that must be created for the Flutter app to function.

---

## What Already Exists (DO NOT recreate)

These are fully functional and the Flutter app will use them as-is:

| Module | Endpoints | Status |
|--------|-----------|--------|
| Token Refresh | `POST /api/mobile/auth/refresh` | Working |
| Mobile Logout | `POST /api/mobile/auth/logout` | Working |
| Appointments CRUD | `/api/appointments/*` (7 endpoints) | Working |
| Pets CRUD | `/api/pets/*` (6 endpoints) | Working |
| Pet Owners | `/api/pet-owners/*` (5 endpoints) | Working |
| Medical Records | `/api/medical-records/*` (3 endpoints) | Working |
| Prescriptions | `/api/prescriptions/*` (4 endpoints) | Working |
| Vaccinations | `/api/vaccinations/*` (3 endpoints) | Working |
| Documents | `/api/documents/*` (5 endpoints) | Working |
| Reminders | `/api/reminders/*` (4 endpoints) | Working |
| Users/Staff | `/api/users/*` (4 endpoints) | Working |
| Clinic | `/api/clinic`, `/api/settings`, `/api/branding` | Working |
| Profile | `/api/profile` (GET/PUT) | Working |
| Dual Auth | `dual-auth.ts` supports both JWT Bearer and NextAuth sessions | Working |

---

## API 1: Mobile Email+Password Login (CRITICAL — Blocker)

### Why it's needed

The Flutter app cannot use NextAuth's `POST /api/auth/signin` because it returns **session cookies** (httpOnly, browser-only). Flutter needs a REST endpoint that returns **JWT Bearer tokens** (like the existing OTP verify endpoint does).

### All building blocks already exist

- `AuthServicePrisma.validateCredentials(email, password)` — validates email + bcrypt password
- `generateAccessToken(user)` — creates JWT access token (15 min expiry)
- `generateRefreshToken(userId)` — creates JWT refresh token (30 day expiry)
- `RefreshTokenService.storeRefreshToken()` — stores hashed refresh token in DB
- Response format — identical to `POST /api/auth/otp/verify`

### Endpoint Spec

```
POST /api/mobile/auth/login
```

**Authentication:** None (public endpoint)

**Request Body:**
```json
{
  "email": "admin@clinic.com",
  "password": "securepassword123",
  "deviceInfo": {
    "deviceId": "optional-device-uuid",
    "platform": "ios|android",
    "appVersion": "1.0.0"
  }
}
```

**Validation Schema (Zod):**
```typescript
const mobileLoginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
  deviceInfo: z.object({
    deviceId: z.string().optional(),
    platform: z.string().optional(),
    appVersion: z.string().optional(),
  }).optional(),
});
```

**Allowed Roles:** `clinic_admin`, `veterinarian`, `staff` (reject `pet_owner` — they use OTP login; reject `super_admin` — web only)

**Implementation Logic:**
```
1. Parse and validate request body with mobileLoginSchema
2. Call AuthServicePrisma.validateCredentials(email, password)
3. If null → return 401 { success: false, error: { code: "INVALID_CREDENTIALS", message: "Invalid email or password" } }
4. If user.isActive === false → return 401 { message: "Account is deactivated" }
5. If user.role === "pet_owner" → return 403 { message: "Pet owners must use OTP login" }
6. If user.role === "super_admin" → return 403 { message: "Super admin login not supported on mobile" }
7. Generate access token: generateAccessToken({ id, role, clinicId, email, phone, firstName, lastName })
8. Generate refresh token: generateRefreshToken(user.id)
9. Store refresh token: RefreshTokenService.storeRefreshToken({ userId, jti, hashedToken, expiresAt, deviceInfo })
10. Return 200 response
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
    "expiresIn": 900,
    "tokenType": "Bearer",
    "user": {
      "id": "uuid",
      "role": "clinic_admin|veterinarian|staff",
      "clinicId": "uuid",
      "firstName": "John",
      "lastName": "Doe",
      "email": "admin@clinic.com",
      "phone": "+1234567890",
      "avatarUrl": "https://..."
    }
  }
}
```

**Error Responses:**

| Status | Code | When |
|--------|------|------|
| 400 | `VALIDATION_ERROR` | Missing/invalid email or password |
| 401 | `INVALID_CREDENTIALS` | Wrong email or wrong password |
| 401 | `ACCOUNT_DEACTIVATED` | User `isActive = false` |
| 403 | `ROLE_NOT_ALLOWED` | pet_owner or super_admin trying to use this endpoint |
| 429 | `TOO_MANY_ATTEMPTS` | Rate limiting (optional, recommended) |
| 500 | `INTERNAL_ERROR` | Server error |

**File location:**
```
src/app/api/mobile/auth/login/route.ts
```

**Reference implementation:** Copy the pattern from `src/app/api/auth/otp/verify/route.ts` — replace OTP verification with `validateCredentials()`.

---

## API 2: Clinic Dashboard for Admin/Staff/Vet (Medium Priority)

### Why it's needed

The existing `GET /api/mobile/dashboard` only returns pet owner data (their pets + their appointments). Clinic-side roles need aggregated dashboard data for their clinic.

### Endpoint Spec

```
GET /api/dashboard
```

**Authentication:** Bearer token (clinic_admin, veterinarian, staff)

**Authorization:** Requires valid JWT. Data auto-scoped by clinicId from token.

**Query Parameters:** None

**Implementation Logic:**
```
1. Extract user from dual-auth (JWT Bearer or NextAuth session)
2. Get clinicId and role from user
3. Based on role, fetch:

   For ALL roles:
   - Today's appointment count (clinic-scoped)
   - Pending appointment count (clinic-scoped)

   For clinic_admin:
   - Active pet count (clinic-scoped)
   - Active staff count (clinic-scoped)
   - Today's appointments list (all, limit 10)
   - Pending appointments list (limit 5)

   For staff:
   - Today's appointments list (all, limit 10)
   - Pending appointments list (limit 5)
   - Checked-in count

   For veterinarian:
   - Today's appointments list (filtered by veterinarianId = user.id, limit 10)
   - Current/next appointment (first checked_in or in_progress)
   - Completed today count
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "stats": {
      "todayAppointments": 12,
      "pendingApproval": 3,
      "checkedIn": 2,
      "completed": 5,
      "activePets": 150,
      "activeStaff": 8
    },
    "todayAppointments": [
      {
        "id": "uuid",
        "title": "Annual checkup",
        "appointmentType": "checkup",
        "status": "scheduled",
        "scheduledStart": "2026-02-27T10:00:00Z",
        "scheduledEnd": "2026-02-27T10:30:00Z",
        "pet": {
          "id": "uuid",
          "name": "Max",
          "species": "Dog",
          "photoUrl": "https://..."
        },
        "owner": {
          "id": "uuid",
          "firstName": "Sarah",
          "lastName": "Jenkins",
          "phone": "555-0001"
        },
        "veterinarian": {
          "id": "uuid",
          "firstName": "Emily",
          "lastName": "Johnson"
        }
      }
    ],
    "pendingAppointments": [
      { /* same structure, only pending status */ }
    ],
    "currentAppointment": null
  }
}
```

**Error Responses:**

| Status | Code | When |
|--------|------|------|
| 401 | `UNAUTHORIZED` | Missing or invalid token |
| 403 | `FORBIDDEN` | pet_owner role (they use `/api/mobile/dashboard`) |

**File location:**
```
src/app/api/dashboard/route.ts
```

**Note:** This endpoint already partially exists as `GET /api/pet-owner/dashboard/route.ts` for pet owners. Create a new one at `/api/dashboard/` for clinic roles.

---

## API 3: Role Switching (New Feature)

### Why it's needed

A single person at a clinic may hold multiple roles (e.g., a vet who is also the clinic admin, or a staff member temporarily given admin access). Currently the backend supports only a single role per user. The Flutter app needs a way for users to switch between assigned roles.

### Database Schema Changes

**Option A: Multi-role field on User (Recommended)**

Add a `roles` JSON array field alongside the existing `role` field:

```prisma
model User {
  // Existing
  role           UserRole   // Active/current role (used in JWT)

  // NEW
  roles          UserRole[] // All assigned roles for this user
}
```

**Migration:**
```sql
ALTER TABLE users ADD COLUMN roles text[] DEFAULT ARRAY[]::text[];
-- Backfill: set roles = ARRAY[role] for all existing users
UPDATE users SET roles = ARRAY[role::text];
```

**Rules:**
- `roles` contains ALL roles a user can switch to
- `role` is the CURRENTLY ACTIVE role (used in JWT claims)
- A user can only switch to a role that exists in their `roles` array
- When creating a user, `roles` defaults to `[role]` (single role)
- Admin can assign additional roles via `PATCH /api/users/{id}` by updating `roles`

### Endpoint 3a: Switch Active Role

```
POST /api/mobile/auth/switch-role
```

**Authentication:** Bearer token (any clinic role)

**Request Body:**
```json
{
  "role": "clinic_admin",
  "deviceInfo": {
    "deviceId": "optional",
    "platform": "ios",
    "appVersion": "1.0.0"
  }
}
```

**Validation Schema:**
```typescript
const switchRoleSchema = z.object({
  role: z.enum(['clinic_admin', 'veterinarian', 'staff']),
  deviceInfo: z.object({
    deviceId: z.string().optional(),
    platform: z.string().optional(),
    appVersion: z.string().optional(),
  }).optional(),
});
```

**Implementation Logic:**
```
1. Extract user from JWT Bearer token
2. Fetch user from DB (get full user record with roles array)
3. Validate requested role is in user.roles array
   - If not → 403 { message: "You do not have the {role} role assigned" }
4. Update user.role = requested role in DB
5. Revoke current refresh token (the one used to get current access token)
6. Generate new access token with updated role claim
7. Generate new refresh token
8. Store new refresh token
9. Return new tokens + updated user
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "accessToken": "new_jwt_with_updated_role...",
    "refreshToken": "new_refresh_token...",
    "expiresIn": 900,
    "tokenType": "Bearer",
    "user": {
      "id": "uuid",
      "role": "clinic_admin",
      "roles": ["clinic_admin", "veterinarian"],
      "clinicId": "uuid",
      "firstName": "John",
      "lastName": "Doe",
      "email": "john@clinic.com",
      "phone": "+1234567890",
      "avatarUrl": null
    }
  }
}
```

**Error Responses:**

| Status | Code | When |
|--------|------|------|
| 400 | `VALIDATION_ERROR` | Invalid or missing role |
| 401 | `UNAUTHORIZED` | Missing/invalid token |
| 403 | `ROLE_NOT_ASSIGNED` | User does not have the requested role in their `roles` array |
| 403 | `SAME_ROLE` | Already on the requested role (optional — could succeed silently) |

**File location:**
```
src/app/api/mobile/auth/switch-role/route.ts
```

### Endpoint 3b: Update User Roles (Admin only)

**Modify existing:** `PATCH /api/users/{id}`

Add `roles` to the update schema:

```typescript
// Add to existing updateUserSchema
roles: z.array(z.enum([
  'clinic_admin', 'veterinarian', 'staff'
])).min(1).optional(),
```

**Logic changes:**
- When `roles` is provided, validate all roles are clinic-side roles (not pet_owner, not super_admin)
- Update `user.roles = newRoles`
- If user's current `role` is not in the new `roles` array, update `role` to `roles[0]`
- Only users with `users:manage` permission can update roles

### Endpoint 3c: Include roles in all auth responses

**Modify existing responses** for these endpoints to include the `roles` array in the user object:
- `POST /api/mobile/auth/login` (new endpoint from API 1)
- `POST /api/auth/otp/verify`
- `POST /api/mobile/auth/refresh` (add user object to refresh response)
- `GET /api/profile`

Add `roles` field to the user object in all responses:
```json
{
  "user": {
    "id": "...",
    "role": "veterinarian",
    "roles": ["veterinarian", "clinic_admin"],
    ...
  }
}
```

### Endpoint 3d: Include roles in JWT access token

**Modify:** `generateAccessToken()` in `jwt-utils.ts`

Add `roles` array to the JWT payload:
```typescript
export interface JwtAccessPayload {
  sub: string;
  role: UserRole;       // Current active role
  roles: UserRole[];    // All assigned roles
  clinicId: string | null;
  // ... existing fields
}
```

This allows the Flutter app to read available roles from the token without an extra API call.

---

## API 4: Clinic Reports/Analytics (Low Priority)

### Why it's needed

The Flutter admin dashboard has a Reports view. Currently no analytics endpoint exists. Stats are computed client-side from list endpoints, but that's inefficient (multiple API calls + client-side aggregation).

### Endpoint Spec

```
GET /api/reports
```

**Authentication:** Bearer token (clinic_admin only)

**Query Parameters:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| period | string | `week` | `week`, `month`, `year` |

**Implementation Logic:**
```
1. Extract user from dual-auth
2. Verify role is clinic_admin (permission: reports:view)
3. Calculate date range from period param
4. Query DB aggregations:
   - Appointment counts by status (completed, cancelled, no_show)
   - Appointment counts by type (checkup, vaccination, surgery, etc.)
   - Appointments per veterinarian
   - New pets registered in period
   - New pet owners registered in period
   - Total active pets
   - Total active pet owners
   - Total active staff
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "period": "week",
    "dateRange": {
      "start": "2026-02-21T00:00:00Z",
      "end": "2026-02-27T23:59:59Z"
    },
    "appointments": {
      "total": 45,
      "byStatus": {
        "completed": 30,
        "cancelled": 5,
        "noShow": 2,
        "scheduled": 8
      },
      "byType": {
        "checkup": 15,
        "vaccination": 10,
        "dental": 5,
        "surgery": 3,
        "grooming": 7,
        "emergency": 2,
        "other": 3
      }
    },
    "vetPerformance": [
      {
        "veterinarianId": "uuid",
        "name": "Dr. Emily Johnson",
        "totalAppointments": 20,
        "completed": 15,
        "cancelled": 2
      }
    ],
    "counts": {
      "activePets": 150,
      "activePetOwners": 95,
      "activeStaff": 8,
      "newPets": 5,
      "newPetOwners": 3
    }
  }
}
```

**Error Responses:**

| Status | Code | When |
|--------|------|------|
| 401 | `UNAUTHORIZED` | Missing/invalid token |
| 403 | `FORBIDDEN` | Non-admin role |
| 422 | `VALIDATION_ERROR` | Invalid period value |

**File location:**
```
src/app/api/reports/route.ts
```

---

## Summary: Priority and Effort

| # | API | Priority | Effort | Blocking Flutter? |
|---|-----|----------|--------|-------------------|
| 1 | Mobile Email+Password Login | **CRITICAL** | Small (100-150 lines, reuses existing infra) | **YES — Phase 1 blocker** |
| 2 | Clinic Dashboard | Medium | Medium (200-300 lines) | No (can build client-side) |
| 3 | Role Switching | Medium | Medium-Large (DB migration + 3 endpoint changes + 1 new endpoint) | No (can launch single-role first) |
| 4 | Reports/Analytics | Low | Medium (200-300 lines, mostly DB queries) | No (Phase 5, can defer) |

### Recommended Implementation Order:
1. **API 1 first** — unblocks all Flutter development
2. **API 3 (schema + switch-role)** — nice to have for multi-role users
3. **API 2** — improves dashboard performance
4. **API 4** — when admin reports are being built

---

## Existing Infrastructure to Reuse

| Utility | Location | Purpose |
|---------|----------|---------|
| `AuthServicePrisma.validateCredentials()` | `src/services/auth.service.prisma.ts` | Email+password verification |
| `generateAccessToken()` | `src/lib/jwt/jwt-utils.ts` | JWT access token creation |
| `generateRefreshToken()` | `src/lib/jwt/jwt-utils.ts` | JWT refresh token creation |
| `RefreshTokenService` | `src/services/refresh-token.service.ts` | Store/validate/revoke refresh tokens |
| `getDualAuthUser()` | `src/lib/auth/dual-auth.ts` | Extract user from JWT or session |
| `checkPermission()` | `src/lib/auth-utils.ts` | Role-based permission check |
| `ROLE_PERMISSIONS` | `src/lib/auth-utils.ts` | Permission map per role |
| `AuthController` | `src/controllers/auth.controller.ts` | Auth controller with OTP patterns |

---

## File Structure for New Endpoints

```
src/app/api/
├── mobile/auth/
│   ├── login/route.ts           # NEW — API 1
│   ├── switch-role/route.ts     # NEW — API 3a
│   ├── refresh/route.ts         # EXISTING (modify to include user.roles)
│   ├── logout/route.ts          # EXISTING
│   └── login-otp/route.ts       # EXISTING
├── dashboard/route.ts           # NEW — API 2
├── reports/route.ts             # NEW — API 4
└── users/[id]/route.ts          # EXISTING (modify to support roles array)
```
