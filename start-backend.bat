@echo off
REM ---------------------------------------------------------------------------
REM Start the Derma Clinic backend.
REM
REM Why this exists: `mvn spring-boot:run` holds port 8080 in the foreground and
REM does not clean up if the run is interrupted (Ctrl+C in some terminals, or a
REM killed maven process). The orphaned Java process keeps the port, and the next
REM start dies with "Port 8080 was already in use" -- which looks like a broken
REM build but is only a leftover process.
REM
REM This script clears such an orphan first. It only ever kills a java.exe whose
REM command line contains DcmsApplication, so an unrelated program that happens
REM to own 8080 is left alone and the script aborts instead.
REM
REM The `dev` profile needs no flag here: backend/pom.xml defaults the
REM spring-boot:run goal to it.
REM ---------------------------------------------------------------------------
setlocal
set "PORT=8080"
set "ROOT=%~dp0"

echo Checking port %PORT% for a stale backend...

powershell -NoProfile -ExecutionPolicy Bypass -Command "$c = Get-NetTCPConnection -LocalPort %PORT% -State Listen -ErrorAction SilentlyContinue; if ($c) { $p = Get-CimInstance Win32_Process -Filter ('ProcessId=' + $c[0].OwningProcess) -ErrorAction SilentlyContinue; if ($p -and $p.Name -eq 'java.exe' -and $p.CommandLine -like '*DcmsApplication*') { Write-Host ('  Stopping stale backend, PID ' + $p.ProcessId + '.'); Stop-Process -Id $p.ProcessId -Force; Start-Sleep -Seconds 2 } else { $n = if ($p) { $p.Name } else { 'unknown' }; Write-Host ('  Port %PORT% is held by ' + $n + ', which is not this backend. Not touching it.'); exit 1 } } else { Write-Host '  Port %PORT% is free.' }"

if errorlevel 1 (
  echo.
  echo Aborting: port %PORT% is owned by another program.
  echo Stop it yourself, or start on a different port with: mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8081
  echo.
  pause
  exit /b 1
)

echo Starting backend from "%ROOT%backend"...
echo Open http://localhost:8080 once it reports "Started DcmsApplication".
echo Press Ctrl+C in this window to stop it.
echo.

pushd "%ROOT%backend"
call mvn spring-boot:run
set "RC=%ERRORLEVEL%"
popd

if not "%RC%"=="0" (
  echo.
  echo Backend exited with code %RC%. Scroll up for the reason.
  pause
)
endlocal
exit /b %RC%
