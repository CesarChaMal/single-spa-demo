@echo off
setlocal enabledelayedexpansion

REM Load environment variables from .env file
if exist .env (
    for /f "tokens=1,2 delims==" %%a in (.env) do (
        set %%a=%%b
    )
)

if "%S3_BUCKET%"=="" set S3_BUCKET=my-single-spa-demo
if "%AWS_REGION%"=="" set AWS_REGION=eu-central-1

echo Setting up S3 bucket: %S3_BUCKET% in region: %AWS_REGION%

REM Check if bucket exists
aws s3 ls "s3://%S3_BUCKET%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Creating S3 bucket...
    
    REM Create bucket
    if "%AWS_REGION%"=="eu-central-1" (
        aws s3 mb "s3://%S3_BUCKET%"
    ) else (
        aws s3 mb "s3://%S3_BUCKET%" --region "%AWS_REGION%"
    )
    
    REM Enable static website hosting
    aws s3 website "s3://%S3_BUCKET%" --index-document index.html --error-document error.html
    
    REM Set bucket policy for public read access
    echo { > bucket-policy.json
    echo     "Version": "2012-10-17", >> bucket-policy.json
    echo     "Statement": [ >> bucket-policy.json
    echo         { >> bucket-policy.json
    echo             "Sid": "PublicReadGetObject", >> bucket-policy.json
    echo             "Effect": "Allow", >> bucket-policy.json
    echo             "Principal": "*", >> bucket-policy.json
    echo             "Action": "s3:GetObject", >> bucket-policy.json
    echo             "Resource": "arn:aws:s3:::%S3_BUCKET%/*" >> bucket-policy.json
    echo         } >> bucket-policy.json
    echo     ] >> bucket-policy.json
    echo } >> bucket-policy.json
    
    aws s3api put-bucket-policy --bucket "%S3_BUCKET%" --policy file://bucket-policy.json
    del bucket-policy.json
    
    REM Enable CORS
    echo { > cors-config.json
    echo     "CORSRules": [ >> cors-config.json
    echo         { >> cors-config.json
    echo             "AllowedHeaders": ["*"], >> cors-config.json
    echo             "AllowedMethods": ["GET", "HEAD"], >> cors-config.json
    echo             "AllowedOrigins": ["*"], >> cors-config.json
    echo             "ExposeHeaders": [] >> cors-config.json
    echo         } >> cors-config.json
    echo     ] >> cors-config.json
    echo } >> cors-config.json
    
    aws s3api put-bucket-cors --bucket "%S3_BUCKET%" --cors-configuration file://cors-config.json
    del cors-config.json
    
    echo ✅ S3 bucket %S3_BUCKET% created and configured successfully!
    echo 🌐 Website URL: http://%S3_BUCKET%.s3-website-%AWS_REGION%.amazonaws.com
) else (
    echo ✅ S3 bucket %S3_BUCKET% already exists
)

pause