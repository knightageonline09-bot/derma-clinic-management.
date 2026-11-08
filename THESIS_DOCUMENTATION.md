# Derma Clinic Management System — Complete Documentation

**Derma Clinic Philippines.** A clinic operations system covering patient records, appointments,
consultations, treatment dockets, inventory and reporting, with five staff roles and role-based
access control. Billing is explicitly outside the system: payment is processed by the clinic's
external POS, and a treatment docket's QR carries that docket's treatment details to the POS.

This is the single review document for the defensive presentation. Sections 1–8 describe what the
system does and how it is built. **Section 9 lists what is not finished, and Section 10 is prepared
answers to the questions those limitations will provoke.** Read Section 9 before the defense — a
panel that finds an undocumented gap is far more damaging than one that hears the gap disclosed first.

Verified state at the time of writing: **85 of 85 backend tests pass, zero failures, zero errors**,
confirmed by a fresh run. The frontend loads with no runtime errors. Chapter 3 has had its six
narrative corrections applied and its database table replaced with one that matches the real schema
(`database/Chapter3_Table_3.4_corrected.md`).

---

## 1. System Overview

The system replaces a paper-and-spreadsheet clinic workflow with a single application that enforces
clinic rules at the database rather than relying on staff to remember them.

The problem it addresses is that a clinic's failures are usually not dramatic — they are a treatment
performed without checking stock, a docket handed to the POS without the right treatment details, or
a patient record edited by someone who should only have been able to read it. Each of those is a rule
that has to hold every time, by every staff member, including on the day someone is rushing. The
system's design principle is therefore that rules belong in the layer that cannot forget them.

Three consequences follow, and they explain most of the design decisions in this document:

- **Stock is deducted inside the same database transaction that creates the treatment.** If the
  required product is short, the docket is never created and no partial deduction survives.
- **Billing is out of scope by design.** The clinic's POS owns payment, invoices and receipts. This
  system stores no second copy, so there is no billing arithmetic to drift from the money that was
  actually taken. The docket QR is the handoff: it carries the treatment details the POS needs.
- **Authorization is enforced on the server, not in the navigation.** Hiding a menu item is a
  courtesy to the user; the endpoint behind it is what actually refuses.

Four system roles are defined: Administrator, Receptionist, Dermatologist and Inventory Staff.
Therapists are clinic personnel, not system users: they are stored in their own table and can be
assigned to appointments and treatment dockets without ever signing in. Each role sees a different
subset of the application, and each is separately refused by the server if it reaches for something
outside that subset.

---

## 2. Architecture and Stack

### 2.1 Shape

Two tiers, deliberately.

```
Browser  ──  index.html + app.js + styles.css  (vanilla JS, no build step)
   │
   │  HTTPS, JSON, Authorization: Bearer <JWT>
   ▼
Spring Boot 3.4.4 backend  ──  controller → policy → JdbcTemplate/JPA
   │
   ▼
MySQL 8.4  ──  16 tables, 14 Flyway migrations
```

### 2.2 Backend

| Component | Version / choice | Why |
| --- | --- | --- |
| Spring Boot | 3.4.4 | Current stable line; matches Java 21. |
| Java | 21 | LTS. |
| Spring Security | starter | Method-level authorization via `@PreAuthorize`. |
| Flyway | `flyway-core` + `flyway-mysql` | Schema changes are versioned, ordered and replayable. |
| MySQL | 8.4 connector | InnoDB for real transactions and row locks. |
| jjwt | 0.12.6 | JWT issue and verification. |
| Data access | `JdbcTemplate` **and** JPA | See 2.4. |

### 2.3 Frontend

Vanilla JavaScript — `index.html`, `app.js`, `styles.css`. **There is no build step, no
npm, no bundler, and no framework.** The only third-party script is a vendored `qrcode.min.js`.

This is a deliberate and defensible choice, and it is the first thing to be ready to explain because
Chapter 3 previously described a React stack. The application is a single-page admin console with
roughly a dozen views. A framework would add a toolchain — Node, a package manifest, a build
artifact that must be kept in sync with the source — in exchange for component reuse this screen
count does not need. The cost is that view state is managed by hand; Section 9 is honest about where
that cost shows.

