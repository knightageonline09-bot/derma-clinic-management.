# DermaCare Authentication and Security

## Current implementation

The front end is a single-page application served by the Spring Boot backend at `http://localhost:8080`. It has no offline or demo mode: it requires the backend and MySQL, and every record it shows comes from the database. The four development accounts are seeded by the Flyway migrations:

- Administrator: `admin@dermaclinic.test` / `AdminCare2026!`
- Receptionist: `reception@dermaclinic.test` / `Reception2026!`
- Dermatologist: `dermatologist@dermaclinic.test` / `DermCare2026!`
- Inventory Staff: `inventory@dermaclinic.test` / `InventoryCare2026!`

Therapist personnel are not accounts: they have no password, role, session or login and cannot reach any endpoint.

Sign-in is validated server-side against the BCrypt-hashed password in `users`; the backend issues a short-lived JWT access token and a rotating refresh token and enforces the signed-in role at every protected endpoint.

## Required backend controls

These controls are expected of the backend. Most are implemented; the remaining gaps are noted below.

- Issue short-lived JWT access tokens after server-side credential validation.
- Store refresh tokens securely, rotate them on use, and revoke them on logout or account deactivation.
- Hash passwords with BCrypt using a server-side work factor; never store or compare plaintext passwords in the browser.
- Enforce session expiration and token invalidation server-side.
- Return the same safe authentication error for unknown users and incorrect passwords.
- Store account activation state and reject inactive accounts before issuing tokens.
- Enforce password policy in the backend and require a password change for seeded development users.
- Enforce Administrator, Receptionist, Dermatologist, and Inventory Staff permissions at every protected API endpoint.
- Record login, logout, failed-login, authorization-failure, activation, deactivation, and password-change events in an append-only audit log.
- Keep JWT secrets, database credentials, BCrypt configuration, and encryption keys in environment or secret-manager configuration.

JWT, BCrypt, database persistence and server-side authorization are all provided by the backend.

## Security and Patient Data Protection

The following are backend responsibilities:

- BCrypt password hashing
- JWT authentication and protected endpoints
- Backend role authorization
- Request validation and parameterized persistence APIs
- Secure CORS and safe error handling
- Environment-managed secrets
- Token expiration and invalidation
- Audit logging (login throttling and lockout are not implemented)
- AES-256 encryption where applicable (not implemented)

Patient-data rules are explicit: clinical access is role and workflow limited; patient records have no QR code or public resolve page; and patient data, secrets, SQL, stack traces, and tokens must not be exposed in URLs, logs, analytics, or user-facing errors. The treatment docket QR is generated for the clinic's external POS and carries that docket's treatment details, so it is shown only inside an authenticated docket workspace and must not be displayed publicly.
