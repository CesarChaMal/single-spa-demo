#!/bin/bash

echo "Deploying Single-SPA Microfrontends to Production..."
echo

# Use correct Node.js version with nvm
if [ -f .nvmrc ]; then
    echo "Using Node.js version from .nvmrc..."
    if command -v nvm &> /dev/null; then
        nvm use
        if [ $? -ne 0 ]; then
            echo "Installing Node.js version from .nvmrc..."
            nvm install
            nvm use
        fi
    else
        echo "Warning: nvm not found, using system Node.js"
    fi
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed"
    echo "Please install AWS CLI from https://aws.amazon.com/cli/"
    exit 1
fi

# Load environment variables
if [ -f .env ]; then
    echo "Loading configuration from .env..."
    export $(cat .env | xargs)
else
    echo "No .env file found. Run ./setup-deployment-cesarchamal.sh first"
    exit 1
fi

# Check required environment variables
if [ -z "$S3_BUCKET" ] || [ -z "$AWS_REGION" ] || [ -z "$ORG_NAME" ]; then
    echo "Error: Missing required environment variables"
    echo "Please check your .env file has: S3_BUCKET, AWS_REGION, ORG_NAME"
    exit 1
fi

echo "Configuration:"
echo "S3_BUCKET=$S3_BUCKET"
echo "AWS_REGION=$AWS_REGION"
echo "ORG_NAME=$ORG_NAME"
echo

# Setup S3 bucket if needed
echo "Setting up S3 bucket..."
./setup-s3-bucket.sh

echo "Building and deploying all microfrontends..."
echo "This will deploy each microfrontend using their after_deploy.sh scripts"
echo

# Deploy each microfrontend
echo "Deploying root config..."
cd single-spa-demo-root-config
npm run build
export GITHUB_SHA=$(git rev-parse HEAD 2>/dev/null || echo "manual-$(date +%s)")
chmod +x after_deploy.sh
./after_deploy.sh
cd ..

echo "Deploying navigation app..."
cd single-spa-demo-nav
npm run build
export GITHUB_SHA=$(git rev-parse HEAD 2>/dev/null || echo "manual-$(date +%s)")
chmod +x after_deploy.sh
./after_deploy.sh
cd ..

echo "Deploying page 1 app..."
cd single-spa-demo-page-1
npm run build
export GITHUB_SHA=$(git rev-parse HEAD 2>/dev/null || echo "manual-$(date +%s)")
chmod +x after_deploy.sh
./after_deploy.sh
cd ..

echo "Deploying page 2 app..."
cd single-spa-demo-page-2
npm run build
export GITHUB_SHA=$(git rev-parse HEAD 2>/dev/null || echo "manual-$(date +%s)")
chmod +x after_deploy.sh
./after_deploy.sh
cd ..

echo
echo "Deployment completed successfully!"
echo "Check your S3 bucket for the deployed assets."