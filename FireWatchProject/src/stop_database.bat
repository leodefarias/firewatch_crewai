@echo off
chcp 65001 >nul

echo.
echo 🛑 Stopping FireWatch Database Services
echo =======================================
echo.

REM Navigate to project root
cd ..

echo 🔄 Stopping database containers...

REM Stop specific database containers
docker stop firewatch-mysql firewatch-redis >nul 2>&1

REM Remove containers
docker rm firewatch-mysql firewatch-redis >nul 2>&1

REM Alternative: Use docker-compose to stop services
docker-compose stop firewatch-mysql firewatch-redis >nul 2>&1

echo ✅ Database services stopped
echo.

REM Check if containers are still running
docker ps --filter "name=firewatch-mysql" --format "table {{.Names}}" | findstr "firewatch-mysql" >nul
if %errorlevel% neq 0 (
    echo ✅ MySQL container stopped successfully
) else (
    echo ⚠️  MySQL container may still be running
)

docker ps --filter "name=firewatch-redis" --format "table {{.Names}}" | findstr "firewatch-redis" >nul
if %errorlevel% neq 0 (
    echo ✅ Redis container stopped successfully
) else (
    echo ⚠️  Redis container may still be running
)

echo.
echo 📊 Current Docker containers:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=firewatch"

echo.
echo 🚀 To restart database services:
echo    start_database.bat
echo.

pause