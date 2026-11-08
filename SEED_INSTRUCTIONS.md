# Development Seed Instructions

## Status

Development seed data is applied by the Flyway migrations. There is no separate production seed tooling.

## Seed requirements

Development seed data must contain fictional values for roles, users, patients, services, products, suppliers, inventory, appointments, consultations, treatment dockets, therapist personnel, and audit events. Billing data is not seeded: payment is handled by the external POS.

Seed data must:

- Be resettable and deterministic.
- Never contain real patient information.
- Never contain production passwords, tokens, keys, or database credentials.
- Mark accounts as development-only and require password changes before production.
- Be blocked from running when the production profile is active.

## Commands

The backend is started with commands equivalent to:

```bash
mvn -f backend/pom.xml flyway:migrate
mvn -f backend/pom.xml spring-boot:run
```

There is no Maven wrapper in this repository, so `./mvnw` is not available — use the installed `mvn`. The
`spring-boot:run` goal defaults to the `dev` profile, so no `-D` flag is required.

Seed data is applied by the migrations, so no separate seed command exists. Never run a reset command against production.

## Verification

After seeding, verify login for each role, role permissions, patient search, appointments, consultations, inventory, reports, the treatment docket POS QR, and audit events. Confirm that no seed file contains real people or production secrets.
