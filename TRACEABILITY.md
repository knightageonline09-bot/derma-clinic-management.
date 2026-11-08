# Derma Clinic Management System Traceability

This table tracks each requirement against what is implemented. `PREVIEW` here means the workflow is demonstrable in the browser; `IMPLEMENTED` means it is backed by the Spring Boot/MySQL backend; `NOT IMPLEMENTED` means the production requirement is still absent.

| Requirement | Status | Evidence / limitation |
| --- | --- | --- |
| Responsive sidebar and header | PREVIEW | Responsive browser layout in `index.html` and `styles.css`. |
| Role-aware navigation | PREVIEW | Navigation visibility follows the signed-in role. |
| System-user creation | PREVIEW | The Create User form collects full name, email, ID number, password with confirmation, and role. Therapist personnel are created in a separate form and stored in their own table, with no account or sign-in. |
| Tables, forms, search, filters | PREVIEW | Patient, appointment, inventory, reports, and user workspaces. |
| Pagination | PREVIEW | Patient directory pagination. |
| Modals and confirmation dialogs | PREVIEW | Forms, profile dialogs, docket POS QR, archive/restore confirmation. |
| Toast, loading, empty, error states | PREVIEW | Shared toast, workspace loading state, empty table messages, form errors. |
| Keyboard focus and accessible controls | PREVIEW | Visible `:focus-visible` states, labels, live status messaging. |
| Real database records | IMPLEMENTED | The normalized schema, the Spring Boot/JPA backend and the domain repositories and controllers are implemented, and the migrations run against MySQL. |
| Backend role authorization | IMPLEMENTED | Spring Security route rules, the JWT filter and per-endpoint `@PreAuthorize` checks are implemented; verified by inspection and manual use, not by an automated authorization test. |
| Transaction-safe inventory deduction | IMPLEMENTED | The docket transaction locks the inventory rows with `SELECT ... FOR UPDATE` and rolls back on any shortfall. |
| Retail and clinic-use stock separation | PREVIEW | Inventory tabs, service requirement picker (clinic only), retail docket picker (retail only), grouped movement picker, shelf label on movement rows, and a per-shelf Reports breakdown. |
| Automatic inventory quantities | IMPLEMENTED | Each Stock In/Stock Out writes a movement and updates `inventory_balances` in one transaction; the browser reloads the balance after saving. Negative balances are refused by the form, the policy and the database constraint. |
| Appointment conflict detection | PREVIEW | `appointmentSlotIssue()` blocks an overlapping save in the browser; create/edit endpoints re-check the assignee intervals in SQL and return 409, excluding cancelled appointments and the row being edited. |
| Treatment docket QR handoff | IMPLEMENTED | Generated in the browser from current docket data as a version 4 JSON payload (reference/status, patient, appointment, currency, every item with quantity and amounts, clinicians, date/time); no billing state and no QR endpoint. |
| Service catalogue | PREVIEW | The Create Service form collects code, name, price and duration; each required-product row shows Product name, Required quantity (default 1) and Measurement unit. Category and Description are no longer collected. |
| Sales Management (service quantities) | PREVIEW | Administrator-only workspace reads treatment dockets, filters by Date From / Date To, and shows only Service and Quantity; no monetary or payment state is displayed. |
| JWT, refresh tokens, BCrypt, AES-256 | PARTIALLY IMPLEMENTED | JWT, refresh-token rotation/revocation and BCrypt are implemented; AES-256 is not. |
| Real PDF and Excel exports | NOT IMPLEMENTED | Print is supported; JasperReports and Apache POI are not integrated. |
| Patient QR resolution | REMOVED | Patient QR codes, their reference table, resolve page and scanner were removed. The treatment docket QR is a browser-generated POS handoff. |
| Audit immutability | IMPLEMENTED | Audit events are written on each action and read through `GET /api/audit-logs`, which is Administrator-only. |
| No fake feature rule | IMPLEMENTED | No preview-only records exist; the interface reads its display values from the database. |
| Deployment readiness | PARTIALLY IMPLEMENTED | [DEPLOYMENT.md](DEPLOYMENT.md) documents production configuration, environment variables, HTTPS, CORS, builds, migrations, backups, and monitoring; production deployment itself is not verified. |
| Explicitly out of scope | DOCUMENTED | [SCOPE.md](SCOPE.md) records excluded integrations and prevents silent scope expansion. |
| Developer documentation | DOCUMENTED | [README.md](README.md) explains the current implementation, target architecture, setup, testing, security, deployment, and limitations. |
| Database migration instructions | DOCUMENTED | [DATABASE_MIGRATIONS.md](DATABASE_MIGRATIONS.md) records the migration order and safety rules. |
| Seed instructions | DOCUMENTED | [SEED_INSTRUCTIONS.md](SEED_INSTRUCTIONS.md) records fictional development seed requirements. |
| API documentation | DOCUMENTED | [API.md](API.md) defines the REST areas, roles, errors, and critical transactions. |
| Deployment checklist | DOCUMENTED | [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) records release gates for configuration, security, database, operations, and acceptance. |
| Requirements matrix | PARTIALLY IMPLEMENTED | [REQUIREMENTS_MATRIX.md](REQUIREMENTS_MATRIX.md) tracks implementation and acceptance status. |
| Final implementation report | PARTIALLY IMPLEMENTED | [FINAL_IMPLEMENTATION_REPORT.md](FINAL_IMPLEMENTATION_REPORT.md) records completed, partial, and outstanding work. |
