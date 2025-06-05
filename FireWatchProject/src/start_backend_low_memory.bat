@echo off
chcp 65001 >nul
title FireWatch - Start Backend (Low Memory)

echo.
echo 🔥 Starting FireWatch Backend (Low Memory Mode)...
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

echo 🔨 Building and starting Spring Boot application (Low Memory Mode)...
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
echo 🚀 Starting Spring Boot application (Low Memory)...
echo    This mode uses less memory but may be slower...
echo.

REM Set environment variables for low memory usage
set SPRING_PROFILES_ACTIVE=development
set MAVEN_OPTS=-Xmx384m -Xms128m -XX:MaxMetaspaceSize=96m -XX:+UseG1GC -XX:G1HeapRegionSize=16m

REM Start the application with minimal memory
mvnw.cmd spring-boot:run
if %errorlevel% neq 0 (
    echo.
    echo ❌ Failed to start backend service!
    echo.
    echo 📋 Troubleshooting:
    echo 1. Try normal memory mode: start_backend.bat
    echo 2. Check available system memory
    echo 3. Close other applications to free memory
    echo 4. Check if port 8080 is already in use:
    echo    netstat -ano ^| findstr :8080
    echo.
    pause
)