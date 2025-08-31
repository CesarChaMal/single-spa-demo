#!/bin/bash

echo "Starting Single-SPA Microfrontend Demo..."
echo

# Use correct Node.js version with nvm
if [ -f .nvmrc ]; then
    NODE_VERSION=$(cat .nvmrc)
    echo "Using Node.js version $NODE_VERSION from .nvmrc..."
    if command -v nvm &> /dev/null; then
        nvm use $NODE_VERSION
        if [ $? -ne 0 ]; then
            echo "Installing Node.js version $NODE_VERSION..."
            nvm install $NODE_VERSION
            nvm use $NODE_VERSION
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

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed or not in PATH"
    exit 1
fi

echo "Installing dependencies for all microfrontends..."
npm run install:all
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi

echo
echo "Starting all microfrontends..."
echo "- Root Config will be available at: http://localhost:9000"
echo "- Navigation App will be available at: http://localhost:9001"
echo "- Page 1 App will be available at: http://localhost:9002"
echo "- Page 2 App will be available at: http://localhost:9003"
echo
echo "Press Ctrl+C to stop all services"
echo

npm run start:all