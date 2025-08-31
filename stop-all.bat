@echo off
echo Stopping Single-SPA Microfrontend Demo services...

echo Stopping services on ports 9000-9003...

REM Kill processes on each port
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :9000') do taskkill /f /pid %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :9001') do taskkill /f /pid %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :9002') do taskkill /f /pid %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :9003') do taskkill /f /pid %%a >nul 2>&1

REM Kill any remaining webpack processes
taskkill /f /im node.exe /fi "WINDOWTITLE eq webpack*" >nul 2>&1

echo All services stopped.
pause