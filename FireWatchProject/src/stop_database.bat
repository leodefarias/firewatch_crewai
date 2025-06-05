@echo off
chcp 65001 >nul
title FireWatch - Stop Database Services

echo.
echo 🔥 Stopping FireWatch Database Services...
echo.

REM Check if Docker is running
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Docker is not running or accessible
    pause
    exit /b 0
)

REM Navigate to project root
cd ..

echo 🛑 Stopping database containers...

REM Stop database services
docker-compose stop firewatch-mysql firewatch-redis firewatch-adminer

if %errorlevel% equ 0 (
    echo.
    echo ✅ Database services stopped successfully!
    echo.
    
    REM Show status
    echo 📊 Container Status:
    docker-compose ps firewatch-mysql firewatch-redis firewatch-adminer
    
    echo.
    echo 🔧 Available commands:
    echo    start_database.bat      # Restart database services
    echo    docker-compose down     # Remove containers completely
    echo.
    
) else (
    echo.
    echo ❌ Failed to stop some services!
    echo 🔍 Check running containers:
    echo    docker ps
)

echo.
pause