@echo off
chcp 65001 >nul

echo.
echo 🧪 FireWatch API Testing Script
echo ===============================
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
echo 🔍 Checking if backend API is accessible...
curl -s http://localhost:8080/api/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Backend API is not responding on http://localhost:8080
    echo.
    echo 📝 Please ensure the backend is running:
    echo    start_backend.bat
    echo.
    echo    Or start all services:
    echo    start_firewatch.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Backend API is responding

echo.
echo 🚀 Starting API Tests...
echo ========================
echo.

REM Test 1: Health Check
echo 1️⃣  Testing Health Check...
echo    GET /api/health
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/health') do set health_status=%%i
if "!health_status!"=="200" (
    echo    ✅ Health check passed (Status: !health_status!)
) else (
    echo    ❌ Health check failed (Status: !health_status!)
)
echo.

REM Test 2: Get all cities
echo 2️⃣  Testing Cities Endpoint...
echo    GET /api/cidades
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/cidades') do set cities_status=%%i
if "!cities_status!"=="200" (
    echo    ✅ Cities endpoint working (Status: !cities_status!)
    curl -s http://localhost:8080/api/cidades | head -c 200
    echo    ...
) else (
    echo    ❌ Cities endpoint failed (Status: !cities_status!)
)
echo.

REM Test 3: Get all users
echo 3️⃣  Testing Users Endpoint...
echo    GET /api/usuarios
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/usuarios') do set users_status=%%i
if "!users_status!"=="200" (
    echo    ✅ Users endpoint working (Status: !users_status!)
    curl -s http://localhost:8080/api/usuarios | head -c 200
    echo    ...
) else (
    echo    ❌ Users endpoint failed (Status: !users_status!)
)
echo.

REM Test 4: Get all teams
echo 4️⃣  Testing Teams Endpoint...
echo    GET /api/equipes
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/equipes') do set teams_status=%%i
if "!teams_status!"=="200" (
    echo    ✅ Teams endpoint working (Status: !teams_status!)
    curl -s http://localhost:8080/api/equipes | head -c 200
    echo    ...
) else (
    echo    ❌ Teams endpoint failed (Status: !teams_status!)
)
echo.

REM Test 5: Get all occurrences
echo 5️⃣  Testing Occurrences Endpoint...
echo    GET /api/ocorrencias
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/ocorrencias') do set occurrences_status=%%i
if "!occurrences_status!"=="200" (
    echo    ✅ Occurrences endpoint working (Status: !occurrences_status!)
    curl -s http://localhost:8080/api/ocorrencias | head -c 200
    echo    ...
) else (
    echo    ❌ Occurrences endpoint failed (Status: !occurrences_status!)
)
echo.

REM Test 6: Test webhook endpoint
echo 6️⃣  Testing WhatsApp Webhook...
echo    POST /api/webhook/whatsapp
for /f "delims=" %%i in ('curl -s -o nul -w "%%{http_code}" -X POST -H "Content-Type: application/json" -d "{\"test\": \"data\"}" http://localhost:8080/api/webhook/whatsapp') do set webhook_status=%%i
if "!webhook_status!"=="200" (
    echo    ✅ Webhook endpoint accessible (Status: !webhook_status!)
) else (
    echo    ⚠️  Webhook endpoint status: !webhook_status! (may be expected if no valid data)
)
echo.

REM Test 7: Test database connection
echo 7️⃣  Testing Database Connection...
echo    Checking if sample data is loaded...
curl -s http://localhost:8080/api/cidades > temp_cities.json 2>nul
if exist temp_cities.json (
    find "[]" temp_cities.json >nul
    if %errorlevel%==0 (
        echo    ⚠️  No cities found - database may be empty
        echo    💡 Check if initial data is loaded
    ) else (
        echo    ✅ Database contains data
    )
    del temp_cities.json
) else (
    echo    ❌ Could not fetch cities data
)
echo.

REM Summary
echo 📊 Test Summary:
echo ===============
set passed=0
set total=6

if "!health_status!"=="200" set /a passed+=1
if "!cities_status!"=="200" set /a passed+=1
if "!users_status!"=="200" set /a passed+=1
if "!teams_status!"=="200" set /a passed+=1
if "!occurrences_status!"=="200" set /a passed+=1
if "!webhook_status!"=="200" set /a passed+=1

echo ✅ Passed: !passed!/!total! tests
echo.

if !passed!==!total! (
    echo 🎉 All API tests passed! Your FireWatch backend is working correctly.
) else (
    echo ⚠️  Some tests failed. Check the individual test results above.
    echo.
    echo 🔍 Troubleshooting:
    echo    1. Ensure database is running: start_database.bat
    echo    2. Check backend logs for errors
    echo    3. Verify .env configuration
)

echo.
echo 🌐 Next steps:
echo    - Access frontend: http://localhost:3000
echo    - Test WhatsApp integration: setup_whatsapp.bat
echo    - View API documentation: http://localhost:8080/swagger-ui.html
echo.

pause