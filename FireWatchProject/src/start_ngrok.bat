@echo off
chcp 65001 >nul

echo.
echo 🌐 Starting ngrok for FireWatch
echo ===============================
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
    echo    5. Run: ngrok config add-authtoken ^<your-auth-token^>
    echo.
    pause
    exit /b 1
)

echo ✅ ngrok is installed

REM Kill any existing ngrok processes
echo 🔄 Stopping any existing ngrok processes...
taskkill /F /IM ngrok.exe >nul 2>&1
timeout /t 2 >nul

echo 🚀 Starting ngrok tunnel for port 8080...
echo.
echo ⚠️  IMPORTANT: Keep this window open!
echo    The tunnel will remain active as long as this window is open.
echo.

REM Start ngrok and keep it running
ngrok http 8080

echo.
echo 🛑 ngrok tunnel stopped.
pause