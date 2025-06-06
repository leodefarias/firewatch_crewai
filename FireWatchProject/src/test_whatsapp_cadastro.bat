@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo 📱 FireWatch WhatsApp Registration Test
echo ======================================
echo.

REM Check if curl is available
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ curl not found!
    echo 📥 curl should be available in Windows 10/11 by default
    pause
    exit /b 1
)

REM Check if backend is running
echo 🔍 Checking backend status...
curl -s http://localhost:8080/api/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Backend is not running!
    echo 📝 Start backend first: start_backend.bat
    pause
    exit /b 1
)
echo ✅ Backend is running

REM Get webhook URL
set WEBHOOK_URL=http://localhost:8080/api/webhook/whatsapp

REM Get ngrok URL if available
where jq >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('curl -s http://localhost:4040/api/tunnels 2^>nul ^| jq -r ".tunnels[0].public_url" 2^>nul') do set NGROK_URL=%%i
    if not "!NGROK_URL!"=="null" if not "!NGROK_URL!"=="" (
        set WEBHOOK_URL=!NGROK_URL!/api/webhook/whatsapp
        echo ✅ Using ngrok URL: !NGROK_URL!
    )
)

echo 🔗 Testing webhook: !WEBHOOK_URL!
echo.

echo 📱 Testing WhatsApp User Registration Flow
echo ==========================================
echo.

REM Test 1: Valid registration
echo 1️⃣  Testing valid user registration...
echo    👤 User: João Silva
echo    📍 Address: Rua das Flores 123, Centro
echo    🏙️  City: São Paulo

set "reg_data=From=whatsapp:+5511999999999&Body=NOME: João Silva ENDERECO: Rua das Flores 123, Centro CIDADE: São Paulo&To=whatsapp:+14155238886"

echo    📤 Sending registration request...
curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "!reg_data!" !WEBHOOK_URL! > temp_response.txt
set reg_status=%errorlevel%

if exist temp_response.txt (
    echo    📥 Response received
    type temp_response.txt
    del temp_response.txt
) else (
    echo    ❌ No response received
)

echo.

REM Test 2: Check if user was created
echo 2️⃣  Checking if user was registered in database...
curl -s http://localhost:8080/api/usuarios > temp_users.json
if exist temp_users.json (
    findstr "João Silva" temp_users.json >nul
    if %errorlevel%==0 (
        echo    ✅ User found in database!
        echo    📋 User data:
        findstr "João Silva" temp_users.json
    ) else (
        echo    ⚠️  User not found in database
        echo    💾 Current users:
        type temp_users.json
    )
    del temp_users.json
) else (
    echo    ❌ Could not fetch users from database
)

echo.

REM Test 3: Invalid registration (missing fields)
echo 3️⃣  Testing invalid registration (missing city)...
set "invalid_data=From=whatsapp:+5511888888888&Body=NOME: Maria Silva ENDERECO: Rua das Palmeiras 456&To=whatsapp:+14155238886"

echo    📤 Sending invalid registration...
curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "!invalid_data!" !WEBHOOK_URL! > temp_invalid.txt

if exist temp_invalid.txt (
    echo    📥 Response:
    type temp_invalid.txt
    del temp_invalid.txt
)

echo.

REM Test 4: Registration with special characters
echo 4️⃣  Testing registration with special characters...
set "special_data=From=whatsapp:+5511777777777&Body=NOME: Pedro Santos ENDERECO: Avenida Paulista 1000 CIDADE: Sao Paulo&To=whatsapp:+14155238886"

echo    📤 Sending registration with special chars...
curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "!special_data!" !WEBHOOK_URL! > temp_special.txt

if exist temp_special.txt (
    echo    📥 Response:
    type temp_special.txt
    del temp_special.txt
)

echo.

REM Test 5: Fire report from registered user
echo 5️⃣  Testing fire report from registered user...
set "fire_data=From=whatsapp:+5511999999999&Body=Rua das Palmeiras 456, Centro, São Paulo&To=whatsapp:+14155238886"

echo    🔥 Sending fire report...
curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "!fire_data!" !WEBHOOK_URL! > temp_fire.txt

if exist temp_fire.txt (
    echo    📥 Response:
    type temp_fire.txt
    del temp_fire.txt
)

echo.

REM Check occurrences
echo 6️⃣  Checking fire occurrences in database...
curl -s http://localhost:8080/api/ocorrencias > temp_occur.json
if exist temp_occur.json (
    findstr "Palmeiras" temp_occur.json >nul
    if %errorlevel%==0 (
        echo    ✅ Fire occurrence found!
        echo    🔥 Occurrence data:
        findstr "Palmeiras" temp_occur.json
    ) else (
        echo    ⚠️  Fire occurrence not found
        echo    📋 Current occurrences:
        type temp_occur.json
    )
    del temp_occur.json
)

echo.
echo 📊 Test Summary
echo ==============
echo ✅ Registration flow tested
echo ✅ Database integration checked  
echo ✅ Fire reporting tested
echo ✅ Error handling tested

echo.
echo 🌐 Manual Testing Steps:
echo ======================
echo 1. Open WhatsApp and message: !NGROK_URL:http://localhost:8080!
echo 2. Send activation: "join pride-grandmother"
echo 3. Send registration: "NOME: Seu Nome ENDERECO: Seu Endereco CIDADE: Sua Cidade"
echo 4. Send fire report: "Rua Example 123, Centro, Cidade"
echo 5. Check frontend at http://localhost:3000

echo.
echo 🔍 Monitor real-time:
echo - Backend logs in console
echo - ngrok requests at http://localhost:4040
echo - Database at frontend dashboard

echo.
pause