### 2.4 Two data-access mechanisms, on purpose

`Patient` and `User` are JPA entities with repositories. Everything clinical — appointments,
consultations, dockets, inventory — goes through `JdbcTemplate`.

The reason is that the clinical queries are reporting joins, not object graphs. The inventory read
joins products to suppliers, batches and balances to produce one row per product; expressing that as
an entity mapping would mean fetching four objects to display one line. The rigid, single-table
entities keep their ORM; the analytical reads keep their SQL. `ddl-auto` is set to `validate`, so
Hibernate will refuse to start if the entity mapping and the real schema disagree — the ORM cannot
silently drift from the migrations.

---

## 3. Modules and Features

Ten workspaces. Ten forms. Every form's save path is listed here with whether it persists.

### 3.1 Workspaces

| Workspace | Shows | Who |
| --- | --- | --- |
| Overview | Dashboard metrics, today's schedule, recent activity, inventory watch | all five |
| Patients | Searchable, paginated patient list; register, edit, view, archive/restore | four (actions vary) |
| Appointments | Schedule list; create, edit, complete, view detail; assign a dermatologist and/or therapist | Administrator, Receptionist, Dermatologist |
| Consultations | Clinical entries with diagnosis, recommendation, notes, follow-up date | Administrator, Dermatologist |
| Treatment dockets | Docket list; create, preview, print, POS QR | Administrator, Receptionist, Dermatologist |
| Inventory | Product stock, batches, expiry, low-stock filter, per-product movement history | Administrator, Inventory Staff |
| Sales | Service-sales report read from treatment dockets; Date From / Date To filters; Service and Quantity only | Administrator |
| Services | Service catalogue with linked required product | Administrator |
| Reports | Inventory, movement, low-stock and expiry summaries; CSV and PDF export | Administrator, Inventory Staff |
| Team & access | User list, role assignment, activation, therapist personnel records, role permission matrix | Administrator |
| Audit trail | Recorded user actions with module and action filters | Administrator |

### 3.2 Forms and whether they persist

| Form | Endpoint | Persists? |
| --- | --- | --- |
| `patientForm` | `POST /api/patients`, `PATCH /api/patients/{id}` | **Yes** |
| `appointmentForm` | `POST` / `PUT /api/clinic/appointments/{id}` | **Yes** |
| `consultationForm` | `POST /api/clinic/consultations` | **Yes** |
| `docketForm` | `POST /api/clinic/dockets` | **Yes** |
| `movementForm` | `POST /api/clinic/movements` | **Yes** |
| `productForm` | `POST /api/clinic/products` | **Yes** |
| `userForm` | `POST /api/users`, `PUT /api/users/{id}` | **Yes** |
| `serviceForm` | `POST /api/clinic/services`, `PUT /api/clinic/services/{id}`, `PUT /api/clinic/services/{id}/product` | **Yes** |
| `supplierForm` | `POST /api/clinic/suppliers` | **Yes** |
| `loginForm` | `POST /api/auth/login` | **Yes** |

### 3.3 The treatment docket, end to end

This is the workflow to demonstrate, because it is where the system does something a spreadsheet
cannot.

1. The Receptionist opens **Treatment dockets → New docket**, picks a patient, a dermatologist, a
   therapist and a service. The form immediately shows a live inventory check — the stock on hand for
   the product that service consumes, and whether it is sufficient.
2. On save, the backend resolves the service's required products, locks the inventory rows with
   `SELECT ... FOR UPDATE`, validates every required quantity, deducts each product, writes an
   inventory movement against the docket, and creates the docket — **all inside one transaction**
   (`@Transactional`, in the docket-creation endpoint of `ClinicCommandController`).
3. If any product is short, the entire operation rolls back. There is no docket and no movement, and
   stock is unchanged.
4. The docket then appears in **Treatment dockets**, and the create call returns its reference so the
   new docket's **POS QR** opens immediately. The product deduction is visible in
   **Inventory → History** on that product.

The `FOR UPDATE` lock is what makes this safe when two receptionists create dockets for the same
product at the same moment. Without it, both could read the same stock figure, both could pass the
check, and the second deduction could drive stock negative. The row lock serialises them.

### 3.4 The external POS handoff

