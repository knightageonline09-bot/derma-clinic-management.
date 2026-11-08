# Deployment Checklist

## Application

- [ ] Spring Boot backend exists and builds with Java 21.
- [ ] React/TypeScript frontend has a locked dependency file and production build.
- [ ] No demo credentials or browser-only authentication remain in production artifacts.
- [ ] No hardcoded localhost API URL is used in production.

## Configuration and secrets

- [ ] Production environment values are supplied outside source control.
- [ ] JWT secret is generated securely and is at least 256 bits.
- [ ] Database password and AES-256 key are stored in a secret manager.
- [ ] CORS allows only approved HTTPS frontend origins.
- [ ] Production error responses redact SQL, stack traces, tokens, and clinical data.

## Database

- [ ] MySQL 8+ is provisioned with InnoDB.
- [ ] Least-privilege application user is configured.
- [ ] Versioned migrations ran successfully.
- [ ] Foreign keys, indexes, unique constraints, status checks, and inventory checks verified.
- [ ] Fictional seed data is isolated to development.

## Security and privacy

- [ ] BCrypt password hashing is active.
- [ ] JWT access-token expiration and refresh-token rotation work.
- [ ] Logout and account deactivation revoke sessions.
- [ ] Backend role authorization is tested directly through API calls.
- [ ] Rate limiting is active for login and sensitive endpoints.
- [ ] Treatment docket QR payloads are version 4, include every item line and amount, are rebuilt from the current docket on every open, contain only docket/treatment data, and contain no billing state.
- [ ] Clinical data is not exposed through URLs, QR payloads, logs, or analytics.

## Operations

- [ ] HTTPS certificates and secure headers are configured.
- [ ] Encrypted daily backups are running.
- [ ] Restore procedure was tested.
- [ ] Health checks, metrics, alerts, and certificate-expiry monitoring are active.
- [ ] Inventory, authorization, login, and report failures are observable.
- [ ] Recovery owner, retention, RPO, and RTO are documented.

## Acceptance

- [ ] Unit tests pass.
- [ ] Integration tests pass.
- [ ] Authorization and security tests pass.
- [ ] End-to-end clinic workflow passes.
- [ ] Requirement status is updated in [TRACEABILITY.md](TRACEABILITY.md).
- [ ] No real patient information or production secrets are included in the release.
