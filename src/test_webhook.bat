@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo 🧪 FireWatch Webhook Testing
echo ============================
echo.

REM Check if curl is available
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ curl not found!
    echo 📥 curl should be available in Windows 10/11 by default
    echo    Or download from: https://curl.se/windows/
    pause
    exit /b 1
)

echo ✅ curl is available

REM Check if backend is running
echo 🔍 Checking if backend is running...
curl -s http://localhost:8080/api/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Backend is not running on port 8080!
    echo.
    echo 📝 Please start the backend first:
    echo    start_backend.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Backend is running

REM Get ngrok URL if available
set NGROK_URL=
where jq >nul 2>&1
if %errorlevel%==0 (
    echo 🔍 Checking for active ngrok tunnel...
    for /f "delims=" %%i in ('curl -s http://localhost:4040/api/tunnels 2^>nul ^| jq -r ".tunnels[0].public_url" 2^>nul') do set NGROK_URL=%%i
    
    if "!NGROK_URL!"=="null" set NGROK_URL=
    if not "!NGROK_URL!"=="" (
        echo ✅ Found ngrok tunnel: !NGROK_URL!
        set WEBHOOK_URL=!NGROK_URL!/api/webhook/whatsapp
    ) else (
        echo ⚠️  No ngrok tunnel found
        set WEBHOOK_URL=http://localhost:8080/api/webhook/whatsapp
    )
) else (
    echo ⚠️  jq not available, testing localhost only
    set WEBHOOK_URL=http://localhost:8080/api/webhook/whatsapp
)

echo.
echo 🧪 Running Webhook Tests...
echo ===========================

REM Test 1: Basic webhook connectivity
echo.
echo 1️⃣  Testing webhook connectivity...
echo    POST !WEBHOOK_URL!
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" -X POST -H "Content-Type: application/json" -d "{\"test\": \"connectivity\"}" !WEBHOOK_URL!') do set basic_status=%%i
if "!basic_status!"=="200" (
    echo    ✅ Webhook accessible (Status: !basic_status!)
) else (
    echo    ⚠️  Webhook status: !basic_status!
)

REM Test 2: Twilio-like message format
echo.
echo 2️⃣  Testing Twilio message format...
set "twilio_data={\"From\": \"whatsapp:+5511999999999\", \"Body\": \"Test message\", \"To\": \"whatsapp:+14155238886\"}"
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "From=whatsapp:+5511999999999&Body=Test message&To=whatsapp:+14155238886" !WEBHOOK_URL!') do set twilio_status=%%i
echo    ✅ Twilio format test (Status: !twilio_status!)

REM Test 3: User registration format
echo.
echo 3️⃣  Testing user registration...
set "reg_data=From=whatsapp:+5511999999999&Body=NOME: João Silva ENDERECO: Rua das Flores 123 CIDADE: São Paulo&To=whatsapp:+14155238886"
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "!reg_data!" !WEBHOOK_URL!') do set reg_status=%%i
echo    ✅ Registration format test (Status: !reg_status!)

REM Test 4: Fire report format
echo.
echo 4️⃣  Testing fire report...
set "fire_data=From=whatsapp:+5511999999999&Body=Rua das Palmeiras 456, Centro, São Paulo&To=whatsapp:+14155238886"
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "!fire_data!" !WEBHOOK_URL!') do set fire_status=%%i
echo    ✅ Fire report test (Status: !fire_status!)

REM Test 5: Check API endpoints
echo.
echo 5️⃣  Testing related API endpoints...
echo    📋 Users endpoint...
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/usuarios') do set users_status=%%i
echo       Status: !users_status!

echo    🔥 Occurrences endpoint...
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/ocorrencias') do set occur_status=%%i
echo       Status: !occur_status!

echo.
echo 📊 Test Results Summary:
echo =======================
echo 🔗 Webhook URL: !WEBHOOK_URL!
echo 📡 Basic connectivity: !basic_status!
echo 📱 Twilio format: !twilio_status!
echo 👤 User registration: !reg_status!
echo 🔥 Fire report: !fire_status!
echo 👥 Users API: !users_status!
echo 📋 Occurrences API: !occur_status!

echo.
if not "!NGROK_URL!"=="" (
    echo ✅ ngrok tunnel active - webhook can receive external requests
    echo 🌐 Public webhook URL: !NGROK_URL!/api/webhook/whatsapp
    echo 📊 Monitor requests at: http://localhost:4040
) else (
    echo ⚠️  No ngrok tunnel detected
    echo 💡 Start ngrok to test external webhook connectivity:
    echo    start_ngrok.bat
)

echo.
echo 🔍 Next steps:
echo 1. If ngrok is running, configure Twilio webhook with the public URL
echo 2. Test with actual WhatsApp messages
echo 3. Monitor backend logs for detailed processing info
echo 4. Check frontend at http://localhost:3000 for new data

echo.
pause