@echo off
chcp 65001 >nul
title FireWatch - WhatsApp Setup

echo.
echo 🔥 FireWatch - WhatsApp Integration Setup
echo ==========================================
echo.

REM Check if .env file exists
if not exist "..\env" (
    echo ❌ .env file not found!
    echo 📝 Run quick_setup.bat first to create .env file
    pause
    exit /b 1
)

echo ✅ Found .env file

REM Check if ngrok is installed
ngrok version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ngrok not found!
    echo.
    echo 📥 Install ngrok for Windows:
    echo 1. Download from: https://ngrok.com/download
    echo 2. Extract ngrok.exe to a folder in your PATH
    echo 3. Or use chocolatey: choco install ngrok
    echo 4. Or use winget: winget install ngrok.ngrok
    echo.
    echo ⚠️  You'll also need to create a free ngrok account and run:
    echo    ngrok config add-authtoken YOUR_TOKEN
    echo.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('ngrok version 2^>nul') do echo ✅ ngrok is installed: %%i

REM Check if backend is running
echo.
echo 🔍 Checking if backend is running...
curl -s http://localhost:8080/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend is running on port 8080
) else (
    echo ❌ Backend is not running!
    echo 🚀 Start backend first:
    echo    start_backend.bat
    echo.
    set /p choice="Do you want to continue anyway? (y/n): "
    if /i not "%choice%"=="y" exit /b 1
)

REM Check Twilio configuration
echo.
echo 🔍 Checking Twilio configuration...
findstr /v "your_account_sid_here" "..\env" | findstr "TWILIO_ACCOUNT_SID" >nul
if %errorlevel% equ 0 (
    findstr /v "your_auth_token_here" "..\env" | findstr "TWILIO_AUTH_TOKEN" >nul
    if %errorlevel% equ 0 (
        echo ✅ Twilio credentials found in .env
    ) else (
        goto :twilio_config_warning
    )
) else (
    :twilio_config_warning
    echo ⚠️  Twilio credentials not properly configured!
    echo.
    echo 📝 Please edit .env file with your Twilio credentials:
    echo    notepad ..\env
    echo.
    echo 🔑 You need:
    echo    - TWILIO_ACCOUNT_SID (from Twilio Console)
    echo    - TWILIO_AUTH_TOKEN (from Twilio Console)
    echo    - TWILIO_WHATSAPP_FROM (e.g., whatsapp:+14155238886)
    echo.
    set /p choice="Do you want to open .env file now? (y/n): "
    if /i "%choice%"=="y" (
        notepad "..\env"
        echo Press any key after saving .env file...
        pause >nul
    )
)

echo.
echo 🌐 Starting ngrok tunnel...
echo.

REM Start ngrok in background
echo ⏳ Starting ngrok tunnel for port 8080...
start /min cmd /c "ngrok http 8080 --log=stdout"

REM Wait for ngrok to start
timeout /t 5 /nobreak >nul

REM Get the public URL from ngrok API
echo 🔍 Getting tunnel information...
for /f "tokens=*" %%i in ('curl -s http://localhost:4040/api/tunnels') do set ngrok_response=%%i

REM Extract HTTPS URL (simplified - might need adjustment)
echo %ngrok_response% | findstr "https://" >nul
if %errorlevel% equ 0 (
    echo ✅ ngrok tunnel created successfully!
    echo.
    echo 🔗 Check your public URL at: http://localhost:4040
    echo.
    echo 📱 Your webhook URL format will be:
    echo    https://YOUR_NGROK_URL.ngrok.io/api/webhook/whatsapp
    echo.
    echo ⚙️  Next steps for Twilio configuration:
    echo =======================================
    echo.
    echo 1. 🌐 Go to Twilio Console: https://console.twilio.com/
    echo.
    echo 2. 📱 Navigate to: Messaging ^> Try it out ^> Send a WhatsApp message
    echo.
    echo 3. 🔧 Configure Sandbox Settings:
    echo    - Webhook URL: https://YOUR_NGROK_URL.ngrok.io/api/webhook/whatsapp
    echo    - HTTP Method: POST
    echo    - Events: Incoming Messages
    echo.
    echo 4. 📲 Join WhatsApp Sandbox:
    echo    - Send 'join ^<sandbox-keyword^>' to +1 415 523 8886
    echo    - Example: 'join yellow-dog'
    echo.
    echo 5. 🧪 Test by sending a location or coordinates:
    echo    - Send your location via WhatsApp
    echo    - Or send: 'Incêndio! Lat: -23.5505, Long: -46.6333'
    echo.
    echo 🔍 Monitor webhook calls:
    echo    - ngrok dashboard: http://localhost:4040
    echo    - Backend logs: Check console where backend is running
    echo.
    echo ⚠️  Keep this window open to maintain the tunnel!
    echo    Press any key to stop ngrok when done
    echo.
    
    pause
    
) else (
    echo ❌ Failed to get ngrok tunnel information!
    echo 🔍 Check if ngrok started correctly:
    echo    - Visit http://localhost:4040 for ngrok dashboard
    echo    - Check if port 8080 is available
)

REM Clean up - kill ngrok process
echo.
echo 🛑 Stopping ngrok tunnel...
taskkill /f /im ngrok.exe >nul 2>&1

echo.
echo ✅ WhatsApp setup script completed!
echo.
echo 📚 For more detailed instructions, see:
echo    documentation\SETUP_WHATSAPP.md
echo.
pause