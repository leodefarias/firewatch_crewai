@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo 🔥 FireWatch WhatsApp Integration Setup
echo ======================================
echo.

REM Check if ngrok is installed
where ngrok >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ngrok not found!
    echo.
    echo 📥 Install ngrok:
    echo    1. Go to https://ngrok.com/
    echo    2. Sign up for a free account
    echo    3. Download ngrok for Windows
    echo    4. Extract ngrok.exe to a folder in your PATH (e.g., C:\Windows\System32)
    echo    5. Run: ngrok authtoken ^<your-auth-token^>
    echo.
    pause
    exit /b 1
)

echo ✅ ngrok is installed

REM Check if backend is running
echo 🔍 Checking if backend is running on port 8080...
netstat -an | find ":8080" | find "LISTENING" >nul
if %errorlevel% neq 0 (
    echo ❌ Backend is not running on port 8080!
    echo.
    echo 📝 Please start the backend first:
    echo    start_backend.bat
    echo.
    echo    Or start all services:
    echo    start_firewatch.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Backend is running on port 8080

REM Kill any existing ngrok processes
echo 🔄 Stopping any existing ngrok processes...
taskkill /F /IM ngrok.exe >nul 2>&1

REM Wait a moment
timeout /t 2 >nul

echo 🌐 Starting ngrok tunnel for port 8080...
start /b ngrok http 8080 --log=stdout >ngrok.log 2>&1

echo ⏳ Waiting for ngrok to establish tunnel...
timeout /t 5 >nul

REM Get ngrok public URL
set NGROK_URL=
where curl >nul 2>&1
if %errorlevel%==0 (
    where jq >nul 2>&1
    if %errorlevel%==0 (
        echo 🔍 Retrieving ngrok public URL...
        for /f "delims=" %%i in ('curl -s http://localhost:4040/api/tunnels ^| jq -r ".tunnels[0].public_url" 2^>nul') do set NGROK_URL=%%i
        
        if "!NGROK_URL!"=="null" set NGROK_URL=
        if "!NGROK_URL!"=="" (
            echo ⚠️  Could not retrieve ngrok URL automatically
            goto manual_url
        )
        
        echo ✅ ngrok tunnel established!
        echo 🌐 Public URL: !NGROK_URL!
        echo.
        
        REM Display webhook configuration
        echo 📋 Twilio Webhook Configuration:
        echo ===============================
        echo.
        echo 🔗 WhatsApp Webhook URL:
        echo    !NGROK_URL!/api/webhook/whatsapp
        echo.
        echo 📝 Steps to configure Twilio:
        echo    1. Go to https://console.twilio.com/
        echo    2. Navigate to Messaging ^> Settings ^> WhatsApp Sandbox
        echo    3. Set the webhook URL to: !NGROK_URL!/api/webhook/whatsapp
        echo    4. Set HTTP method to POST
        echo    5. Save the configuration
        echo.
        
        goto webhook_ready
    )
)

:manual_url
echo 🌐 ngrok started successfully!
echo 📊 ngrok Dashboard: http://localhost:4040
echo.
echo 📝 Manual Configuration Steps:
echo =============================
echo.
echo 1. Open ngrok dashboard: http://localhost:4040
echo 2. Copy the HTTPS tunnel URL (e.g., https://abc123.ngrok.io)
echo 3. Add '/api/webhook/whatsapp' to the end
echo 4. Use this URL in Twilio WhatsApp Sandbox settings
echo.

:webhook_ready
REM Check if .env file exists and show Twilio configuration
if exist "..\env" (
    echo 🔑 Twilio Configuration Check:
    echo =============================
    echo.
    findstr /i "TWILIO_ACCOUNT_SID" "..\env" >nul
    if %errorlevel%==0 (
        for /f "tokens=2 delims==" %%a in ('findstr /i "TWILIO_ACCOUNT_SID" "..\env"') do (
            if "%%a"=="your_account_sid_here" (
                echo ⚠️  TWILIO_ACCOUNT_SID not configured
                set need_config=true
            ) else (
                echo ✅ TWILIO_ACCOUNT_SID configured
            )
        )
    ) else (
        echo ⚠️  TWILIO_ACCOUNT_SID not found in .env
        set need_config=true
    )
    
    findstr /i "TWILIO_AUTH_TOKEN" "..\env" >nul
    if %errorlevel%==0 (
        for /f "tokens=2 delims==" %%a in ('findstr /i "TWILIO_AUTH_TOKEN" "..\env"') do (
            if "%%a"=="your_auth_token_here" (
                echo ⚠️  TWILIO_AUTH_TOKEN not configured
                set need_config=true
            ) else (
                echo ✅ TWILIO_AUTH_TOKEN configured
            )
        )
    ) else (
        echo ⚠️  TWILIO_AUTH_TOKEN not found in .env
        set need_config=true
    )
    
    if defined need_config (
        echo.
        echo 📝 Please configure your Twilio credentials in .env file:
        echo    notepad ..\env
        echo.
        echo 🔍 Get your credentials from:
        echo    https://console.twilio.com/
        echo.
    )
) else (
    echo ⚠️  .env file not found! Run quick_setup.bat first
)

echo.
echo 🧪 Testing:
echo ==========
echo.
echo 1. Test webhook endpoint:
if not "!NGROK_URL!"=="" (
    echo    curl -X POST !NGROK_URL!/api/webhook/whatsapp
) else (
    echo    curl -X POST ^<your-ngrok-url^>/api/webhook/whatsapp
)
echo.
echo 2. Test WhatsApp integration:
echo    - Send a message to your Twilio WhatsApp number
echo    - Check if it appears in the FireWatch dashboard
echo.
echo 🔄 ngrok tunnel will remain active until you close this window
echo 📊 Monitor requests at: http://localhost:4040
echo.
echo ⚠️  Note: ngrok free accounts have session limits
echo    Tunnel URLs change when ngrok restarts
echo.

pause