@echo off
chcp 65001 >nul
title FireWatch - API Test

echo.
echo 🔥 FireWatch - Testing API Endpoints...
echo =======================================
echo.

set baseUrl=http://localhost:8080/api

REM Check if backend is running
echo 🔍 Checking if backend is running...
curl -s %baseUrl%/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Backend is not running!
    echo 🚀 Start backend first:
    echo    start_backend.bat
    echo.
    pause
    exit /b 1
)
echo ✅ Backend is responding!

echo.
echo 🚀 Starting API tests...
echo.

REM Test basic endpoints
echo 🧪 Testing: Health Check
curl -s %baseUrl%/health
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get All Cities
curl -s %baseUrl%/cidades >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get All Users
curl -s %baseUrl%/usuarios >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get All Teams
curl -s %baseUrl%/equipes >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get All Incidents
curl -s %baseUrl%/ocorrencias >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get All Notifications
curl -s %baseUrl%/notificacoes >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

REM Test creating a new incident
echo 🧪 Testing: Create New Incident
curl -s -X POST -H "Content-Type: application/json" -d "{\"latitude\":-23.5505,\"longitude\":-46.6333,\"descricao\":\"Test incident from API test script\",\"severidade\":5,\"usuarioId\":1}" %baseUrl%/ocorrencias >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

REM Test individual record retrieval
echo 🧪 Testing: Get Incident #1
curl -s %baseUrl%/ocorrencias/1 >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get User #1
curl -s %baseUrl%/usuarios/1 >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 🧪 Testing: Get City #1
curl -s %baseUrl%/cidades/1 >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

REM Test WhatsApp webhook
echo 🧪 Testing: WhatsApp Webhook
curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "From=whatsapp:+5511999999999&Body=Test message&Latitude=-23.5505&Longitude=-46.6333" %baseUrl%/webhook/whatsapp >nul
if %errorlevel% equ 0 (
    echo    ✅ SUCCESS
) else (
    echo    ❌ FAILED
)
echo.

echo 📊 API Tests Completed!
echo.
echo 🔍 Additional checks:
echo    🌐 Frontend: http://localhost:3000
echo    🗄️  Database: http://localhost:8081 (Adminer)
echo    📊 API Docs: %baseUrl%/swagger-ui.html
echo.

pause