@echo off
chcp 65001 >nul
title FireWatch - Start Backend Service

echo.
echo 🔥 Starting FireWatch Backend Service...
echo.

REM Check if Java is available
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java not found! Please install Java 17+
    pause
    exit /b 1
)
for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do echo ✅ Java found: %%i

REM Navigate to backend directory
if not exist "backend" (
    echo ❌ Backend directory not found
    pause
    exit /b 1
)

cd backend
echo 📁 Working directory: %cd%

REM Check if Maven wrapper exists
if not exist "mvnw.cmd" (
    echo ❌ Maven wrapper (mvnw.cmd) not found!
    echo 💡 Make sure you're in the correct backend directory
    pause
    exit /b 1
)

echo 🔨 Building and starting Spring Boot application...
echo.

REM Check if database is running
echo 🔍 Checking database connection...
docker ps --filter "name=firewatch-mysql" --filter "status=running" --format "table {{.Names}}" | findstr "firewatch-mysql" >nul
if %errorlevel% equ 0 (
    echo ✅ MySQL container is running
) else (
    echo ⚠️  MySQL container not running. Starting database first...
    cd ..
    call start_database.bat
    cd backend
)

echo.
echo 🚀 Starting Spring Boot application...
echo    This may take a few minutes on first run...
echo.

REM Set environment variables for Windows
set SPRING_PROFILES_ACTIVE=development

REM Start the application
mvnw.cmd spring-boot:run
if %errorlevel% neq 0 (
    echo.
    echo ❌ Failed to start backend service!
    echo.
    echo 📋 Troubleshooting:
    echo 1. Check if port 8080 is already in use:
    echo    netstat -ano ^| findstr :8080
    echo.
    echo 2. Check database connection:
    echo    start_database.bat
    echo.
    echo 3. Check Java version:
    echo    java -version
    echo.
    echo 4. Clean and rebuild:
    echo    mvnw.cmd clean install
    echo.
    pause
)