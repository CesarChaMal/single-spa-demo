@echo off
echo Setting up deployment for cesarchamal...
echo.

echo Your AWS Configuration:
echo S3_BUCKET=single-spa-demo-774145483743
echo AWS_REGION=eu-central-1
echo ORG_NAME=cesarchamal
echo.

echo Creating .env file...
echo S3_BUCKET=single-spa-demo-774145483743 > .env
echo AWS_REGION=eu-central-1 >> .env
echo ORG_NAME=cesarchamal >> .env
echo AWS_ACCESS_KEY_ID=your_access_key_here >> .env
echo AWS_SECRET_ACCESS_KEY=your_secret_key_here >> .env

echo.
echo ✅ Configuration created!
echo.
echo Next steps:
echo 1. Edit .env file and add your real AWS credentials
echo 2. Run: npm run deploy:setup (to configure interactively)
echo 3. Or run: ./setup-s3-bucket.bat (to create S3 bucket)
echo 4. Run: ./setup-github-actions.bat (to setup workflows)
echo.
pause