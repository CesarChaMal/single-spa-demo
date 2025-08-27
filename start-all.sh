#!/bin/bash

echo "Starting Single-SPA Microfrontend Demo..."
echo

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed or not in PATH"
    echo "Please install Node.js from https://nodejs.org/"
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