#!/bin/bash

echo "🛑 FireWatch Shutdown Script"
echo "============================"
echo ""

# Function to check if a port is in use
port_in_use() {
    lsof -i :$1 &> /dev/null
}

# Function to kill processes on a specific port
kill_port() {
    local port=$1
    local service=$2
    
    if port_in_use $port; then
        echo "🔄 Stopping $service on port $port..."
        fuser -k $port/tcp 2>/dev/null || true
        sleep 2
        
        if port_in_use $port; then
            echo "⚠️  Force killing processes on port $port..."
            sudo fuser -k $port/tcp 2>/dev/null || true
            sleep 1
        fi
        
        if ! port_in_use $port; then
            echo "✅ $service stopped successfully"
        else
            echo "❌ Failed to stop $service on port $port"
        fi
    else
        echo "ℹ️  $service not running on port $port"
    fi
}

echo "🔍 Checking running services..."
echo ""

# Stop Backend (port 8080)
kill_port 8080 "Backend"

# Stop Frontend (port 3000)
kill_port 3000 "Frontend"

# Stop ngrok
echo "🔄 Stopping ngrok..."
if pgrep -f ngrok > /dev/null; then
    pkill -f ngrok
    sleep 2
    if ! pgrep -f ngrok > /dev/null; then
        echo "✅ ngrok stopped successfully"
    else
        echo "❌ Failed to stop ngrok"
    fi
else
    echo "ℹ️  ngrok not running"
fi

# Stop Docker containers
echo "🔄 Stopping Docker containers..."
if command -v docker &> /dev/null; then
    if docker ps | grep -q "firewatch-backend-dev"; then
        docker stop firewatch-backend-dev 2>/dev/null
        echo "✅ Docker backend container stopped"
    else
        echo "ℹ️  No Docker backend container running"
    fi
else
    echo "ℹ️  Docker not available"
fi

# Clean up log files
echo "🔄 Cleaning up log files..."
[ -f "backend.log" ] && rm -f backend.log && echo "✅ backend.log removed"
[ -f "ngrok.log" ] && rm -f ngrok.log && echo "✅ ngrok.log removed"

echo ""
echo "🎉 All FireWatch services have been stopped!"
echo "✅ System shutdown complete"