@echo off
chcp 65001 >nul

echo.
echo 🛑 Stopping FireWatch Services...
echo ===============================
echo.

REM Function to kill processes on a specific port
:kill_port
echo 🔄 Stopping processes on port %1...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":%1" ^| find "LISTENING"') do (
    if not "%%a"=="0" (
        taskkill /F /PID %%a >nul 2>&1
        echo    ✅ Stopped process on port %1
    )
)
exit /b

echo 🔄 Stopping Backend (port 8080)...
call :kill_port 8080

echo 🔄 Stopping Frontend (port 3000)...
call :kill_port 3000

echo 🔄 Stopping ngrok...
taskkill /F /IM ngrok.exe >nul 2>&1
if %errorlevel%==0 (
    echo    ✅ ngrok stopped
) else (
    echo    ⚠️  ngrok was not running
)

echo 🔄 Stopping Docker containers...
docker stop firewatch-backend-dev >nul 2>&1
if %errorlevel%==0 (
    echo    ✅ Docker backend container stopped
) else (
    echo    ⚠️  Docker backend container was not running
)

REM Check if user wants to stop database services too
echo.
set /p choice="🔍 Do you want to stop database services too? (Y/N): "
if /i "%choice%"=="Y" (
    echo 🔄 Stopping database services...
    docker-compose down >nul 2>&1
    if %errorlevel%==0 (
        echo    ✅ Database services stopped
    ) else (
        echo    ⚠️  Database services were not running or failed to stop
    )
) else (
    echo    ⚠️  Database services left running
)

echo.
echo ✅ FireWatch services shutdown complete!
echo.
pause