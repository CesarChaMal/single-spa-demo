#!/bin/bash

echo "Setting up GitHub Actions workflows..."

# Create .github/workflows directories for each microfrontend
mkdir -p "single-spa-demo-root-config/.github/workflows"
mkdir -p "single-spa-demo-nav/.github/workflows"
mkdir -p "single-spa-demo-page-1/.github/workflows"
mkdir -p "single-spa-demo-page-2/.github/workflows"

# Copy GitHub Actions workflow files
cp "single-spa-demo-root-config/github-deploy.yml" "single-spa-demo-root-config/.github/workflows/deploy.yml"
cp "single-spa-demo-nav/github-deploy.yml" "single-spa-demo-nav/.github/workflows/deploy.yml"
cp "single-spa-demo-page-1/github-deploy.yml" "single-spa-demo-page-1/.github/workflows/deploy.yml"
cp "single-spa-demo-page-2/github-deploy.yml" "single-spa-demo-page-2/.github/workflows/deploy.yml"

echo "✅ GitHub Actions workflows set up successfully!"
echo
echo "Next steps:"
echo "1. Push each microfrontend to its own GitHub repository"
echo "2. Add these secrets to each repository:"
echo "   - AWS_ACCESS_KEY_ID"
echo "   - AWS_SECRET_ACCESS_KEY"
echo "   - S3_BUCKET"
echo "   - AWS_REGION"
echo "   - ORG_NAME"
echo "3. Push to main/master branch to trigger deployment"