@echo off
chcp 65001 >nul

echo.
echo 🛑 Stopping ngrok
echo ================
echo.

REM Kill all ngrok processes
echo 🔄 Stopping ngrok processes...
taskkill /F /IM ngrok.exe >nul 2>&1

if %errorlevel%==0 (
    echo ✅ ngrok stopped successfully
) else (
    echo ⚠️  ngrok was not running or failed to stop
)

REM Clean up log file if it exists
if exist "ngrok.log" (
    del ngrok.log >nul 2>&1
    echo 🧹 Cleaned up ngrok.log
)

echo.
echo 📝 Note: If you had configured Twilio webhook with ngrok URL,
echo    you'll need to start ngrok again and update the webhook URL
echo    when you restart the system.
echo.
echo 🚀 To restart ngrok:
echo    start_ngrok.bat
echo.

pause