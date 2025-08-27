@echo off
echo Starting Single-SPA Microfrontend Demo...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: npm is not installed or not in PATH
    pause
    exit /b 1
)

echo Installing dependencies for all microfrontends...
call npm run install:all
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Starting all microfrontends...
echo - Root Config will be available at: http://localhost:9000
echo - Navigation App will be available at: http://localhost:9001
echo - Page 1 App will be available at: http://localhost:9002
echo - Page 2 App will be available at: http://localhost:9003
echo.
echo Press Ctrl+C to stop all services
echo.

call npm run start:all