Payment is not recorded here. Every new docket opens a QR whose version 4 JSON payload contains the
docket reference and status, patient name and patient number, the appointment reference when the
docket came from one, `currency: "PHP"`, and an `items` array with every service and retail-product
line. Each line carries its code or SKU, name, quantity, snapshotted unit price and line total.
Service prices come from the catalogue; retail unit prices are entered on the docket. Legacy retail
lines whose prices were not recorded remain unpriced, and their docket total is null rather than
invented. The payload also carries the assigned dermatologist and therapist when set, and the
treatment date and time plus the recording timestamp. It is rebuilt from the loaded docket each
time the code is opened, so it cannot show a stale patient or item. The external POS scans the code
and displays that data to raise the sale in its own system. No invoice, payment, receipt or
payment-status field exists in this application or its database, so the two systems cannot disagree
about a payment that this one never saw. The docket workspace displays every item amount and total.

---

## 4. Roles and Permissions Matrix

Authorization is enforced in two independent places, and this is worth stating plainly in the
defense: `applyRoleAccess()` in the frontend hides navigation a role cannot use, driven by
`allowedViews()`, **and** every endpoint carries its own `@PreAuthorize`. Interface visibility and
endpoint authorization are separate layers — a role such as Receptionist can read an
endpoint, such as the inventory read needed by the docket form's stock check, without having a
workspace for it.

### 4.1 Workspace access

| Workspace | Admin | Reception | Derm | Inv. Staff |
| --- | :-: | :-: | :-: | :-: |
| Overview | ● | ● | ● | ● |
| Patients | ● | ● | ● | |
| Appointments | ● | ● | ● | |
| Consultations | ● | | ● | |
| Treatment dockets | ● | ● | ● | |
| Inventory | ● | | | ● |
| Sales | ● | | | |
| Services | ● | | | |
| Reports | ● | | | ● |
| Team & access | ● | | | |
| Audit trail | ● | | | |

Therapist personnel are not a workspace role. They appear only as assignable people in the
appointment and docket forms.

### 4.2 Notable per-role behaviour

- **Administrator** — reaches all eleven workspaces and every "New" action any other role can perform.
  Two of those actions were restricted in the interface to the Receptionist alone — registering a
  patient and creating a treatment docket — even though the backend already accepted an Administrator
  for both. The buttons are now shown to either role.
- **Receptionist** — registers patients and creates appointments and dockets.
  Needs inventory read for the docket form's stock check, so it holds `/api/clinic/inventory` read
  despite having no Inventory workspace.
- **Therapist personnel** are created in Team & access with name, email, phone, age and ID number.
  They are stored separately from users and can be assigned to appointments and dockets.
- **Inventory Staff** — manages products and stock movements, and can open Reports.
- **Dermatologist** — clinical scope: consultations, plus appointment status changes.

---

## 5. Database Design

**16 tables**, created by 16 Flyway migrations. The full field-level design is in
`database/Chapter3_Table_3.4_corrected.md` — this section covers the structure and the decisions a
panel is likely to probe.

### 5.1 Migration history

| Version | Purpose |
| --- | --- |
| V1 | Baseline schema |
| V2 | Seed roles and development accounts |
| V3–V4 | Development password hash corrections |
| V5 | Remove non-admin development accounts |
| V6 | Restore development staff accounts |
| V7 | Seed requested inventory |
| V8 | Link services to the products they consume |
| V9 | Add `consultations.follow_up_date` |
| V10 | Add `patients.skin_type` and `patients.allergies` |
| V11 | Canonicalise role names and merge the duplicated Inventory Staff row |
| V12 | Store `patients.phone` in canonical E.164 |
| V13 | Accept international E.164 patient numbers |
| V14 | Remove billing, payment status and the Cashier role |
| V15 | Move therapist assignments onto separate personnel records |
| V16 | Remove patient QR support |
| V17 | Add appointment notes and scheduled follow-up appointments |
| V18 | Stop collecting consultation notes and free-text follow-up instructions |
| V19 | Allow a docket to sell a retail product |
| V20 | Separate inventory into retail-use and clinic-use stock |
| V21 | Add `users.id_number` for the Create User form, separate from `therapists.id_number` |

