# Derma Clinic Management System

A responsive clinic-operations interface for patient management, appointments, consultations, treatment dockets, inventory, service sales, reports, user administration, audit, and security workflows.

## Current implementation status

This repository contains a normalized MySQL schema, a Spring Boot backend
(authentication, patients, appointments, consultations, treatment dockets, inventory, and audit), and a
dependency-free single-page front end that the backend serves at `http://localhost:8080`. The interface has no offline
or demo mode: it requires the backend and MySQL, and every record it shows comes from the database. It is **not
production-ready** in the sense that the front end is the single-page application rather than the React/TypeScript
application described under "System overview".

Production requirements and incomplete areas are recorded in [TRACEABILITY.md](TRACEABILITY.md).

## System overview

The intended production architecture is:

```text
Browser
  -> React + TypeScript + Tailwind CSS
  -> REST API
  -> Spring Boot controllers
  -> application services and domain rules
  -> repositories
  -> MySQL 8+
```

The current front end is [index.html](index.html), served by the backend at `http://localhost:8080`. Opening the file directly (`file://`) does not work: the page cannot reach the API and refuses to run.

## Technology requirements

### Current front end

- Modern browser: Chrome, Edge, Firefox, or Safari
- No package installation required for the front end itself
- A running backend and MySQL instance (see "Running the application")
- The typefaces are served from this repository (the `@font-face` block in `styles.css`), and QRCode.js is vendored locally as `qrcode.min.js` for the treatment docket POS handoff, so the page makes no third-party request and is not dependent on a CDN

### Target production system

- Java 21
- Spring Boot 3
- Spring Security
- React, TypeScript, and Tailwind CSS
- MySQL 8+ with InnoDB
- Flyway or Liquibase migrations
- Redis or equivalent short-lived security state where required
- JJWT or an approved JWT implementation
- JasperReports for PDF output
- Apache POI for Excel output
- Maven or Gradle

## Installation and startup

### Running the application

1. Clone the repository.
2. Start MySQL and apply `database/schema.sql`.
3. Create the `.env` file at the repository root with the database credentials (see below).
4. Start the backend: `cd backend && mvn spring-boot:run`
5. Open **`http://localhost:8080`** in Chrome or Edge.
6. Sign in with a database account.

### Database credentials

The backend reads its credentials from a gitignored `.env` file at the repository root, not from
the command line. Passing a password as an argument puts it in your shell history in plain text,
where it stays readable indefinitely; the file keeps it out of both history and the repository.

```
DB_USER=derma_app
DB_PASSWORD=<runtime account password>
FLYWAY_USER=derma_flyway
FLYWAY_PASSWORD=<migration account password>
```

Two accounts are used on purpose. `derma_app` is what the application connects as, and it holds
only `SELECT`, `INSERT`, `UPDATE` and `DELETE` on `derma_clinic`. It cannot create, alter or drop
anything, so neither a bug nor a compromised connection can reshape the schema. `derma_flyway`
holds the DDL rights that migrations need and is used only by Flyway at startup. Neither account
has `GRANT` rights or access to any other schema. The `root` account is for administration only
and is not used by the application.

`FLYWAY_USER` and `FLYWAY_PASSWORD` fall back to `DB_USER` and `DB_PASSWORD` if unset, which keeps
single-account setups working — but then that account needs DDL rights, giving up the separation.

`JWT_SECRET` must still be supplied externally; the dev profile ships a throwaway default that is
deliberately unusable in production.

The backend serves the front end from the same origin as the API, so there is no CORS
preflight and the credentials used are the real ones in `users`.

Do **not** open `index.html` directly by double-clicking it. A `file://` page sends `Origin:
null`, cannot reach the API, and is rejected by the backend. The page detects this and shows a
message telling you to use `http://localhost:8080`, instead of silently substituting fake data.

## Development accounts

These development accounts are seeded by the Flyway migrations and must never be used in production:

| Role | Email | Password |
| --- | --- | --- |
| Administrator | `admin@dermaclinic.test` | `AdminCare2026!` |
| Receptionist | `reception@dermaclinic.test` | `Reception2026!` |
| Dermatologist | `dermatologist@dermaclinic.test` | `DermCare2026!` |
| Inventory Staff | `inventory@dermaclinic.test` | `InventoryCare2026!` |

Passwords are stored as server-side BCrypt hashes and sessions are JWT tokens signed with `JWT_SECRET`. Production accounts must use their own credentials and environment-managed secrets.

## Environment variables

Copy [.env.example](.env.example) into a secret-managed development or deployment configuration. Never commit the copied file with real values. The template covers frontend/API URLs, MySQL, JWT expiry, AES-256 key material, CORS origins, logging, and backups.

