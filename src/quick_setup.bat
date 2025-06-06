@echo off
chcp 65001 >nul

echo.
echo 🔥 FireWatch - Quick Windows Setup Script
echo =========================================
echo.

REM Check if .env exists
if not exist "..\env" (
    echo 📝 Creating .env file from template...
    if exist "..\.env.example" (
        copy "..\.env.example" "..\env" >nul
        echo ✅ .env file created!
    ) else (
        echo ❌ .env.example not found! Creating basic .env...
        (
        echo # Twilio Configuration
        echo TWILIO_ACCOUNT_SID=your_account_sid_here
        echo TWILIO_AUTH_TOKEN=your_auth_token_here
        echo TWILIO_WHATSAPP_FROM=whatsapp:+14155238886
        echo.
        echo # Database Configuration
        echo DB_HOST=localhost
        echo DB_PORT=3306
        echo DB_NAME=firewatch
        echo DB_USERNAME=firewatch_user
        echo DB_PASSWORD=firewatch_pass
        echo.
        echo # Redis Configuration
        echo REDIS_HOST=localhost
        echo REDIS_PORT=6379
        echo REDIS_PASSWORD=firewatch123
        echo.
        echo # Application Configuration
        echo SERVER_PORT=8080
        echo REACT_APP_API_URL=http://localhost:8080/api
        ) > "..\env"
        echo ✅ Basic .env file created!
    )
    echo.
    echo ⚠️  IMPORTANT: Edit .env file with your Twilio credentials:
    echo    - TWILIO_ACCOUNT_SID
    echo    - TWILIO_AUTH_TOKEN
    echo    - TWILIO_WHATSAPP_FROM
    echo.
) else (
    echo ✅ .env file already exists
)

REM Check if Docker is installed
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker not found!
    echo 📥 Install Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo.
) else (
    for /f "tokens=*" %%a in ('docker --version') do echo ✅ Docker is installed: %%a
)

REM Check if Docker Compose is available
where docker-compose >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose not found!
    echo 📥 Docker Compose should be included with Docker Desktop
) else (
    for /f "tokens=*" %%a in ('docker-compose --version') do echo ✅ Docker Compose is installed: %%a
)

REM Check if Java is installed
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java not found!
    echo 📥 Install Java 17+ from:
    echo    Download from: https://adoptium.net/
    echo.
) else (
    for /f "tokens=*" %%a in ('java -version 2^>^&1 ^| findstr /i "version"') do echo ✅ Java is installed: %%a
)

REM Check if Node.js is installed
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found!
    echo 📥 Install Node.js 18+ from:
    echo    Download from: https://nodejs.org/
    echo.
) else (
    for /f "tokens=*" %%a in ('node --version') do echo ✅ Node.js is installed: %%a
)

REM Check if Python is installed
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found!
    echo 📥 Install Python 3.11+ from:
    echo    Download from: https://www.python.org/downloads/
    echo.
) else (
    for /f "tokens=*" %%a in ('python --version') do echo ✅ Python is installed: %%a
)

REM Check if Git is installed
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git not found!
    echo 📥 Install Git from:
    echo    Download from: https://git-scm.com/download/win
    echo.
) else (
    for /f "tokens=*" %%a in ('git --version') do echo ✅ Git is installed: %%a
)

echo.
echo 🚀 Next Steps for Windows:
echo ==========================
echo.
echo 1. 📝 Configure Twilio credentials in .env file:
echo    notepad ..\env
echo.
echo 2. 🐳 Start with Docker (Recommended):
echo    cd .. ^&^& docker-compose up -d
echo.
echo 3. 🌐 Or start services individually:
echo    start_database.bat      # Start MySQL + Redis
echo    start_backend.bat       # Start Spring Boot API
echo    start_frontend.bat      # Start React app
echo.
echo 4. 🔗 For WhatsApp integration:
echo    setup_whatsapp.bat      # Setup ngrok + webhook
echo.
echo 5. 🧪 Test the application:
echo    test_api.bat            # Test API endpoints
echo.
echo 6. 🌐 Access the application:
echo    - Frontend: http://localhost:3000
echo    - Backend API: http://localhost:8080
echo    - Database Admin: http://localhost:8081
echo.
echo 💾 Low memory options:
echo    start_backend_low_memory.bat  # Use if system has limited RAM
echo.
echo 📚 For detailed instructions, see: documentation\README.md
echo.
echo 🆘 Need help? Check the troubleshooting section in documentation\
echo.

echo 📝 All scripts are now ready!
echo.
pause