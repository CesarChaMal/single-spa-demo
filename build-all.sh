#!/bin/bash

echo "Building Single-SPA Microfrontend Demo for Production..."
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

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed or not in PATH"
    echo "Please install Node.js from https://nodejs.org/ or use nvm"
    exit 1
fi

echo "Installing dependencies for all microfrontends..."
npm run install:all
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi

echo
echo "Running tests for all microfrontends..."
npm run test:all
if [ $? -ne 0 ]; then
    echo "Warning: Some tests failed"
fi

echo
echo "Linting all microfrontends..."
npm run lint:all
if [ $? -ne 0 ]; then
    echo "Warning: Linting issues found"
fi

echo
echo "Building all microfrontends for production..."
npm run build:all
if [ $? -ne 0 ]; then
    echo "Error: Build failed"
    exit 1
fi

echo
echo "Build completed successfully!"
echo "Production bundles are available in each microfrontend's dist/ directory"