## Database configuration

The normalized schema baseline is [database/schema.sql](database/schema.sql). It defines users, roles, therapist personnel, patients, appointments, consultations, treatment dockets, services, products, suppliers, inventory, sessions, and audit logs. Billing is out of scope: payment is handled by the clinic's external POS, and a treatment docket's QR carries its treatment details to that POS.

For production, create a least-privilege MySQL application user, require InnoDB, enable encrypted connections where supported, and run versioned migrations. See [DATABASE_MIGRATIONS.md](DATABASE_MIGRATIONS.md).

## Backend startup

The Spring Boot backend is implemented and runs against MySQL 8+ via Flyway migrations. Local startup sequence:

```text
1. Start MySQL 8+.
2. Export DB_PASSWORD (and DB_USER if not root).
3. Start the Spring Boot application with the development profile.
4. Confirm /api/health and /actuator/health both answer.
```

```bash
export DB_PASSWORD=your-local-mysql-password
mvn -f backend/pom.xml spring-boot:run
```

The `spring-boot:run` goal defaults to the `dev` profile (configured in [backend/pom.xml](backend/pom.xml)), so no
`-D` flag is needed — the command above works unchanged in PowerShell, cmd, and Git Bash. Passing
`-Dspring-boot.run.profiles=dev` by hand still works, but PowerShell splits it at the first dot and fails; the POM
default exists to avoid that. This default affects only the Maven run goal: a packaged jar started with `java -jar`
uses no profile unless one is passed explicitly.

The development profile is [application-dev.yml](backend/src/main/resources/application-dev.yml). It supplies a
development-only JWT signing key. **No database password is committed anywhere** — `DB_PASSWORD` is always read from
the environment, so the application fails fast rather than starting with a default credential. Production must set
`JWT_SECRET` and `DB_PASSWORD` through a secret manager; the base [application.yml](backend/src/main/resources/application.yml)
defines no fallback for either.

If Flyway reports a checksum mismatch, see [DATABASE_MIGRATIONS.md](DATABASE_MIGRATIONS.md).

## Frontend startup and build

The current front end is [index.html](index.html), served by the backend at `http://localhost:8080`. A future React/Vite frontend should use a locked dependency file and commands equivalent to:

```bash
npm ci
npm run dev
npm run build
```

The production API base URL must come from environment configuration. Production builds must not depend on `localhost` or demo credentials.

## Treatment docket QR codes

Patient QR codes are not part of the system. A patient record has no QR code, resolve page, scanner or reference
table; the patient directory shows only the patient's full name and patient number.

The one QR code remaining is the **treatment docket** handoff to the clinic's external POS. A docket can contain
multiple treatment services and retail products; each line shows its quantity, price snapshot and amount, and the
docket displays the aggregate total. Service prices are taken from the catalogue, while retail unit prices are
entered on the docket. Old retail dockets whose price was never stored remain unpriced rather than receiving an
invented total. The version 4 QR is generated from every docket line and carries the docket reference and status,
patient name and number, appointment reference, item codes or SKUs, quantities and amounts, currency, assigned
dermatologist/therapist, and treatment date/time — but no payment or billing state. The payload is rebuilt from the
loaded docket every time the code is opened, so a reopened QR reflects the stored record. Every new docket opens its
QR immediately after it is created, and the **POS QR** action reopens it later.

## Migrations

Use [DATABASE_MIGRATIONS.md](DATABASE_MIGRATIONS.md) for the migration order, safety rules, rollback expectations, and verification steps. The current `database/schema.sql` is a design baseline, not a versioned migration system.

## Seed data

Use [SEED_INSTRUCTIONS.md](SEED_INSTRUCTIONS.md). Seed data must be fictional, resettable, development-only, and never run against production.

## API documentation

The REST surface and authorization expectations are documented in [API.md](API.md). The endpoints are implemented in the Spring Boot backend.

## Stock and scheduling rules

Products are stored on one of two shelves, `CLINIC` or `RETAIL`. The Inventory workspace separates them with
All / Clinic-use / Retail-use tabs; a treatment service's required-product picker offers only clinic-use stock,
the retail docket picker offers only retail-use stock, and the stock-movement picker groups its options under
"Clinic-use stock" and "Retail-use stock". Movement history labels every row with its shelf, and the Reports
inventory card reports product and unit totals for each shelf as well as the combined figure.

Every Stock In and Stock Out writes a movement and updates `inventory_balances` in the same transaction, so the
quantity in the inventory list is the stored balance and not a separate tally. The form, the policy check and the
database constraint all reject a deduction below zero.

