# Derma Clinic Management System
## Teacher Presentation and User Guide

## 1. Project Introduction

This project is a Derma Clinic Management System. It is designed to support clinic operations such as:

- Patient management
- Appointments
- Consultations
- Treatment dockets
- Inventory
- Sales Management
- Reports
- Staff accounts
- Role permissions
- Security and privacy controls

The project is currently a functional local academic prototype. It includes a browser frontend, Spring Boot backend, MySQL database, authentication, and role-based access. It is not yet a production healthcare system.

## 2. How the System Works

The system has three main parts:

1. Frontend
2. Backend
3. Database

The frontend is the part the user sees in the browser. It contains the login screen, dashboard, forms, tables, charts, navigation, and reports.

The backend processes requests, validates data, checks permissions, authenticates users, and communicates with MySQL.

The database permanently stores users, roles, patients, appointments, inventory, treatment dockets, and other clinical records. Payment is handled by the clinic's external POS and is not stored here.

The normal process is:

1. The user opens the website.
2. The user enters login details.
3. The frontend sends the login request to the backend.
4. The backend checks the credentials in MySQL.
5. The backend returns authentication tokens.
6. The user receives access to permitted functions.
7. Data is loaded from or saved through the backend.

## 3. Technology Used

### Frontend

- HTML for page structure
- CSS for layout and visual design
- JavaScript for interaction and API requests
- Single-page front end served locally on port 5500

Important frontend files:

- `index.html`
- `styles.css`
- `app.js`

### Backend

- Java 21
- Spring Boot
- Spring Security
- Spring Data JPA
- REST API endpoints
- JWT authentication
- BCrypt password hashing
- Maven for building and running the project

The backend runs on port 8080.

### Database

- MySQL 8
- Database name: `derma_clinic`
- InnoDB tables
- Foreign keys
- Unique constraints
- Indexes
- Validation checks
- Flyway migrations

## 4. What Is the Frontend?

The frontend is the visual part of the application. It is what clinic staff use in the browser.

It includes:

- Login screen
- Dashboard
- Sidebar navigation
- Patient pages
- Appointment pages
- Consultation pages
- Inventory pages
- Sales Management pages
- Treatment docket pages
- Reports pages
- Validation and error messages

The frontend address is:

`http://localhost:5500`

## 5. What Is the Backend?

The backend is the server-side part of the application.

It is responsible for:

- Authentication
- Password checking
- Token creation
- Permission checking
- Input validation
- Database communication
- Business rules
- Safe error responses

The backend address is:

`http://localhost:8080`

The browser should communicate with the backend API. It should not connect directly to MySQL.

## 6. What Is Java?

Java is the programming language used for the backend.

It is used to create the controllers, services, security logic, database entities, validation, and business rules.

This project uses Java 21.

## 7. What Is Maven?

Maven is a Java project and dependency management tool.

Maven is used to:

- Download Java libraries
- Compile the backend
- Run tests
- Package the application
- Start the Spring Boot server

The Maven project configuration is stored in `backend/pom.xml`.

## 8. What Is the Database?

The database is MySQL. The database name is `derma_clinic`.

It stores:

- Users
- Roles
- Patients
- Appointments
- Services
- Products
- Suppliers
- Inventory batches
- Inventory balances
- Treatment dockets
- Audit information

The database uses relationships. For example:

- A user belongs to a role.
- An appointment belongs to a patient.
- A treatment docket belongs to a patient and a service.
- An inventory balance belongs to a product.

## 9. How to Start MySQL

### Windows Services

1. Press the Windows key.
2. Search for `Services`.
3. Open the Services application.
4. Find `MySQL80`.
5. Confirm that its status is `Running`.
6. If it is stopped, right-click it and select `Start`.
7. Its startup type can be set to `Automatic` so it starts with Windows.

### Task Manager

1. Press `Ctrl + Shift + Esc`.
2. Open the Services tab.
3. Find `MySQL80`.
4. Confirm that the status is `Running`.
5. If it is stopped, right-click it and choose `Start`.

### MySQL Workbench

