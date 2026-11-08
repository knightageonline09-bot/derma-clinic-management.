# API Documentation

## Status

Implemented in the Spring Boot backend. The routes below are live. Paths are grouped under `/api/clinic` rather than
the flat paths originally sketched in this document.

## Conventions

- JSON request and response bodies.
- JWT access token required for protected endpoints.
- Refresh tokens are rotated and revoked server-side.
- Backend role authorization is mandatory.
- DTO validation occurs before service logic.
- Errors use a safe structure such as `{ "code": "SAFE_CODE", "message": "User-safe message", "requestId": "..." }`.
- Never return stack traces, SQL, secrets, complete QR payload data, or unnecessary clinical details.

## Endpoint areas

| Area | Endpoints | Roles |
| --- | --- | --- |
| Auth | `POST /api/auth/login`, `POST /api/auth/refresh`, `POST /api/auth/logout` | Public |
| Health | `GET /api/health`, `GET /actuator/health` (public); `GET /actuator/info`, `GET /actuator/metrics` | Administrator for non-health actuator endpoints |
| Users | `GET /api/users`, `GET /api/users/staff`, `GET /api/users/{id}`, `POST /api/users`, `PUT /api/users/{id}`, `PATCH /api/users/{id}/status`, `PATCH /api/users/{id}/delete` | Administrator; `/staff` (active dermatologists) also accessible to Receptionist and Dermatologist. `POST` requires `fullName`, `email`, a unique `idNumber`, `password` and `role`; `PUT` accepts `idNumber` and leaves the stored value unchanged when it is omitted. An account's ID number is separate from a therapist's personnel ID |
| Therapists | `GET /api/therapists`, `POST /api/therapists` | Read: Administrator, Receptionist, Dermatologist (the appointment and docket forms need the list). Create: Administrator. Therapists are personnel records, not users: no password, role, session or login |
| Patients | `GET /api/patients`, `GET /api/patients/archived`, `POST /api/patients`, `PATCH /api/patients/{id}`, `PATCH /api/patients/{id}/archive`, `PATCH /api/patients/{id}/restore` | Active and archived lists: all clinical roles. Create: Administrator, Receptionist. Edit: Administrator, Receptionist. Archive/restore: Administrator. The directory response is displayed as full name and patient number only |
| Appointments | `GET /api/clinic/appointments`, `POST /api/clinic/appointments`, `POST /api/clinic/appointments/follow-up`, `PUT /api/clinic/appointments/{id}`, `PATCH /api/clinic/appointments/{id}/status` | Administrator, Receptionist, Dermatologist. Regular create and edit: Administrator, Receptionist. Consultation follow-up scheduling (`consultationId`, `date`, `time`, optional assignment and notes): Administrator and Dermatologist; it links the appointment to the selected consultation, and a Dermatologist's follow-up is assigned to the signed-in clinician. Status updates include `PENDING`, `CONFIRMED`, `COMPLETED` and `CANCELLED`; canceled appointments remain in the schedule history and no longer occupy their time slot. An appointment takes an optional `staffId` (dermatologist user) and an optional `therapistId` (therapist personnel record), with at least one required, plus optional `notes`. The book runs 30-minute slots from 10:00 to 22:00; a start off the half hour, before opening, or one that would run past closing returns 400, and an overlapping live appointment for the same assignee returns 409. The list response carries `phoneDisplay`, `notes` and `patientNumber` for each book entry |
| Consultations | `GET /api/clinic/consultations`, `POST /api/clinic/consultations` | Administrator, Dermatologist. A new consultation records `patientId`, `diagnosis` and `recommendation`; clinical notes and free-text follow-up instructions are no longer collected. `followupDate` (`YYYY-MM-DD`) and `followupTime` (`HH:MM`) are optional as a pair — supplying one without the other returns 400. When both are supplied, the same transaction inserts an appointment for the signing clinician at that slot, subject to the same book window and conflict rule, and the consultation stores its id |
| Dockets | `GET /api/clinic/dockets`, `POST /api/clinic/dockets` | Read: Administrator, Receptionist, Dermatologist. Create: Administrator, Receptionist. `POST` takes a non-empty `items` array; each line is either `{ "type": "SERVICE", "serviceId": 1 }` or `{ "type": "PRODUCT", "productId": 2, "quantity": 1, "unitPrice": 25.00 }`. Service quantity is fixed at one and its current catalogue price is snapshotted. A retail line requires a non-negative unit price (up to two decimals), which is snapshotted on the docket; quantity must be greater than zero with up to three decimals. The active retail product must have `usageType = 'RETAIL'`; clinic-use stock and archived products are refused. `therapistId` refers to a therapist personnel record. Every service line deducts all products it requires and every retail line deducts its product quantity. The full docket and all deductions are transactional, so any shortfall rolls back all lines and movements. `POST` returns `docketId`, `docketNumber` and the calculated `total`. `GET` returns `items` with `name`, `quantity`, `unitPrice` and `lineTotal`, plus the docket `total`; a legacy retail line whose historic price was not recorded has null amounts and makes its docket total null rather than inventing a value. The client opens a version 4 POS QR containing every item and amount. Payment remains with the external POS |
| Services | `GET /api/clinic/services`, `POST /api/clinic/services`, `PUT /api/clinic/services/{id}`, `PUT /api/clinic/services/{id}/product`, `PATCH /api/clinic/services/{id}/archive`, `PATCH /api/clinic/services/{id}/restore` | Catalogue view: Administrator. Read: also Receptionist and Dermatologist, for the docket form's service picker. Write and archive/restore: Administrator. Create and update collect service code, name, price and duration; Category and Description are no longer collected, and an update leaves any existing values in those legacy columns untouched. `PUT .../product` replaces the required-product list from rows of `productId` and `quantity`; the list response adds each product's `unit` so the form can show Product name, Required quantity and Measurement unit, with the quantity defaulting to 1 |
| Inventory | `GET /api/clinic/inventory`, `GET /api/clinic/inventory/archived`, `GET /api/clinic/movements`, `POST /api/clinic/movements`, `POST /api/clinic/products` | Administrator, Inventory Staff. Inventory read also Receptionist. `POST /api/clinic/products` requires `name`, `sku` (the product code), `unit` and an active `supplierId`, and takes `usageType` (`RETAIL` or `CLINIC`, default `CLINIC`), plus optional `quantity` (opening stock, default 0) and `expiry` (`YYYY-MM-DD`). A quantity above zero requires `expiry` and is written in the same transaction as a Stock In movement with its balance and batch, so opening stock is explainable like any delivery; a negative quantity returns 400, and a duplicate code returns 409. Each inventory row returns `usageType`, `stock`, `reorder`, the nearest batch `expiry`, and a computed `stockStatus` of `IN_STOCK`, `LOW_STOCK`, `NEARLY_EXPIRED` or `EXPIRED`, decided by urgency (expired, then nearly expired, then low stock, then in stock); an expiry only counts while quantity is above zero. `POST /api/clinic/movements` takes `productId`, `quantity` and a `type` of `STOCK_IN` or `STOCK_OUT`; any other type or a quantity not greater than zero returns 400. Stock In requires `expiry` (`YYYY-MM-DD`) and reuses the batch already carrying that date or opens one under a generated number, so no batch number is sent; Stock Out leaves the earliest-expiring batch first. The save updates `inventory_balances` in the same transaction, increasing it for Stock In and decreasing it for Stock Out, and a deduction that would fall below zero returns 400. The movement list returns product name, its `usageType` (`CLINIC` or `RETAIL`), movement type and the product's supplier, resolved from the catalogue rather than the request. The archived listing is Administrator only |
| Products | `PATCH /api/clinic/products/{id}/archive`, `PATCH /api/clinic/products/{id}/restore` | Administrator only. Products are never deleted: a product is referenced by stock movements, inventory batches and service requirements, which must stay explainable. Archiving sets `status = 'ARCHIVED'`, hides the product from the active inventory list and leaves every linked record intact; restore reverses it. The SKU stays reserved either way |
| Suppliers | `GET /api/clinic/suppliers`, `POST /api/clinic/suppliers` | Administrator, Inventory Staff. `POST` requires `name`; the supplier code is generated. `GET` returns the active products assigned to each supplier as a comma-joined `products` string alongside `productCount` |
| Audit | `GET /api/audit-logs` | Administrator |

