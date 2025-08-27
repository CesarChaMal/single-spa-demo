@echo off
echo Deploying Single-SPA Microfrontends to Production...
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

REM Check if AWS CLI is installed
aws --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: AWS CLI is not installed
    echo Please install AWS CLI from https://aws.amazon.com/cli/
    pause
    exit /b 1
)

REM Check if .env file exists
if not exist .env (
    echo Setting up deployment configuration...
    call npm run deploy:setup
    if %errorlevel% neq 0 (
        echo Error: Failed to setup deployment
        pause
        exit /b 1
    )
)

echo Building and deploying all microfrontends...
call npm run deploy:all
if %errorlevel% neq 0 (
    echo Error: Deployment failed
    pause
    exit /b 1
)

echo.
echo Deployment completed successfully!
echo Check your S3 bucket for the deployed assets.
pause