1. Open MySQL Workbench.
2. Select the local MySQL connection.
3. Enter the local MySQL password.
4. Connect successfully.
5. Open the Schemas panel.
6. Find the `derma_clinic` database.
7. Expand the database and its Tables section.

## 10. How to Start the Backend

1. Confirm that `MySQL80` is running.
2. Open PowerShell.
3. Go to the project folder:

`C:\Users\knigh\OneDrive\Desktop\upgraded`

4. Set the database password for the current PowerShell session.
5. Start the Spring Boot application with Maven.
6. Keep this terminal open.
7. Wait until the log says that Tomcat started on port 8080.
8. The backend must remain running while using the website.

The backend requires:

- MySQL running
- Java 21 installed
- Maven available
- Correct database password
- Database named `derma_clinic`
- Port 8080 available

## 11. How to Start the Website

1. Open a second PowerShell window.
2. Go to the project folder.
3. Start the Python web server on port 5500.
4. Keep this terminal open.
5. Open `http://localhost:5500` in Chrome or Edge.
6. Refresh the browser if the page was already open.

Both the backend terminal and frontend terminal must remain open.

## 12. How to Check the Environment

### MySQL80

Check Windows Services, Task Manager, or MySQL Workbench. It must be running.

### Java 21

Open PowerShell and check the Java version. It should report version 21.

### Maven

Open PowerShell and check the Maven version. It should show Maven and the Java version being used.

### Python

Open PowerShell and check the Python version. It should show Python 3.

### Port 5500

The frontend uses port 5500. The website should open at `http://localhost:5500`.

If another application already uses port 5500, the frontend server will not start on that port.

### Port 8080

The backend uses port 8080. Spring Boot should report that Tomcat started on port 8080.

If another application already uses port 8080, stop it or configure the backend to use another port.

### Database Exists

In MySQL Workbench:

1. Connect to MySQL.
2. Open the Schemas panel.
3. Find `derma_clinic`.
4. Expand it.
5. Confirm that its tables are visible.

### Database Password Is Correct

The backend log should show that:

- A database connection was created.
- Flyway validated the migrations.
- The database schema is up to date.
- Tomcat started on port 8080.

An `Access denied` error means the database username or password is incorrect.

## 13. Development Login Accounts

| Role | Email | Password |
|---|---|---|
| Administrator | admin@dermaclinic.test | AdminCare2026! |
| Receptionist | reception@dermaclinic.test | Reception2026! |
| Dermatologist | dermatologist@dermaclinic.test | DermCare2026! |
| Inventory Staff | inventory@dermaclinic.test | InventoryCare2026! |

These are fictional development accounts. They must not be used in a production system. Therapists are personnel records, not sign-in accounts.

## 14. How to Test the Four Roles

For each account:

1. Open the website.
2. Enter the email address.
3. Enter the password.
4. Select the matching role.
5. Sign in.
6. Confirm that the dashboard opens.
7. Check that the navigation matches the role.
8. Sign out.
9. Test the next role.

Expected roles:

- Administrator: users, access, administration, and system oversight
- Receptionist: patients and appointments
- Dermatologist: consultations and clinical review
- Inventory Staff: products and stock management

## 15. Database Queries for MySQL Workbench

Run these queries in MySQL Workbench to inspect the database.

### Roles

`SELECT * FROM roles;`

### Users without displaying password hashes

`SELECT id, full_name, email, status FROM users;`

### Patients

`SELECT * FROM patients;`

### Appointments

`SELECT * FROM appointments;`

### Dermatologists

`SELECT u.id, u.full_name, u.email, u.status, r.name AS role FROM users u JOIN roles r ON r.id = u.role_id WHERE r.name = 'DERMATOLOGIST';`

### Therapists

`SELECT * FROM therapists;`

Therapists are personnel records, not users. They have no password or role and cannot sign in; Administrators create them in Team & access so they can be assigned to appointments and treatment dockets.

### Receptionists

`SELECT u.id, u.full_name, u.email, u.status, r.name AS role FROM users u JOIN roles r ON r.id = u.role_id WHERE r.name = 'RECEPTIONIST';`

### Inventory staff

