# Derma Clinic Management System

**Website structure, role access, and system architecture**

Companion diagrams for the thesis document. Every label, panel and permission shown here is taken from the running system.

---

## Figure 1 — Website navigation map

The login screen is the only entry point. A successful sign-in returns a JSON Web Token carrying the user's role, and that role determines which of the twelve sidebar entries the shell renders.

```
DERMA CLINIC MANAGEMENT SYSTEM
│
├── LOGIN SCREEN
│     Work email + Password ──► POST /api/auth/login ──► JWT ──► role
│
└── MAIN SHELL ── sidebar + topbar + workspace area
    │
    ├── WORKSPACE ──────────────────────────────────────────────────────
    │   │
    │   ├── Overview
    │   │     4 metric cards · Today's schedule · Recent activity
    │   │     Inventory watch
    │   │
    │   ├── Patients
    │   │     search · Patient directory + pagination
    │   │     shows only full name and patient number
    │   │     dialogs → Register/Edit · Profile · Clinical history
    │   │
    │   ├── Appointments
    │   │     search · status filter · New appointment
    │   │     Appointment table
    │   │     dialogs → New/Edit · Appointment detail
    │   │
    │   ├── EMR & consultations
    │   │     New consultation · Consultation history
    │   │     dialog → New consultation
    │   │
    │   └── Treatment dockets
    │         search · status filter · New docket
    │         Docket table
    │         dialogs → New docket · Preview / Print / POS QR (opens on create)
    │
    ├── OPERATIONS ─────────────────────────────────────────────────────
    │   │
    │   ├── Inventory
    │   │     search · stock filter · All / Clinic-use / Retail-use tabs
    │   │     Suppliers · New product · Stock movement
    │   │     4 summary cards: Products · Low-stock · Expiring · Today's movements
    │   │     Inventory records · Stock alerts · Movement history (shelf-labelled)
    │   │     dialogs → New product · Suppliers · Stock movement (grouped picker) · Product history
    │   │
    │   ├── Sales
    │   │     Date From / Date To · Clear dates
    │   │     Services sold · Quantity sold
    │   │     Sales transactions: Service · Quantity
    │   │
    │   ├── Reports
    │   │     date filter · PDF · Excel
    │   │     2 report cards: Inventory (with per-shelf totals) · Movement
    │   │     Low-stock report · Expiry report (both shelf-labelled)
    │   │
    │   └── Services
    │         New service · status filter · Services table
    │         dialog → Code · Name · Price · Duration · Required products
    │         product row → Product name · Required quantity (default 1) · Measurement unit
    │
    └── ADMINISTRATION ─────────────────────────────────────────────────
        │
        ├── Team & access
        │     New user · New therapist · role filter · Clinic users · Therapists
        │     Activity monitoring · Role permission matrix
        │     user dialog → Name · Email · ID number · Password · Confirm password · Role
        │     therapist dialog → Name · Email · Phone · Age · ID number (no sign-in)
        │
        └── Audit trail
              module filter · System audit events
```

*Figure 1. Navigation map of the Derma Clinic Management System. Three sidebar groups hold ten workspaces.*

---

## Figure 2 — Role access map

Four system roles are defined. Each role receives only the sidebar entries listed for it; every other workspace is hidden, and the corresponding interface elements are not rendered. Therapists are personnel records, not roles, and never sign in.

```
WORKSPACE                    │ Admin │ Recep │ Derm │ Inventory
─────────────────────────────┼───────┼───────┼──────┼──────────
Overview                     │   ●   │   ●   │  ●   │    ●
Patients                     │   ●   │   ●   │  ●   │    –
Appointments                 │   ●   │   ●   │  ●   │    –
EMR & consultations          │   ●   │   –   │  ●   │    –
Treatment dockets            │   ●   │   ●   │  ●   │    –
─────────────────────────────┼───────┼───────┼──────┼──────────
Inventory                    │   ●   │   –   │  –   │    ●
Sales                        │   ●   │   –   │  –   │    –
Reports                      │   ●   │   –   │  –   │    ●
Services                     │   ●   │   –   │  –   │    –
─────────────────────────────┼───────┼───────┼──────┼──────────
Team & access                │   ●   │   –   │  –   │    –
Audit trail                  │   ●   │   –   │  –   │    –
─────────────────────────────┼───────┼───────┼──────┼──────────
TOTAL WORKSPACES             │  11   │   4   │  5   │    3
```

*Figure 2. Workspace access by role. ● visible — – hidden.*

> **Point to raise if asked.** A role can be permitted to *read* a dataset without having a workspace for it. Receptionist may read the inventory endpoint, because the treatment docket form shows a live stock check, even though that role has no Inventory workspace. Interface visibility and endpoint authorization are therefore two separate layers, and both are enforced.

---

## Figure 3 — Three-tier system architecture

```
┌───────────────────────────────────────────────────────────────┐
│  TIER 1 — BROWSER CLIENT                                      │
│  index.html · app.js · styles.css · qrcode.min.js             │
│  Vanilla-JS single-page application                           │
│  No build step, no npm, no front-end framework                │
│  Session in sessionStorage (dermaClinicSession), scoped per tab│
└──────────────────────────┬────────────────────────────────────┘
                           │  JSON over HTTP
                           │  Authorization: Bearer <JWT>
                           │  CORS origin allow-list
                           ▼
┌───────────────────────────────────────────────────────────────┐
│  TIER 2 — APPLICATION SERVER                                  │
│  Spring Boot 3.4.4 · Java 21 · port 8080                      │
│                                                               │
│  SecurityFilterChain → JwtAuthenticationFilter → @PreAuthorize│
│                                                               │
│  Controllers   Auth · Patient · User · ClinicData ·           │
│                ClinicCommand                                  │
│  Policies      InventoryPolicy                                 │
│  Data access   JPA repositories  → Patient, User, Therapist    │
│                JdbcTemplate      → all clinical data          │
└──────────────────────────┬────────────────────────────────────┘
                           │  JDBC (HikariCP connection pool)
                           ▼
┌───────────────────────────────────────────────────────────────┐
│  TIER 3 — DATABASE                                            │
│  MySQL 8.4 · schema derma_clinic                              │
│  16 tables · Flyway migrations V1–V21                         │
│  ddl-auto: validate (schema is owned by migrations)           │
└───────────────────────────────────────────────────────────────┘
```

*Figure 3. Three-tier architecture of the Derma Clinic Management System.*

---

## Notes on the interface

### Dialog boxes

The system uses **17 dialog boxes**. One shared element serves both patient registration and patient editing, which is why the "New patient" and "Register patient" actions open the same form. The remaining sixteen are specific to a single feature: appointment detail, appointment form, consultation, docket detail, docket POS QR, docket form, inventory history, stock movement, patient profile, product, service, supplier, therapist, user, archived products, and confirm.

### Removed workspace sections

Earlier revisions defined two workspace sections — `Security & privacy` and `Validation & recovery` — that no role could reach. They were removed at the client's request, together with their navigation entries and renderers, so the sidebar now offers ten workspaces.

### Authentication and authorization

Authorization is enforced twice, independently. The interface hides actions a role may not perform, so the user is never offered a button that will fail. The application server separately rejects the request at the endpoint with a role check, so the rule holds even if the interface is bypassed.

---

*Prepared as a companion to the thesis document. All labels, panels, roles and permissions shown are taken from the running system.*
