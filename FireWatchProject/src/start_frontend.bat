@echo off
chcp 65001 >nul
title FireWatch - Start Frontend Service

echo.
echo 🔥 Starting FireWatch Frontend Service...
echo.

REM Check if Node.js is available
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js/npm not found! Please install Node.js 18+
    echo 📥 Download from: https://nodejs.org/
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version 2^>nul') do echo ✅ Node.js found: %%i
for /f "tokens=*" %%i in ('npm --version 2^>nul') do echo ✅ npm found: %%i

REM Navigate to frontend directory
if not exist "frontend" (
    echo ❌ Frontend directory not found
    pause
    exit /b 1
)

cd frontend
echo 📁 Working directory: %cd%

REM Check if package.json exists
if not exist "package.json" (
    echo ❌ package.json not found!
    echo 💡 Make sure you're in the correct frontend directory
    pause
    exit /b 1
)

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    echo    This may take a few minutes on first run...
    echo.
    
    npm install
    if %errorlevel% equ 0 (
        echo ✅ Dependencies installed successfully!
    ) else (
        echo ❌ Failed to install dependencies!
        echo 🔍 Try running: npm install --verbose
        pause
        exit /b 1
    )
) else (
    echo ✅ Dependencies already installed
)

REM Check if backend is running
echo.
echo 🔍 Checking backend API connection...
curl -s http://localhost:8080/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend API is running
) else (
    echo ⚠️  Backend API not responding. Make sure to start backend first:
    echo    start_backend.bat
)

echo.
echo 🚀 Starting React development server...
echo.
echo 📊 Frontend will be available at:
echo    http://localhost:3000
echo.
echo 🔧 Development server features:
echo    ✨ Hot reload enabled
echo    🔍 Error overlay enabled
echo    📱 Mobile responsive
echo.
echo ⚠️  To stop the server, press Ctrl+C
echo.

REM Set environment variables
set REACT_APP_API_URL=http://localhost:8080/api
set BROWSER=none

REM Start the development server
npm start
if %errorlevel% neq 0 (
    echo.
    echo ❌ Failed to start frontend service!
    echo.
    echo 📋 Troubleshooting:
    echo 1. Check if port 3000 is already in use:
    echo    netstat -ano ^| findstr :3000
    echo.
    echo 2. Clear npm cache:
    echo    npm cache clean --force
    echo.
    echo 3. Reinstall dependencies:
    echo    rmdir /s node_modules
    echo    npm install
    echo.
    echo 4. Check Node.js version:
    echo    node --version (should be 18+)
    echo.
    pause
)