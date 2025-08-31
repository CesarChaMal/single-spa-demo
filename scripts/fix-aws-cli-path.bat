@echo off
echo Checking AWS CLI installation and PATH...
echo.

echo ========================================
echo AWS CLI Location Check
echo ========================================

REM Check common AWS CLI installation paths
set AWS_PATHS[0]="C:\Program Files\Amazon\AWSCLIV2\aws.exe"
set AWS_PATHS[1]="C:\Program Files (x86)\Amazon\AWSCLIV2\aws.exe"
set AWS_PATHS[2]="C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python*\Scripts\aws.exe"
set AWS_PATHS[3]="C:\Python*\Scripts\aws.exe"

echo Searching for AWS CLI...
for /f "tokens=*" %%i in ('where aws 2^>nul') do (
    echo ✅ Found AWS CLI at: %%i
    set AWS_CLI_PATH=%%i
    goto :found
)

echo ❌ AWS CLI not found in PATH
echo.
echo Checking common installation locations...

if exist "C:\Program Files\Amazon\AWSCLIV2\aws.exe" (
    echo ✅ Found AWS CLI at: C:\Program Files\Amazon\AWSCLIV2\aws.exe
    set AWS_CLI_PATH=C:\Program Files\Amazon\AWSCLIV2
    goto :add_to_path
)

if exist "C:\Program Files (x86)\Amazon\AWSCLIV2\aws.exe" (
    echo ✅ Found AWS CLI at: C:\Program Files (x86)\Amazon\AWSCLIV2\aws.exe
    set AWS_CLI_PATH=C:\Program Files (x86)\Amazon\AWSCLIV2
    goto :add_to_path
)

echo ❌ AWS CLI not found. Please install it from:
echo https://aws.amazon.com/cli/
pause
exit /b 1

:add_to_path
echo.
echo ========================================
echo Adding AWS CLI to PATH
echo ========================================
echo.
echo AWS CLI found but not in PATH.
echo Adding to current session...
set PATH=%PATH%;%AWS_CLI_PATH%
echo ✅ AWS CLI added to PATH for this session
goto :found

:found
echo.
echo ========================================
echo Testing AWS CLI
echo ========================================
aws --version
if %errorlevel% neq 0 (
    echo ❌ AWS CLI test failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo IntelliJ Terminal Fix
echo ========================================
echo.
echo To fix IntelliJ terminal permanently:
echo.
echo 1. Open IntelliJ IDEA
echo 2. Go to File → Settings → Tools → Terminal
echo 3. In "Environment variables" add:
echo    PATH=%PATH%;%AWS_CLI_PATH%
echo.
echo OR
echo.
echo 4. In "Shell path" use:
echo    cmd.exe /k "set PATH=%PATH%;%AWS_CLI_PATH%"
echo.
echo ========================================
echo Getting AWS Information
echo ========================================
echo.

aws sts get-caller-identity --query "Account" --output text > temp_account.txt 2>nul
if %errorlevel% equ 0 (
    set /p AWS_ACCOUNT_ID=<temp_account.txt
    echo AWS Account ID: %AWS_ACCOUNT_ID%
    
    aws configure get region > temp_region.txt 2>nul
    set /p AWS_REGION=<temp_region.txt
    if "%AWS_REGION%"=="" set AWS_REGION=eu-central-1
    echo AWS Region: %AWS_REGION%
    
    echo.
    echo Recommended configuration:
    echo S3_BUCKET=single-spa-demo-%AWS_ACCOUNT_ID%
    echo AWS_REGION=%AWS_REGION%
    echo ORG_NAME=%USERNAME%
    
    del temp_account.txt temp_region.txt 2>nul
) else (
    echo ❌ AWS CLI not configured. Run: aws configure
)

echo.
pause