Migrations are immutable once applied; Flyway records a checksum and refuses to start if an applied
file is edited. A change is made by adding the next version, never by editing history. This is why
V3–V6 exist as four separate corrections rather than one amended file.

### 5.2 Table groups

| Group | Tables |
| --- | --- |
| Identity | `roles`, `users`, `therapists` |
| Clinical | `patients`, `appointments`, `consultations`, `treatment_dockets` |
| Catalogue | `services`, `service_required_products`, `products`, `suppliers` |
| Inventory | `inventory_batches`, `inventory_balances`, `inventory_movements` |
| Platform | `session_refresh_tokens`, `audit_logs` |

### 5.3 Three decisions worth defending

**Inventory is two tables, not one.** `inventory_batches` records each delivery with its batch number
and expiry; `inventory_balances` records the quantity on hand per product. A single-table design
cannot hold two deliveries of the same product with different expiry dates without either duplicating
the quantity or losing one expiry date — and it is the expiry dates that make a recall possible.

**A docket has a parent record and item lines.** A docket may contain multiple service and retail
product lines, while its parent retains patient, appointment and staff assignments. Each line
snapshots its unit price and quantity; this preserves the amount shown at creation even if the
service catalogue changes later. Retail prices are entered per docket because products have no
catalogue price. This normalized structure also lets one transaction validate and deduct stock for
every line before the docket is committed.

**Patient QR codes are not stored at all.** They have been removed with their reference table, resolve
page and scanner. The remaining QR is the treatment docket handoff, which is generated in the browser
from the docket's own data and stores nothing server-side.

**Therapists are personnel, not users.** A therapist has a name, email, phone, age and ID number in
their own table, and no password, role or session. A system user's own ID number lives on `users`,
so the two identifiers are never mixed. That separation is deliberate: assigning someone
to perform a treatment must not create a way for them to sign in or inherit a system role. Existing
Therapist accounts were migrated into personnel records, and their appointments and dockets were
repointed before the role was deleted.

### 5.4 Constraints enforced by the database

- `chk_inventory_nonnegative` — stock can never go negative.
- `chk_appointment_range` — `ends_at > starts_at`.
- `UNIQUE (assigned_user_id, starts_at)` — one staff member cannot be double-booked.
- `UNIQUE (therapist_id, starts_at)` — one therapist cannot be double-booked.
- `UNIQUE (docket_number)` — every treatment docket has one reference the POS can key on.

---

## 6. API Reference

Base path `/api`. All endpoints require `Authorization: Bearer <JWT>` unless marked public.

### 6.1 Public

| Method | Path |
| --- | --- |
| POST | `/api/auth/login`, `/api/auth/refresh`, `/api/auth/logout` |
| GET | `/api/health`, `/actuator/health` |

### 6.2 Users

| Method | Path | Roles |
| --- | --- | --- |
| GET | `/api/users` | Administrator |
| GET | `/api/users/staff` | Administrator, Receptionist, Dermatologist |
| GET | `/api/therapists` | Administrator, Receptionist, Dermatologist |
| POST | `/api/therapists` | Administrator |
| GET | `/api/users/{id}` | Administrator |
| POST | `/api/users` | Administrator |
| PUT | `/api/users/{id}` | Administrator |
| PATCH | `/api/users/{id}/status` | Administrator |
| PATCH | `/api/users/{id}/delete` | Administrator |

### 6.3 Patients

| Method | Path | Roles |
| --- | --- | --- |
| GET | `/api/patients` | all four system roles |
| POST | `/api/patients` | Administrator, Receptionist |
| PATCH | `/api/patients/{id}` | Administrator, Receptionist |
| PATCH | `/api/patients/{id}/archive` | Administrator |
| PATCH | `/api/patients/{id}/restore` | Administrator |

### 6.4 Clinic — reads

| Method | Path | Roles |
| --- | --- | --- |
| GET | `/api/clinic/appointments` | Administrator, Receptionist, Dermatologist |
| GET | `/api/clinic/consultations` | Administrator, Dermatologist |
| GET | `/api/clinic/dockets` | Administrator, Receptionist, Dermatologist |
| GET | `/api/clinic/services` | Administrator, Receptionist, Dermatologist |
| GET | `/api/clinic/inventory` | Administrator, Receptionist, Inventory Staff |
| GET | `/api/clinic/movements` | Administrator, Inventory Staff |
| GET | `/api/audit-logs` | Administrator |

