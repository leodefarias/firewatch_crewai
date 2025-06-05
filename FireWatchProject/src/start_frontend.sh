#!/bin/bash

echo ""
echo "🔥 Starting FireWatch Frontend Service..."
echo ""

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js/npm not found! Please install Node.js 18+"
    echo "📥 Install with:"
    echo "   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -"
    echo "   sudo apt-get install -y nodejs"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"
echo "✅ npm found: $(npm --version)"

# Navigate to frontend directory
if [ ! -d "frontend" ]; then
    echo "❌ Frontend directory not found"
    exit 1
fi

cd frontend
echo "📁 Working directory: $(pwd)"

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found!"
    echo "💡 Make sure you're in the correct frontend directory"
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    echo "   This may take a few minutes on first run..."
    echo ""
    
    if npm install; then
        echo "✅ Dependencies installed successfully!"
    else
        echo "❌ Failed to install dependencies!"
        echo "🔍 Try running: npm install --verbose"
        exit 1
    fi
else
    echo "✅ Dependencies already installed"
fi

# Check if backend is running
echo ""
echo "🔍 Checking backend API connection..."
if curl -s http://localhost:8080/api/health >/dev/null 2>&1; then
    echo "✅ Backend API is running"
else
    echo "⚠️  Backend API not responding. Make sure to start backend first:"
    echo "   ./start_backend.sh"
fi

echo ""
echo "🚀 Starting React development server..."
echo ""
echo "📊 Frontend will be available at:"
echo "   http://localhost:3000"
echo ""
echo "🔧 Development server features:"
echo "   ✨ Hot reload enabled"
echo "   🔍 Error overlay enabled"
echo "   📱 Mobile responsive"
echo ""
echo "⚠️  To stop the server, press Ctrl+C"
echo ""

# Set environment variables
export REACT_APP_API_URL="http://localhost:8080/api"
export BROWSER=none

# Start the development server
if npm start; then
    echo "✅ Frontend started successfully!"
else
    echo ""
    echo "❌ Failed to start frontend service!"
    echo ""
    echo "📋 Troubleshooting:"
    echo "1. Check if port 3000 is already in use:"
    echo "   sudo netstat -tulpn | grep :3000"
    echo ""
    echo "2. Clear npm cache:"
    echo "   npm cache clean --force"
    echo ""
    echo "3. Reinstall dependencies:"
    echo "   rm -rf node_modules"
    echo "   npm install"
    echo ""
    echo "4. Check Node.js version:"
    echo "   node --version (should be 18+)"
    echo ""
    read -p "Press any key to continue..."
fi