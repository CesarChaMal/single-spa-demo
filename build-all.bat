@echo off
echo Building Single-SPA Microfrontend Demo for Production...
echo.

REM Use correct Node.js version with nvm
if exist .nvmrc (
    echo Using Node.js version from .nvmrc...
    nvm use >nul 2>&1
    if %errorlevel% neq 0 (
        echo Installing Node.js version from .nvmrc...
        for /f %%i in (.nvmrc) do nvm install %%i && nvm use %%i
    )
)

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/ or use nvm
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
echo Running tests for all microfrontends...
call npm run test:all
if %errorlevel% neq 0 (
    echo Warning: Some tests failed
)

echo.
echo Linting all microfrontends...
call npm run lint:all
if %errorlevel% neq 0 (
    echo Warning: Linting issues found
)

echo.
echo Building all microfrontends for production...
call npm run build:all
if %errorlevel% neq 0 (
    echo Error: Build failed
    pause
    exit /b 1
)

echo.
echo Build completed successfully!
echo Production bundles are available in each microfrontend's dist/ directory
pause