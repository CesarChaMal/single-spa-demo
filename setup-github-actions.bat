@echo off
echo Setting up GitHub Actions workflows...

REM Create .github/workflows directories for each microfrontend
mkdir "single-spa-demo-root-config\.github\workflows" 2>nul
mkdir "single-spa-demo-nav\.github\workflows" 2>nul
mkdir "single-spa-demo-page-1\.github\workflows" 2>nul
mkdir "single-spa-demo-page-2\.github\workflows" 2>nul

REM Copy GitHub Actions workflow files
copy "single-spa-demo-root-config\github-deploy.yml" "single-spa-demo-root-config\.github\workflows\deploy.yml"
copy "single-spa-demo-nav\github-deploy.yml" "single-spa-demo-nav\.github\workflows\deploy.yml"
copy "single-spa-demo-page-1\github-deploy.yml" "single-spa-demo-page-1\.github\workflows\deploy.yml"
copy "single-spa-demo-page-2\github-deploy.yml" "single-spa-demo-page-2\.github\workflows\deploy.yml"

echo ✅ GitHub Actions workflows set up successfully!
echo.
echo Next steps:
echo 1. Push each microfrontend to its own GitHub repository
echo 2. Add these secrets to each repository:
echo    - AWS_ACCESS_KEY_ID
echo    - AWS_SECRET_ACCESS_KEY
echo    - S3_BUCKET
echo    - AWS_REGION
echo    - ORG_NAME
echo 3. Push to main/master branch to trigger deployment

pause