`SELECT u.id, u.full_name, u.email, u.status, r.name AS role FROM users u JOIN roles r ON r.id = u.role_id WHERE r.name = 'INVENTORY_STAFF';`

### Products

`SELECT * FROM products;`

### Inventory balances

`SELECT * FROM inventory_balances;`

### Services

`SELECT * FROM services;`

### Treatment dockets

`SELECT * FROM treatment_dockets;`

### Flyway migration history

`SELECT * FROM flyway_schema_history;`

Do not display the password hash column during a normal presentation. Explain that it contains one-way encrypted-style BCrypt hashes rather than readable passwords.

## 16. What Is BCrypt?

BCrypt is used to protect passwords.

The real password is not stored in the database. The database stores a one-way BCrypt hash.

During login, the backend compares the entered password with the stored hash. The original password cannot be read from the hash.

## 17. What Is JWT?

JWT means JSON Web Token.

After successful login, the backend sends a short-lived access token to the frontend.

The frontend sends the token when requesting protected backend functions. The backend checks the token before allowing access.

## 18. What Are Refresh Tokens?

A refresh token allows the application to request a new access token after the short-lived access token expires.

Refresh tokens should expire, rotate when used, and be invalidated when the user logs out or is deactivated.

## 19. What Is CORS?

CORS controls which websites are allowed to communicate with the backend.

During local development, the backend allows the frontend at `http://localhost:5500`.

In production, CORS should allow only the approved real frontend domain.

## 20. What Are Role Permissions?

Role permissions control what each staff member can do.

For example:

- Administrator manages users and system settings.
- Receptionist manages patients and appointments.
- Dermatologist manages consultations.
- Inventory Staff manages products and stock.
- Therapist personnel are assigned to appointments and dockets but have no system login.

Permissions must be checked by the backend, not only hidden in the frontend.

## 21. What Is Flyway?

Flyway manages database migrations.

When the backend starts:

1. Flyway connects to MySQL.
2. It checks which migrations already ran.
3. It applies new migrations.
4. It records the migration history.
5. It confirms that the database structure is correct.

Flyway is used for the project database structure, roles, development users, and password corrections.

## 22. What Does Database-Backed Mean?

A database-backed feature saves information permanently in MySQL through the backend.

The normal process is:

1. The user enters information in the frontend.
2. The frontend sends it to the backend.
3. The backend validates it.
4. The backend checks permission.
5. The backend saves it in MySQL.
6. The backend returns the saved record.
7. The frontend displays the result.

To test a feature:

1. Create or update a test record.
2. Refresh the browser.
3. Log out and log in again.
4. Open MySQL Workbench.
5. Check the matching table.

If the record disappears after refresh or does not appear in MySQL Workbench, that feature is likely still using demonstration or in-memory data instead of a complete backend API.

## 23. Why Some Screens Are Not Fully Connected

Some screens are currently browser demonstrations. They can display fictional or in-memory data without permanently saving every action to MySQL.

This means a screen may look complete while its create, update, archive, restore, or report actions are not all connected to backend endpoints.

The remaining development work is to connect every workflow to backend APIs so records are validated, authorized, saved, and loaded from MySQL.

## 24. Security and Privacy Controls

The system's security controls are enforced by the backend rather than displayed on a separate page:

- BCrypt password hashing
- JWT authentication
- Protected endpoints
- Request validation
- Parameterized persistence
- Secure CORS
- Safe error handling
- Environment secrets
- Token expiration and invalidation
- Audit logging

Login throttling and AES-256 encryption are requirements that are not implemented.

Do not claim that every security control is production-ready unless it has been tested through the backend.

## 25. Why PDF and Excel Reports May Not Work

The report screen may show charts and report information, but PDF and Excel export may not work because:

- The export buttons may still be placeholders.
- Report APIs may not be fully implemented.
- A PDF generation library may not be connected.
- An Excel generation library may not be connected.
- Report data may still be demonstration data.
- The export action may not create a real downloadable file.

A chart displayed on the screen does not automatically create a PDF or Excel file.

A complete export workflow should:

