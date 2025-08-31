@echo off
setlocal enabledelayedexpansion

REM Load environment variables
if exist .env (
    for /f "tokens=1,2 delims==" %%a in (.env) do (
        set "%%a=%%b"
    )
)

if "%S3_BUCKET%"=="" set "S3_BUCKET=single-spa-demo-774145483743"
if "%ORG_NAME%"=="" set "ORG_NAME=cesarchamal"

echo WARNING: This will delete all microfrontend deployments from S3 bucket: %S3_BUCKET%
echo This will remove all versions of all microfrontends!
echo.
set /p confirm="Are you sure? (type 'yes' to confirm): "

if not "%confirm%"=="yes" (
    echo Operation cancelled
    pause
    exit /b 0
)

echo Deleting all microfrontend deployments...
aws s3 rm "s3://%S3_BUCKET%/@%ORG_NAME%/" --recursive
aws s3 rm "s3://%S3_BUCKET%/@%ORG_NAME%/importmap.json"

echo All microfrontend deployments deleted from %S3_BUCKET%!
pause