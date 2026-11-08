@echo off
setlocal
REM Reset the DCMS development database to a clean testing state.
REM Double-click this file. It asks for your MySQL root password twice.

set "MYSQL=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
set "MYSQLDUMP=C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqldump.exe"
set "HERE=%~dp0"

if not exist "%MYSQL%" (
  echo Could not find mysql.exe at:
  echo   %MYSQL%
  echo Edit the MYSQL path at the top of this file to match your install.
  pause
  exit /b 1
)

echo ============================================================
echo  Step 1 of 2 - backing up the database
echo ============================================================
echo Writing to: %HERE%dcms_backup.sql
echo.
"%MYSQLDUMP%" -u root -p --databases derma_clinic > "%HERE%dcms_backup.sql"
if errorlevel 1 (
  echo.
  echo Backup FAILED. The database has NOT been changed.
  echo Check the password and that MySQL is running.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  Step 2 of 2 - wiping test data
echo ============================================================
echo This removes all patients, appointments, consultations,
echo dockets, movements, refresh tokens and
echo audit records.
echo Logins, roles, services, products and suppliers are KEPT.
echo.
"%MYSQL%" -u root -p < "%HERE%database\reset_test_data.sql"
if errorlevel 1 (
  echo.
  echo Reset FAILED. Read the message above.
  pause
  exit /b 1
)

echo.
echo ============================================================
echo  Done. The transactional tables should now be at zero.
echo  Reload the page in your browser (Ctrl+Shift+R).
echo  No backend restart is needed - it reads MySQL on every
echo  request, so a data change is picked up immediately.
echo ============================================================
pause
