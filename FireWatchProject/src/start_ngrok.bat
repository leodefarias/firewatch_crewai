@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "NGROK_LOG=%TEMP%\ngrok.log"
set "NGROK_PID=%TEMP%\ngrok.pid"

echo 🌐 Starting ngrok for FireWatch...
echo.

REM Check if ngrok is already running
if exist "%NGROK_PID%" (
    set /p pid=<"%NGROK_PID%"
    tasklist /FI "PID eq !pid!" 2>nul | find /I "ngrok.exe" >nul
    if !errorlevel! equ 0 (
        echo ⚠️  ngrok is already running!
        echo 🔗 Current URL:
        
        REM Try to get current URL
        powershell -Command "try { (Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -ErrorAction Stop).tunnels | Where-Object { $_.proto -eq 'https' } | Select-Object -First 1 -ExpandProperty public_url } catch { 'Unable to get URL - check http://localhost:4040' }"
        
        echo.
        echo 🔧 To stop: call stop_ngrok.bat
        pause
        exit /b 0
    )
)

REM Start ngrok in background
echo 🚀 Starting ngrok tunnel for port 8080...

REM Kill any existing ngrok processes first
taskkill /F /IM ngrok.exe >nul 2>&1

REM Start ngrok in background and save PID
start /B ngrok http 8080 >"%NGROK_LOG%" 2>&1

REM Get the PID of ngrok process
timeout /t 2 >nul
for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq ngrok.exe" /FO LIST ^| find "PID:"') do (
    echo %%i > "%NGROK_PID%"
    goto :found_pid
)

:found_pid
echo 🔍 Getting tunnel URL...
timeout /t 3 >nul

set "NGROK_URL="
set "attempts=0"

:get_url_loop
set /a attempts+=1
if %attempts% gtr 10 goto :url_failed

echo    Waiting for ngrok... (%attempts%/10)

REM Try to get URL using PowerShell
for /f "delims=" %%i in ('powershell -Command "try { (Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -ErrorAction Stop).tunnels | Where-Object { $_.proto -eq 'https' } | Select-Object -First 1 -ExpandProperty public_url } catch { '' }"') do (
    set "NGROK_URL=%%i"
)

if "!NGROK_URL!"=="" (
    timeout /t 2 >nul
    goto :get_url_loop
)

REM Success - display information
echo.
echo ✅ ngrok started successfully!
echo.
echo 🔗 Your public URL:
echo    !NGROK_URL!
echo.
echo 📱 Webhook URL for Twilio:
echo    !NGROK_URL!/api/webhook/whatsapp
echo.

REM Try to copy webhook URL to clipboard
echo !NGROK_URL!/api/webhook/whatsapp | clip
if !errorlevel! equ 0 (
    echo 📋 Webhook URL copied to clipboard!
    echo.
)

echo 🔧 Management:
echo    View dashboard: http://localhost:4040
echo    Stop ngrok: call stop_ngrok.bat
echo    View logs: type "%NGROK_LOG%"
echo.
echo ⚠️  Remember to update Twilio webhook URL:
echo    https://console.twilio.com → Messaging → WhatsApp Sandbox
echo.
echo ✨ ngrok is running in background. Close this window safely.
echo.
pause
exit /b 0

:url_failed
echo ❌ Failed to get ngrok URL!
echo 📝 Check logs: type "%NGROK_LOG%"
echo 🌐 Try accessing: http://localhost:4040
echo.

REM Clean up on failure
if exist "%NGROK_PID%" (
    set /p pid=<"%NGROK_PID%"
    taskkill /F /PID !pid! >nul 2>&1
    del "%NGROK_PID%"
)

pause
exit /b 1