1. Accept a date range.
2. Request report data from the backend.
3. Check the user permission.
4. Load data from MySQL.
5. Calculate totals.
6. Generate a PDF or Excel file.
7. Send the file to the browser.
8. Download the file.

For the presentation, say:

`The report dashboard and visual summaries are available in the prototype. PDF and Excel export require the report-generation service to be fully connected to the backend.`

Only demonstrate PDF or Excel export if a real file downloads and contains correct data.

## 26. Completion Assessment

| Area | Current realistic target |
|---|---:|
| User interface and visual demo | 85% |
| Database design | 80% |
| Authentication and role security | 70% |
| Backend domain APIs | 35% |
| Database-backed clinic workflows | 35% |
| Production readiness | 30% |
| Academic presentation readiness | 80% |

The overall current project completion is approximately 70–75%.

After the main clinic workflows are connected to backend APIs, the project may reach approximately 80–85%.

After security hardening, full testing, report exports, backups, and deployment preparation, it may reach approximately 90%.

A 95% rating should only be claimed when nearly all important workflows are database-backed, tested, and working through the backend.

## 27. Work Needed to Reach 90%

### User Interface

- Finish every button and form.
- Remove placeholders.
- Add loading, success, and error messages.
- Test desktop and mobile layouts.
- Test role-specific navigation.

### Database

- Test all relationships.
- Add realistic fictional development data.
- Verify indexes and constraints.
- Use a limited database user instead of root.
- Confirm all Flyway migrations.

### Security

- Add login rate limiting.
- Track failed logins.
- Add password changes and resets.
- Test permission denial for every protected endpoint.
- Add complete audit events.
- Replace development secrets before deployment.

### Backend APIs

Complete and test APIs for:

- Patients
- Appointments
- Consultations
- Treatment dockets
- Services
- Products
- Suppliers
- Inventory movements
- Service sales
- Reports
- Users
- Audit logs

### Production

- Use HTTPS.
- Use a least-privilege database user.
- Store secrets outside source files.
- Restrict CORS.
- Add backups and restoration tests.
- Add monitoring and health checks.
- Remove demo credentials from production.
- Never use real patient data for testing.

## 28. Presentation Demonstration Order

1. Explain the project purpose.
2. Open the website.
3. Show the login screen.
4. Log in as Administrator.
5. Show the dashboard.
6. Open Patients.
7. Open Appointments.
8. Open Inventory.
9. Open Sales Management and show the Date From / Date To filters and the Service / Quantity table.
10. Open Treatment dockets and show the POS QR.
11. Explain BCrypt, JWT, refresh tokens, CORS, and role permissions.
12. Log out.
13. Log in as another role.
14. Show that the navigation changes.
15. Open MySQL Workbench.
16. Show the `derma_clinic` schema.
17. Show the `roles` and `users` tables.
18. Run the patient and staff queries.
19. Show the Flyway migration history.
20. Explain the current limitations and future work.

## 29. Honest Final Statement

This is a functional academic prototype for clinic operations. It contains a browser frontend, Spring Boot backend, MySQL database, Flyway migrations, BCrypt password hashing, JWT authentication, refresh tokens, CORS configuration, and role-based access control.

The remaining work is production hardening, report export integration, and connecting every clinic workflow completely to backend APIs and permanent database storage.

## 30. Short Presentation Version

My project is a Derma Clinic Management System built with HTML, CSS, JavaScript, Java, Spring Boot, Maven, Spring Security, and MySQL.

The frontend provides the clinic user interface. The backend manages authentication, validation, permissions, business rules, and database communication. MySQL stores users, roles, patients, appointments, inventory, and treatment records. Billing is handled by the clinic's external POS, and a docket QR hands the treatment details to it.

The application uses BCrypt to protect passwords, JWT for short-lived authentication tokens, refresh tokens for renewing sessions, CORS to control frontend access, and role permissions to restrict staff functions.

Flyway manages database migrations and keeps the database structure versioned.

The system is currently a working local academic prototype. The main remaining work is connecting every clinic screen fully to backend APIs, completing PDF and Excel report exports, adding production security hardening, and preparing deployment safeguards.
