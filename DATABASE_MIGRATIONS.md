# Database Migration Instructions

## Status

Flyway is implemented. Versioned migrations live in
[backend/src/main/resources/db/migration](backend/src/main/resources/db/migration) and run automatically on
application startup, controlled by `spring.flyway` in [application.yml](backend/src/main/resources/application.yml).
[database/schema.sql](database/schema.sql) is a design baseline that mirrors `V1__baseline.sql` plus the columns
added by later migrations, so it describes the current schema rather than the original baseline. The migrations are
authoritative.

| Version | Purpose |
| --- | --- |
| V1 | Baseline schema |
| V2 | Seed roles and development accounts |
| V3–V6 | Development password and staff-account corrections |
| V7 | Seed requested inventory |
| V8 | Link services to the products they consume |
| V9 | Add `consultations.follow_up_date` for scheduled recalls |
| V10 | Add `patients.skin_type` and `patients.allergies` for dermatology intake |
| V11 | Canonicalise role names and merge the duplicated Inventory Staff row |
| V12 | Store `patients.phone` in canonical E.164 and enforce it with a `CHECK` constraint |
| V13 | Widen that constraint from Philippine-only numbers to any country, still E.164 |
| V14 | Remove billing tables, `treatment_dockets.payment_status`, and the Cashier role; payment moves to the external POS |
| V15 | Add `therapists` personnel records; move appointment/docket therapist assignments onto them; remove the Therapist system role and accounts |
| V16 | Remove patient QR support: drop `secure_qr_references` and the patient QR resolve page/endpoints |
| V17 | Add `appointments.notes` and a `starts_at` index for the daily book; add `consultations.follow_up_time` and `follow_up_appointment_id`, so a follow-up is a real appointment on the receptionist's schedule |
| V18 | Stop collecting consultation clinical notes and free-text follow-up instructions: the columns remain for historical rows but become nullable |
| V19 | Allow a docket to sell a retail product: `treatment_dockets.service_id` becomes optional, `product_id` and `product_quantity` are added, and a check constraint requires exactly one item kind |
| V20 | Separate inventory by use: add `products.usage_type` (`RETAIL` or `CLINIC`); existing products linked to a service become clinic-use and every other product becomes retail-use |
| V21 | Add `users.id_number` (nullable, unique) for the staff badge or employee number collected by the Create User form; it is separate from `therapists.id_number` |
| V22 | Move docket contents into `treatment_docket_items`, backfill service prices from the catalogue, retain unknown historic retail prices as null, and remove the single-item columns and constraint |

## Recovering from a checksum mismatch

Flyway refuses to start when an applied migration file has been edited, reporting
`Migration checksum mismatch for migration version N`. This happens when a migration is changed after it has
already run against a database.

Do not edit an applied migration to work around this. Correct it with a new forward migration. If the change was
purely cosmetic and the database already reflects the intended state, re-register the checksum:

```bash
mvn -f backend/pom.xml flyway:repair \
  -Dflyway.url=jdbc:mysql://localhost:3306/derma_clinic \
  -Dflyway.user=root -Dflyway.password="$DB_PASSWORD"
```

`flyway:repair` only rewrites the `flyway_schema_history` checksums. It does not touch application data, but it does
hide a real drift, so confirm the database genuinely matches the migration before running it.

## Production migration order

1. Create the MySQL 8+ database with InnoDB.
2. Configure a least-privilege application user.
3. Run role and user migrations.
4. Run patients, suppliers, products, services, and inventory migrations.
5. Run appointments, consultations, and treatment-docket migrations.
6. Run the reporting and inventory migrations.
7. Run secure QR, refresh-token, and audit-log migrations.
8. Add indexes, foreign keys, unique constraints, and non-negative quantity checks.
9. Verify migration status before starting the application.

## Safety rules

- Back up the database before every production migration.
- Run migrations once through a controlled release job.
- Never use reset or destructive schema commands in production.
- Never remove clinical, inventory, or audit records through ordinary UI actions.
- Test migrations against a restored backup before release.
- Keep migration files immutable after they have run in a shared environment.

## Verification

Verify tables, foreign keys, indexes, unique constraints, status fields, timestamps, archive fields, decimal precision, quantity precision, and inventory non-negative checks. Run repository and integration tests after migration.

## Verification record

The schema was audited against the running development database, column by column.

| Check | Result |
| --- | --- |
| Tables | 20, identical in the migrations, `database/schema.sql` and the live database |
| Foreign keys | 30, all declared by `V1__baseline.sql` |
| Code against schema | Every table and column the application references exists. There is no `SELECT *` anywhere, so adding a column cannot break a result set |
| Destructive statements | No migration contains `DROP` or `TRUNCATE`. The only `DELETE` is `V11__canonicalise_role_names.sql`, which removes the duplicate `INVENTORY_STAFF` row and only once nothing references it, so a user can never be orphaned. `V5` deactivates accounts with `status = 'INACTIVE', deleted = TRUE` instead of removing them, and `V9`/`V10` only add nullable columns, so no existing row ever needed a backfill |
| Declared sources | `database/schema.sql` matches `V1__baseline.sql` plus `V9` and `V10` exactly, including `ENUM` label casing |

Two column types in the development database are looser than every declared source:

| Column | Development database | `V1__baseline.sql` and `database/schema.sql` |
| --- | --- | --- |
| `users.password_hash` | `VARCHAR(100)` | `VARCHAR(255)` |
| `session_refresh_tokens.token_hash` | `VARCHAR(255)` | `CHAR(64)` |

Both are left as they are. The stored values are always 60 characters (BCrypt) and 64 characters (SHA-256 hex), so
neither column can overflow at either width, and Hibernate's `validate` compares column types rather than lengths, so
startup is unaffected. Correcting them would mean altering a working table for no functional gain.

They exist because this development database predates Flyway: it was created from an earlier script, `baseline-on-migrate`
then stamped it as version 1, and V1 never ran against it. V2's `INSERT IGNORE` consequently skipped five of its six
role rows, because `roles.name` is unique under a case-insensitive collation and the pre-existing rows read
`Administrator` rather than `ADMINISTRATOR`. A database built from the migrations alone runs through `V21`, with
`V11` normalising every role name to the canonical title case and merging the duplicate `INVENTORY_STAFF` row, so both
environments converge on the same names. Role lookups match case-insensitively and JWT authorities normalise the name,
so both layouts behave identically.

`V14__remove_billing_and_cashier.sql` removes the billing tables (`invoices`, `payments`, `receipts`,
`sales_transactions`), drops `treatment_dockets.payment_status`, and deletes the Cashier role and its accounts.
Billing is handled by the clinic's external POS; the application keeps no second copy of those records. The earlier
migrations still create these objects so every database follows the same ordered history, and V14 is the point at
which they are taken back out.

Only five tables are mapped as JPA entities (`patients`, `users`, `roles`, `therapists`, `session_refresh_tokens`), so those are the
only ones `ddl-auto: validate` checks at startup. The other fifteen are reached through raw `JdbcTemplate`, where a
column mismatch surfaces at request time instead. Renaming a column in those tables therefore needs a matching code
change in the same release.

## Rollback

Prefer forward-fix migrations for production. If rollback is unavoidable, restore the pre-migration backup in an isolated environment, verify data, and follow the approved recovery procedure. Do not improvise destructive SQL against live clinical data.
