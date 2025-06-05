@echo off
chcp 65001 >nul
title FireWatch - Quick Windows Setup

echo.
echo 🔥 FireWatch - Quick Windows Setup Script
echo ==========================================
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

REM Check if Docker Desktop is installed
docker --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('docker --version 2^>nul') do echo ✅ Docker is installed: %%i
) else (
    echo ❌ Docker Desktop not found!
    echo 📥 Install Docker Desktop from: https://docs.docker.com/desktop/install/windows/
    echo    - Download Docker Desktop for Windows
    echo    - Run installer as Administrator
    echo    - Restart computer after installation
    echo.
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('docker-compose --version 2^>nul') do echo ✅ Docker Compose is installed: %%i
) else (
    echo ❌ Docker Compose not found!
    echo 📥 Docker Compose comes with Docker Desktop
)

REM Check if Java is installed
java -version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do echo ✅ Java is installed: %%i
) else (
    echo ❌ Java not found!
    echo 📥 Install Java 17+ from:
    echo    - https://adoptium.net/ ^(Recommended^)
    echo    - Or use: winget install EclipseAdoptium.Temurin.17.JDK
    echo.
)

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version 2^>nul') do echo ✅ Node.js is installed: %%i
) else (
    echo ❌ Node.js not found!
    echo 📥 Install Node.js 18+ from:
    echo    - https://nodejs.org/ ^(Download LTS version^)
    echo    - Or use: winget install OpenJS.NodeJS
    echo.
)

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version 2^>nul') do echo ✅ Python is installed: %%i
) else (
    echo ❌ Python not found!
    echo 📥 Install Python 3.11+ from:
    echo    - https://python.org/downloads/
    echo    - Or use: winget install Python.Python.3.11
    echo.
)

REM Check if Git is installed
git --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('git --version 2^>nul') do echo ✅ Git is installed: %%i
) else (
    echo ❌ Git not found!
    echo 📥 Install Git from:
    echo    - https://git-scm.com/download/win
    echo    - Or use: winget install Git.Git
    echo.
)

echo.
echo 🚀 Next Steps for Windows:
echo ==========================
echo.
echo 1. 📝 Configure Twilio credentials in .env file:
echo    notepad ..\env
echo.
echo 2. 🐳 Start with Docker ^(Recommended^):
echo    cd .. ^&^& docker-compose up -d
echo.
echo 3. 🌐 Or start services individually:
echo    start_firewatch_windows.bat     # Start all services
echo.
echo 4. 🧪 Test the application:
echo    test_api.ps1                     # Test API endpoints
echo.
echo 5. 🌐 Access the application:
echo    - Frontend: http://localhost:3000
echo    - Backend API: http://localhost:8080
echo    - Database Admin: http://localhost:8081
echo.
echo 📚 For detailed instructions, see: documentation\README.md
echo.
echo 🆘 Need help? Check the troubleshooting section in documentation\
echo.
pause