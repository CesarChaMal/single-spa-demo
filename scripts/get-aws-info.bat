@echo off
echo Getting your AWS account information...
echo.

echo ========================================
echo AWS Account Information
echo ========================================

echo Getting AWS Account ID...
for /f "tokens=*" %%i in ('aws sts get-caller-identity --query "Account" --output text 2^>nul') do set AWS_ACCOUNT_ID=%%i
if "%AWS_ACCOUNT_ID%"=="" (
    echo ❌ Could not get AWS Account ID. Make sure AWS CLI is configured.
    echo Run: aws configure
    pause
    exit /b 1
)
echo AWS Account ID: %AWS_ACCOUNT_ID%

echo.
echo Getting AWS User/Role...
for /f "tokens=*" %%i in ('aws sts get-caller-identity --query "Arn" --output text 2^>nul') do set AWS_ARN=%%i
echo AWS ARN: %AWS_ARN%

echo.
echo Getting AWS Region...
for /f "tokens=*" %%i in ('aws configure get region 2^>nul') do set AWS_REGION=%%i
if "%AWS_REGION%"=="" set AWS_REGION=eu-central-1
echo AWS Region: %AWS_REGION%

echo.
echo ========================================
echo Recommended Configuration
echo ========================================
echo.
echo Based on your AWS account, here are the recommended values:
echo.
echo S3_BUCKET=single-spa-demo-%AWS_ACCOUNT_ID%
echo AWS_REGION=%AWS_REGION%
echo ORG_NAME=%USERNAME%
echo.
echo ========================================
echo What is ORG_NAME?
echo ========================================
echo.
echo ORG_NAME is just a namespace for your microfrontends.
echo It can be:
echo - Your GitHub username
echo - Your company name
echo - Your project name
echo - Any unique identifier
echo.
echo Examples:
echo - ORG_NAME=mycompany
echo - ORG_NAME=johnsmith
echo - ORG_NAME=myproject
echo.
echo This creates URLs like:
echo @mycompany/nav → https://bucket.s3.amazonaws.com/@mycompany/nav/commit/bundle.js
echo.
echo ========================================
echo Next Steps
echo ========================================
echo.
echo 1. Choose your ORG_NAME (suggestion: %USERNAME%)
echo 2. Run: npm run deploy:setup
echo 3. Use these values when prompted:
echo    - S3_BUCKET: single-spa-demo-%AWS_ACCOUNT_ID%
echo    - AWS_REGION: %AWS_REGION%
echo    - ORG_NAME: [your choice]
echo.
pause