### 6.5 Clinic — writes

| Method | Path | Roles |
| --- | --- | --- |
| POST | `/api/clinic/appointments` | Administrator, Receptionist |
| PUT | `/api/clinic/appointments/{id}` | Administrator, Receptionist |
| PATCH | `/api/clinic/appointments/{id}/status` | Administrator, Receptionist, Dermatologist |
| POST | `/api/clinic/consultations` | Administrator, Dermatologist |
| POST | `/api/clinic/dockets` | Administrator, Receptionist |
| POST | `/api/clinic/movements` | Administrator, Inventory Staff |
| POST | `/api/clinic/products` | Administrator, Inventory Staff |
| POST | `/api/clinic/services` | Administrator |
| PUT | `/api/clinic/services/{id}/product` | Administrator |

### 6.6 Reference numbers

Generated server-side as `<PREFIX>-<10 uppercase hex>`. Prefixes: `APT` appointment, `CON`
consultation, `TD` treatment docket, `SUP` supplier. Patient and user references are generated in
their own controllers.

### 6.7 Errors

Every error returns the same shape:

```json
{ "code": "HTTP_403", "message": "You do not have permission to perform this action.", "requestId": "..." }
```

| Exception | Status |
| --- | --- |
| `ResponseStatusException` | as thrown |
| Bean validation failure | 400 |
| `NumberFormatException` | 400 |
| Path variable type mismatch | 400 |
| `AccessDeniedException` | 403 |
| `NoResourceFoundException` | 404 |
| anything else | 500, logged server-side, generic message returned |

Stack traces, SQL and secrets are never returned to the client. `RequestIdFilter` attaches a
correlation id that appears in both the response and the server log, so a user-reported error can be
traced without exposing internals.

---

## 7. Security Model

### 7.1 Authentication

Passwords are BCrypt-hashed via `BCryptPasswordEncoder`. Login is by **email**, not username —
`users` has no username column. On success the server issues a short-lived access token and a
refresh token.

- Access token lifetime: `JWT_ACCESS_TOKEN_MINUTES`, default **15 minutes**.
- Refresh token lifetime: `REFRESH_TOKEN_DAYS`, default **30 days**.
- Refresh tokens are rotated and revoked server-side; `session_refresh_tokens` stores only the
  SHA-256 **hash** of the token, never the token itself.
- Sessions are stateless (`SessionCreationPolicy.STATELESS`); CSRF is disabled because there is no
  cookie-based session to protect.

### 7.2 Secrets

`JWT_SECRET` has **no default outside the `dev` profile**. A release build with no secret configured
refuses to start rather than signing tokens with a value committed to the repository. The same is
true of `DB_PASSWORD`. `application-dev.yml` supplies development-only fallbacks and carries a
warning that it must never be used outside local development.

### 7.3 Authorization

Two layers, as described in Section 4: navigation hiding in the browser, and `@PreAuthorize` on
every endpoint. The server layer is authoritative. A role that constructs a request by hand — rather
than by clicking — is refused exactly as if the button had been hidden.

`AccessDeniedException` is mapped to **403** explicitly (in `GlobalExceptionHandler`). Without
that handler the catch-all would report an authorization failure as a 500, which would both mislead
the user and disguise a security event as a server fault.

### 7.4 Other controls

- **CORS** — an allow-list of origins from `CORS_ALLOWED_ORIGINS`, defaulting to local development
  ports only.
- **SQL injection** — all queries are parameterised. No string-concatenated SQL exists.
- **Output escaping.** Every value that reaches `innerHTML` passes through the `escapeHtml()` helper —
  names, emails, phone numbers, clinical notes, diagnoses, service descriptions, supplier details and
  audit fields. Values that are deliberately markup (pre-built fragments), numbers, and literal strings
  chosen by a ternary are left alone. See **9.1**.
- **Audit logging** — `audit_logs` records actor, module, action, record identifier and a JSON
  metadata column.

### 7.5 Credentials hygiene — a real finding to disclose

