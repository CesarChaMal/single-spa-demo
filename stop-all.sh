#!/bin/bash

echo "Stopping Single-SPA Microfrontend Demo services..."

# Kill processes running on the microfrontend ports
echo "Stopping services on ports 9000-9003..."

# Function to kill process on port
kill_port() {
    local port=$1
    local pid=$(lsof -ti:$port 2>/dev/null)
    if [ ! -z "$pid" ]; then
        echo "Killing process $pid on port $port"
        kill -9 $pid 2>/dev/null
    fi
}

# Kill processes on each port
kill_port 9000  # Root Config
kill_port 9001  # Navigation App
kill_port 9002  # Page 1 App
kill_port 9003  # Page 2 App

# Kill any remaining node processes related to webpack-dev-server
pkill -f "webpack-dev-server" 2>/dev/null || true
pkill -f "webpack serve" 2>/dev/null || true

echo "All services stopped."