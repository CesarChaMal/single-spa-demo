@echo off
echo Deploying Single-SPA Microfrontends to Production...
echo.

REM Use correct Node.js version with nvm
if exist .nvmrc (
    set /p NODE_VERSION=<.nvmrc
    echo Using Node.js version %NODE_VERSION% from .nvmrc...
    where nvm >nul 2>&1
    if %errorlevel% equ 0 (
        nvm use %NODE_VERSION%
        if %errorlevel% neq 0 (
            echo Installing Node.js version %NODE_VERSION%...
            nvm install %NODE_VERSION%
            nvm use %NODE_VERSION%
        )
    ) else (
        echo Warning: nvm not found, using system Node.js
    )
)

REM Check if AWS CLI is installed
where aws >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: AWS CLI is not installed
    echo Please install AWS CLI from https://aws.amazon.com/cli/
    pause
    exit /b 1
)

REM Load environment variables
if exist .env (
    echo Loading configuration from .env...
    for /f "tokens=1,2 delims==" %%a in (.env) do set %%a=%%b
) else (
    echo No .env file found. Run setup-deployment-cesarchamal.bat first
    pause
    exit /b 1
)

REM Check required environment variables
if "%S3_BUCKET%"=="" (
    echo Error: S3_BUCKET not set in .env file
    pause
    exit /b 1
)
if "%AWS_REGION%"=="" (
    echo Error: AWS_REGION not set in .env file
    pause
    exit /b 1
)
if "%ORG_NAME%"=="" (
    echo Error: ORG_NAME not set in .env file
    pause
    exit /b 1
)

echo Configuration:
echo S3_BUCKET=%S3_BUCKET%
echo AWS_REGION=%AWS_REGION%
echo ORG_NAME=%ORG_NAME%
echo.

REM Setup S3 bucket if needed
echo Setting up S3 bucket...
call setup-s3-bucket.bat

echo Building and deploying all microfrontends...
echo This will deploy each microfrontend using their after_deploy.sh scripts
echo.

REM Deploy each microfrontend
echo Deploying root config...
cd single-spa-demo-root-config
call npm run build
for /f %%i in ('git rev-parse HEAD 2^>nul') do set GITHUB_SHA=%%i
if "%GITHUB_SHA%"=="" set GITHUB_SHA=manual-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
bash after_deploy.sh
cd ..

echo Deploying navigation app...
cd single-spa-demo-nav
call npm run build
for /f %%i in ('git rev-parse HEAD 2^>nul') do set GITHUB_SHA=%%i
if "%GITHUB_SHA%"=="" set GITHUB_SHA=manual-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
bash after_deploy.sh
cd ..

echo Deploying page 1 app...
cd single-spa-demo-page-1
call npm run build
for /f %%i in ('git rev-parse HEAD 2^>nul') do set GITHUB_SHA=%%i
if "%GITHUB_SHA%"=="" set GITHUB_SHA=manual-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
bash after_deploy.sh
cd ..

echo Deploying page 2 app...
cd single-spa-demo-page-2
call npm run build
for /f %%i in ('git rev-parse HEAD 2^>nul') do set GITHUB_SHA=%%i
if "%GITHUB_SHA%"=="" set GITHUB_SHA=manual-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
bash after_deploy.sh
cd ..

echo.
echo Deployment completed successfully!
echo Check your S3 bucket for the deployed assets.
pause