Two development credentials were found committed or recoverable, and both have been raised and
partly remediated:

1. The MySQL password was recoverable in plaintext from PowerShell command history.
2. `hash_generator.py` — since deleted — contained the literal string `AdminCare2026!`, the
   development Administrator password, in the repository.

Both point at the same development password. The file has been removed and the repository is now
clear, but **the password itself has not been rotated and should be.** Raising this unprompted is
worth more than being asked about it.

---

## 8. Testing and Verification

**85 tests, 0 failures, 0 errors, 0 skipped.** Re-run at the time of writing.

| Suite | Tests | Covers |
| --- | --- | --- |
| `PhoneNumbersTest` | 52 | E.164 validation and formatting across countries |
| `LoginThrottleTest` | 8 | Repeated-failure lockout and per-address independence |
| `JwtAuthenticationFilterTest` | 7 | Bearer-token parsing, role authority mapping, fail-closed cases |
| `PatientServiceTest` | 6 | Patient create/update/archive behaviour |
| `PhoneCountriesTest` | 4 | Country and dial-code catalogue |
| `JwtServiceTest` | 2 | Token issue and verification; rejection of tampered or expired tokens |
| `InventoryPolicyTest` | 2 | Movement arithmetic; insufficient stock rejected |
| `PatientDtosTest` | 2 | Patient request validation |
| `GlobalExceptionHandlerTest` | 2 | Safe error responses |

### 8.1 What unit tests cannot cover, and what was done instead

The business rules are pure functions and are unit-tested. The integration behaviour — that a failed
docket leaves no partial deduction, that the API actually refuses a role — is not covered by an
automated integration suite. That is the largest honest gap in the verification story (see 9.2).

Two specific behaviours were verified empirically rather than assumed:

- **DOM event semantics.** Two duplicate form handlers were suspected unreachable. Rather than
  reasoning from the specification, the behaviour was reproduced in headless Chrome and confirmed:
  a capture-phase listener calling `stopImmediatePropagation()` prevents the later listener from
  running at all. Four such handlers were then confirmed dead and have since been removed (9.6).
- **Runtime errors.** The application is loaded in headless Chrome with `window.onerror` and
  `unhandledrejection` traps. Current result: no runtime errors.

---

## 9. Known Limitations

**This is the section to read before the defense.** Each item states what does not work, why, and the
consequence. Most are the honest boundary of an unfinished build rather than bugs. The one item that
was a genuine security defect — unescaped output in the list renderers — has since been found and
closed; 9.1 records it.

### 9.1 Unescaped output — found and fixed

**This was the most serious item in this document; it is now closed.**

Eleven list renderers built their rows by string-interpolating database values directly into
`innerHTML`, and none of them escaped. Clinically controlled free-text fields were among the values
that flowed through unescaped, including `consultations.diagnosis`,
`consultations.treatment_recommendation`, `consultations.clinical_notes` and `patients.allergies`. A
patient record whose name or allergy note contained markup was stored verbatim by the API and
re-rendered as markup by every list that displayed it, in every other user's browser — a stored
cross-site scripting vector reachable by any role permitted to create the record.

**Fixed.** Every value that reaches `innerHTML` is now passed through `escapeHtml()` (201 call sites).
No stored-XSS defect is outstanding.

### 9.2 No automated integration tests

Only unit tests exist. There is no automated test that starts the application against a database,
calls an endpoint as a given role, and asserts the response. **Consequence:** the authorization table
in Section 6 is drawn from reading `@PreAuthorize` annotations, not from a passing test that proves
each one. It was verified by inspection and by manual use, which is weaker evidence.

### 9.3 Category and description are no longer editable

The Create Service form collects the service code, name, price, duration and required products.
Saving calls `PUT /api/clinic/services/{id}` for the service fields and
`PUT /api/clinic/services/{id}/product` for the product links. Category and description remain
NOT NULL columns in `services`, but the interface no longer collects them: a new service stores
empty strings and an edit leaves any existing values untouched. They can therefore only be changed
directly in the database.

### 9.4 Billing is outside this system

