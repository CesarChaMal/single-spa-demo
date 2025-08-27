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

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Setting up deployment configuration..."
    npm run deploy:setup
    if [ $? -ne 0 ]; then
        echo "Error: Failed to setup deployment"
        exit 1
    fi
fi

echo "Building and deploying all microfrontends..."
npm run deploy:all
if [ $? -ne 0 ]; then
    echo "Error: Deployment failed"
    exit 1
fi

echo
echo "Deployment completed successfully!"
echo "Check your S3 bucket for the deployed assets."