Appointments are checked for conflicts twice: the form refuses an overlapping slot before the request is sent, and
the create and edit endpoints re-check the assigned user and therapist in the database (excluding cancelled
appointments and the appointment being edited) before writing. Slot boundaries are 30 minutes from 10:00 to 22:00.

## Interface and design

The front end is a single design system rather than a set of ad-hoc rules. `styles.css` opens with a `:root`
token block — surfaces, borders, four ink levels, accent, status colours, a 12–29px type scale, spacing, radii,
elevation and stacking layers — and every other rule is expressed in terms of those tokens. There are no colour
or font-size literals outside `:root`, which is what keeps the palette and the type scale consistent as screens
are added.

- **Type.** The scale bottoms out at 12px. Body copy is 13–14px, section headings 16–20px, page titles 24–29px.
  Earlier revisions set most text at 8–10px, which is the defect this work removes.
- **States.** Every control class — primary, secondary and text buttons, icon buttons, nav items, pagination,
  modal controls, row actions — defines hover, active, disabled and keyboard focus. Focus rings are drawn with
  `:focus-visible`, so mouse users do not see them while keyboard users always can. The search inputs previously
  suppressed focus entirely; they now draw a ring on `:focus-within`.
- **Layout.** Breakpoints at 1050/850/760/560/550/500/400px. Below 760px the grid-based list rows (`.patient-row`,
  `.movement-row`) collapse from columns into stacked cards so every module stays usable on a phone, and the
  fixed-height topbar becomes `min-height` so taller text is not clipped.
- **Accessibility.** Every modal is a labelled `role="dialog"` with `aria-modal`, closes on Escape and on a
  backdrop press, moves focus inside on open and returns it to the control that opened it. Icon-only buttons
  carry accessible names, the toast is an `aria-live` region, the sidebar is a labelled `<nav>`, the active item
  is marked `aria-current="page"`, and a skip link reaches `#main-content`.

Printing renders a dedicated sheet: `app.js` fills `#printView` with the record being printed and the print
stylesheet hides every other body child, so a printed docket or report contains only that document
rather than the application chrome.

## Testing

Current front end checks (backend and MySQL must be running):

- Open `http://localhost:8080` in a browser.
- Test login/logout and refresh persistence.
- Test role-specific navigation.
- Test patient search, registration, and archive/restore.
- Test appointment validation and updates.
- Test inventory movement and insufficient-stock rejection.
- Test inventory movements, reports, and exports, and the docket QR that hands treatment details to the external POS.
- Test audit and scope workspaces.

Target production checks:

```text
Unit tests       -> calculations, validation, permissions, state transitions
Integration tests -> authentication, repositories, transactions, reports, audit
End-to-end tests  -> login -> patient -> appointment -> treatment -> POS QR handoff
Security tests    -> authorization bypass, expired JWT, revoked refresh token
```

## Deployment

Read [DEPLOYMENT.md](DEPLOYMENT.md) and complete [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md). Production must use HTTPS, restricted CORS, external secrets, MySQL migrations, backups, monitoring, and no real patient data in seed files.

## Backups

Use encrypted daily MySQL backups, private storage, retention rules, access controls, and regular restoration tests. Do not place secrets, tokens, or unencrypted clinical exports in backup locations.

## Troubleshooting

- **The page is blank:** confirm the backend is running and open the site at `http://localhost:8080`. Opening `index.html` over `file://` is refused, because the page cannot reach the API from there.
- **A docket QR is not visible:** confirm `qrcode.min.js` is being served from the same origin as the page. The library is vendored, so no CDN access is required.
- **The login does not work:** confirm the backend and MySQL are running and use an account from `users` (development accounts are listed above).
- **The session disappears:** the access token expired and the refresh token could not be renewed; sign in again.
- **A role cannot see a module:** role-aware navigation is intentional. Production must enforce the same permissions in the backend.
- **A docket QR will not scan:** confirm `qrcode.min.js` is served and the POS expects the JSON payload shown under the code.
- **Inventory will not deduct:** the required product quantity is unavailable; no docket or movement should be created.
- **Production API fails:** check environment variables, HTTPS, CORS origins, database connectivity, migrations, and backend logs without exposing secrets.

## Security configuration

See [SECURITY.md](SECURITY.md). Production must use BCrypt, JWT access tokens, secure refresh-token rotation and invalidation, server-side role authorization, request validation, parameterized persistence APIs, safe errors, rate limiting, AES-256 where applicable, audit logging, and environment-managed secrets.

## Scope

See [SCOPE.md](SCOPE.md) for features explicitly out of scope, including pharmacy integration, insurance claims, telemedicine, laboratory integration, SMS, online payments, dedicated mobile apps, and multi-branch synchronization.