## Critical backend workflows

Treatment creation runs in one database transaction: resolve the service's required products, lock the inventory
rows with `SELECT ... FOR UPDATE`, validate every required quantity, deduct each product, write the inventory
movements against the docket, and create the docket. Any shortfall rolls back the entire operation, so a failed
docket leaves no movement and no partial deduction behind.

Billing is not part of this system. Payment is processed by the clinic's external POS, and this API has no invoice,
payment, receipt or sales endpoint. The Sales Management workspace is a read-only, non-monetary report derived in
the browser from `GET /api/clinic/dockets`: it groups service lines by service and shows the quantity sold in a
chosen date range. Creating a docket returns its `docketId`, `docketNumber` and total, and the client opens that
docket's POS QR immediately. The version 4 JSON payload uses the fixed `type` marker
`dermaclinic.treatment-docket`, the docket reference and status, patient name and reference, the appointment
reference when the docket came from one, `currency: "PHP"`, and an `items` array containing every service or retail
line with its code or SKU, name, quantity, unit price and line total. The docket total is included when every line
has a known price; legacy retail lines whose prices were not recorded remain null and make the total null. The QR
also carries the assigned dermatologist and therapist when set, treatment date and time, and recording timestamp.
It contains no billing state because no billing record exists here to send. The docket workspace, patient history,
preview and printed view display every item amount and the aggregate total. The payload is built on each open from
the docket data currently loaded from the API, so a reopened QR reflects the stored docket rather than a stale copy.

Therapists are stored in their own `therapists` table. They have no `users` row, password, role, session or login;
they exist only to be assigned to appointments and dockets. A therapist is created from Team & access with name,
email, phone, age and ID number. System users carry their own `users.id_number`, so the two kinds of
record never share an identifier.

The treatment docket QR is generated entirely in the browser; there is no QR endpoint. Patient QR codes, their
resolve page and the `secure_qr_references` table have been removed, so a patient record cannot be opened by
scanning a code.
