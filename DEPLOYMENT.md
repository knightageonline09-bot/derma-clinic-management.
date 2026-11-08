# Deployment Readiness

## Current status

This repository contains a dependency-free single-page front end, a Spring Boot backend, and the MySQL schema and versioned migrations. A production deployment is **not ready** until production configuration, secrets, HTTPS, backups, monitoring and the remaining hardening are in place.

## Production configuration

- Use `APP_ENV=production` and production configuration profiles.
- Keep the frontend and API URLs configurable through environment variables.
- Do not use the development demo credentials or browser-only in-memory data in production.
- Do not hardcode `localhost` as a production API dependency. Localhost may be used only by a documented local-development profile.
- Serve the frontend and backend over HTTPS only.

## Environment variables and secret handling

Use [.env.example](.env.example) as the non-secret template. Replace every placeholder through a deployment secret manager or protected environment configuration. Never commit passwords, JWT secrets, database passwords, AES keys, production API tokens, or real patient information.

Required secret/configuration groups include MySQL connection values, JWT and refresh-token settings, AES-256 key material, trusted CORS origins, public frontend/API URLs, logging level, and private backup destination.

## Database and migrations

1. Provision MySQL 8+ with InnoDB and an encrypted connection.
2. Create an application database and least-privilege application user.
3. Run the versioned migration tool from the backend project against the target database.
4. Verify foreign keys, indexes, unique constraints, status checks, and non-negative inventory constraints.
5. Run fictional development seed data only in a development environment.
6. Never run reset or seed commands against production.

The normalized schema is [database/schema.sql](database/schema.sql). It is a design baseline; the versioned migrations under `backend/src/main/resources/db/migration` are authoritative.

## Frontend and backend builds

Frontend production build requirements:

- Use the project package manager and a locked dependency file once the React/Vite frontend is initialized.
- Build static assets with production mode enabled.
- Configure the API base URL from environment configuration.
- Serve assets behind HTTPS with cache headers and no development credentials.

Backend production build requirements:

- Build the Java 21 Spring Boot service with a locked Maven or Gradle dependency graph.
- Run migrations before application startup or through a controlled release step.
- Enable Spring Security, CORS, validation, audit logging, health checks, and structured safe error responses.
- Run unit, integration, authorization, inventory transaction, reporting, and end-to-end tests before release.

The React/Vite frontend production build is **NOT IMPLEMENTED**; the backend builds with Maven and runs its migrations before startup.

## CORS and HTTPS assumptions

- Allow only explicitly configured HTTPS frontend origins.
- Do not use wildcard CORS in production.
- Require HTTPS for browser/API traffic, cookies, refresh-token handling, and database connections where supported.
- Configure secure headers, secure cookies where applicable, and reverse-proxy TLS termination with trusted forwarding settings.

## Backups and recovery

- Perform encrypted daily MySQL backups and retain multiple recovery points.
- Store backups separately from the primary database with restricted access.
- Test restoration regularly in an isolated environment.
- Document recovery owner, restore command, retention period, recovery point objective, and recovery time objective before production launch.
- Do not include patient exports or secrets in unencrypted backup locations.

## Monitoring and operations

Monitor application health, database connectivity, migration status, request latency, error rates, authentication failures, authorization failures, inventory transaction failures, backup success, disk capacity, and certificate expiry. Alert on repeated login failures, database errors, negative-inventory prevention events, and report-generation failures. Keep logs structured and redact tokens, passwords, clinical details, and secrets.

## Release checklist

- [ ] Production backend exists and passes tests.
- [ ] MySQL migrations run successfully.
- [ ] Secrets are supplied outside source control.
- [ ] HTTPS and restricted CORS are enabled.
- [ ] No real patient data is in seed files or test fixtures.
- [ ] Backups and restore procedure are tested.
- [ ] Monitoring and alerts are configured.
- [ ] Frontend and backend builds use production configuration.
- [ ] No hardcoded localhost or demo credentials remain in production artifacts.