There is no invoice, payment, receipt or cashier feature, and no Cashier role. Sales Management is a
non-monetary report of the services sold and their quantities, read from treatment dockets and
filtered by a Date From / Date To range; it has no price, payment, refund or paid-status column. This
is scope, not a gap: the clinic's external POS owns the money records, and the treatment docket's QR
is the handoff. The system therefore cannot report revenue, and it does not try to.

### 9.5 Suppliers — now persisted

The backend now exposes `GET`/`POST /api/clinic/suppliers`, and the supplier form posts to it, so the
supplier list loads from the database and an added supplier survives a reload.

### 9.6 Duplicate form handlers — resolved

Earlier revisions registered a second, unreachable submit handler on several forms, behind a
capture-phase handler that called `stopImmediatePropagation()`. Those duplicates have been removed;
each form now has a single submit handler.

### 9.7 User status and service archive persist

The user activate/deactivate control calls `PATCH /api/users/{id}/status` and the service
archive/restore control calls `PATCH /api/clinic/services/{id}/archive|restore` — both endpoints
exist on the backend — so each change is saved to MySQL rather than only to memory.

### 9.8 Preview mode has been removed

Earlier revisions fell back to a client-side preview mode when the backend was unreachable, which
hardcoded `authenticatedRole = 'Administrator'` and showed the full Administrator workspace to
anyone. That path has been deleted. Opening `index.html` over `file://` now shows an explicit
"backend required" notice instead of a workspace, and a failed sign-in reports the failure rather
than minting a local session.

### 9.9 Patient QR codes have been removed

The patient QR feature is gone: no QR button, scan dialog, resolve page, reference table or
`/api/qr` endpoints remain. The patient directory now shows only full name and patient number. The
treatment docket QR is separate and remains; it is generated from docket data for the external POS
and stores nothing on the server.

### 9.10 Dead configuration

- `SecurityConfig` grants `GET /api/reports/**` to Administrator and Inventory Staff.
  **No reports controller exists**, so the rule matches nothing.

### 9.11 Manual view state

Because there is no framework, each workspace re-renders by rebuilding its HTML string, and
cross-workspace state is kept in module-level arrays. This is manageable at twelve views and is the
main thing a framework would have removed.

### 9.12 Retail and clinic-use stock, movement balances, and booking conflicts

The two shelves are kept separate at every point where a product is chosen. Inventory has All,
Clinic-use and Retail-use tabs; the service requirement picker is built only from clinic-use stock;
the retail docket picker and the docket-creation endpoint both refuse non-retail stock; and the
stock-movement picker groups its options under the two shelf names. Movement history rows repeat the
shelf label, and the Reports inventory card reports product and unit totals per shelf alongside the
combined total. Low-stock and expiry report lines also name the shelf, so an alert is actionable
without opening the product.

Stock movements do not maintain a second tally. `POST /api/clinic/movements` locks the balance row,
writes the movement and updates `inventory_balances` in one transaction; the browser then reloads
the inventory from the API, so the quantity on screen is the stored balance. Opening stock and
docket deductions use the same balance row, which is why a movement, a docket and a report cannot
drift apart.

Appointment conflicts are detected before the row is written at two layers. `appointmentSlotIssue()`
checks the loaded day's appointments in the browser and blocks the submit button's request; the
create and edit endpoints then re-run the check in SQL (`starts_at < ? AND ends_at > ?`, excluding
`CANCELLED` rows and, on edit, the row itself) and answer 409 if another live appointment overlaps
the assignee's slot. The interval comparison, rather than an equal-start comparison, is what stops
a 10:15 legacy booking from being double-booked by a 10:00 slot.

---

## 10. Defense Q&A Preparation

**"Chapter 3 says React. Is the system React?"**
No, and the documentation has been corrected. The system is vanilla JavaScript with no build step,
and every mention of React, TypeScript, Tailwind, JasperReports and Apache POI has been removed from
Chapter 3. If pressed on why: the application is a twelve-view admin console; a framework would add
a toolchain and a build artifact to maintain in exchange for component reuse it does not need.

**"Why 16 tables when the documentation listed 17?"**
The earlier table described a schema that was never built — it named `bills`, `docket_services`,
`username`, `or_number` and `qr_reference`, none of which exist, and omitted
`session_refresh_tokens` entirely. It also assumed an in-system billing module and patient QR
storage, both since removed. Table 3.4 has now been
regenerated from the migrations and matches the database exactly.

