@echo off
:: 🔥 FireWatch - Quick Start Script for Windows
:: =============================================

echo.
echo 🔥 FireWatch - Quick Start for Windows
echo =====================================
echo.

:: Check if Docker Desktop is running
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Desktop is not running!
    echo 📥 Please start Docker Desktop and try again
    echo.
    pause
    exit /b 1
)

echo ✅ Docker Desktop is running
echo.

:: Navigate to project root
cd /d "%~dp0.."

echo 🐳 Starting all FireWatch services with Docker...
echo.

:: Start all services
docker-compose up -d

if errorlevel 1 (
    echo.
    echo ❌ Failed to start services!
    echo 🔍 Check Docker Desktop and try again
    pause
    exit /b 1
)

echo.
echo ✅ All services started successfully!
echo.
echo 📊 Service URLs:
echo ================
echo 🌐 Frontend:     http://localhost:3000
echo 🚀 Backend API:  http://localhost:8080
echo 🗄️  Database:     http://localhost:8081 (Adminer)
echo 📈 Monitoring:   http://localhost:3001 (Grafana)
echo.
echo ⏳ Services are starting up... This may take 1-2 minutes
echo.
echo 🔧 Useful commands:
echo    docker-compose logs -f          # View logs
echo    docker-compose ps               # Check status
echo    docker-compose down             # Stop all services
echo.

:: Wait for services to be ready
echo ⏳ Waiting for services to be ready...
timeout /t 30 /nobreak >nul

:: Try to open frontend in browser
echo 🌐 Opening frontend in browser...
start http://localhost:3000

echo.
echo 🎉 FireWatch is ready to use!
echo.
echo 📚 Need help? Check documentation\ folder
echo 🆘 Problems? Run .\src\test_api.ps1 to diagnose
echo.
pause