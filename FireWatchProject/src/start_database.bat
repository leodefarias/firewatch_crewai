@echo off
chcp 65001 >nul

echo.
echo 🔥 Starting FireWatch Database Services...
echo.

REM Check if Docker is running
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running!
    echo 📥 Start Docker Desktop and try again
    pause
    exit /b 1
)

echo ✅ Docker is running

echo 🐳 Starting MySQL and Redis containers...

REM Navigate to project root
cd ..

REM Start only database services
docker-compose up -d firewatch-mysql firewatch-redis
if %errorlevel%==0 (
    echo.
    echo ✅ Database services started successfully!
    echo.
    echo 📊 Service Status:
    echo ==================
    echo 🗄️  MySQL:    localhost:3306
    echo 🔴 Redis:     localhost:6379
    echo 🔧 Adminer:   http://localhost:8081
    echo.
    echo 🔑 Database Credentials:
    echo ========================
    echo Database: firewatch
    echo Username: firewatch_user
    echo Password: firewatch_pass
    echo.
    echo ⏳ Waiting for services to be ready...
    
    REM Wait for MySQL to be ready
    set attempt=0
    set max_attempts=30
    :wait_mysql
    set /a attempt+=1
    echo    Checking MySQL connection (attempt %attempt%/%max_attempts%)...
    docker exec firewatch-mysql mysqladmin ping -h localhost -u firewatch_user -pfirewatch_pass >nul 2>&1
    if %errorlevel%==0 (
        echo ✅ MySQL is ready!
        goto mysql_ready
    )
    if %attempt%==%max_attempts% (
        echo ⚠️  MySQL took longer than expected to start
        goto mysql_ready
    )
    timeout /t 2 >nul
    goto wait_mysql
    
    :mysql_ready
    echo.
    echo 🚀 Next steps:
    echo    start_backend.bat       # Start Spring Boot API
    echo    start_frontend.bat      # Start React frontend
    echo.
    echo 🛑 To stop database services:
    echo    stop_database.bat
    
) else (
    echo.
    echo ❌ Failed to start database services!
    echo 🔍 Check Docker and try again
    echo.
    echo 📋 Troubleshooting:
    echo    docker-compose logs firewatch-mysql
    echo    docker-compose logs firewatch-redis
)

echo.
pause