**"How do you stop stock going negative?"**
Three independent layers: the form refuses a movement larger than stock on hand; `InventoryPolicy`
rejects the arithmetic server-side; and `chk_inventory_nonnegative` on `inventory_balances` means the
database itself will not store a negative quantity. The third holds even if the first two are
bypassed.

**"Two receptionists book the same product at the same time. What happens?"**
The docket transaction locks the inventory row with `SELECT ... FOR UPDATE` before validating. The
second transaction blocks until the first commits, then re-reads the reduced quantity and fails
cleanly if stock is now short. Neither docket half-completes.

**"What happens if creating a docket fails halfway?"**
It cannot. Each docket's work runs inside one `@Transactional` boundary. A shortfall on any required
product rolls back the docket, the deductions and the movements together.

**"Where is billing?"**
It is not in this system, by design. The clinic already runs an external POS, so duplicating billing
here would create two competing records of what was paid. The treatment docket's POS QR carries the
treatment details the POS needs, and payment stays in the POS where it belongs.

**"A patient's name is duplicated across three products. Does history merge them?"**
No — and it did, previously. The movement history filtered by product *name*, which merged the
movements of three distinct products that share the name `abacavir-sulfate`. It now filters on
product id, which required adding `product_id` to the API response.

**"How is the QR code protected?"**
The remaining QR is the treatment docket handoff, not a patient record code. It contains the docket
reference, patient name, item quantity/price, assigned clinicians and treatment date/time, and is
shown only inside the authenticated docket workspace. No endpoint resolves it, and the server stores
no QR reference or image.

**"What have you not finished?"**
Answer directly from Section 9: there is no automated integration test suite (9.2), and the service
form no longer collects category or description, so those legacy columns can only be changed in the
database (9.3). The stored-XSS defect that used to head this list (9.1) has
been fixed. Volunteering these before being asked is the strongest position available.

**"What would you do next?"**
In priority order: (1) an integration test suite that exercises each role against each endpoint,
converting the authorization table from inspection-based to test-proven; (2) rotate the
exposed development credentials. Output escaping, the supplier work, user status, therapist personnel
and service editing are done — see 9.1, 9.5, 9.7, 9.9 and 9.3.

---

## Appendix A — Running the System

```
# 1. Database
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -u root -p -e "CREATE DATABASE IF NOT EXISTS derma_clinic"

# 2. Backend (prompts are avoided: set the password in the shell first)
mvn -f backend/pom.xml spring-boot:run

# 3. Frontend — open index.html, or serve the folder
```

Flyway applies V1–V14 automatically on first start. **Restart the backend after any code change** —
a running process holds the old bytecode, which is the single most common cause of "the fix did not
work".

## Appendix B — Resetting to a clean database for testing

```
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqldump.exe" -u root -p --databases derma_clinic > dcms_backup.sql
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -u root -p derma_clinic < database/reset_test_data.sql
```

`database/reset_test_data.sql` removes all patients, appointments, consultations, dockets, movements,
refresh tokens and audit records, and restocks
to the opening quantities. It **keeps** roles, logins, therapists, services, products and suppliers, and never
touches `flyway_schema_history`. Both commands prompt for the password interactively, so it is never
written to shell history.

## Appendix C — Document map

| File | Contents |
| --- | --- |
| `README.md` | Project entry point |
| `API.md` | Endpoint reference and POS handoff |
| `DATABASE_MIGRATIONS.md` | Migration list, safety rules, recovery |
| `database/schema.sql` | Design baseline (migrations are authoritative) |
| `database/Chapter3_Table_3.4_corrected.md` | **Corrected Table 3.4** and §3.4.4 narrative |
| `database/reset_test_data.sql` | Test-data reset |
| `SECURITY.md`, `DEPLOYMENT.md`, `SCOPE.md`, `TRACEABILITY.md`, `REQUIREMENTS_MATRIX.md`, `FINAL_IMPLEMENTATION_REPORT.md` | Earlier working documents, **not individually audited in this pass.** Several are dated before the current implementation and are likely to describe the pre-Spring-Boot phase, but that is inferred from their dates and first lines, not verified. Check them before quoting them in the defense. |
