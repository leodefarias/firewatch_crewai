@echo off
chcp 65001 >nul
cls

echo 🔥 FireWatch Complete Startup Script
echo ====================================
echo.

REM Function to check if a port is in use
:check_port
netstat -an | find ":%1 " | find "LISTENING" >nul
exit /b

REM Function to kill processes on a specific port
:kill_port
echo 🔄 Stopping any existing processes on port %1...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":%1" ^| find "LISTENING"') do (
    if not "%%a"=="0" (
        taskkill /F /PID %%a >nul 2>&1
    )
)
timeout /t 2 >nul
exit /b

REM Function to start backend
:start_backend
echo 🚀 Starting Backend...
echo ---------------------
echo.

REM Kill any existing backend process
call :kill_port 8080

cd backend

REM Check if Docker is available and Dockerfile exists
where docker >nul 2>&1
if %errorlevel%==0 (
    if exist "Dockerfile" (
        echo 🐳 Using Docker to run backend...
        docker build -t firewatch-backend . >nul 2>&1
        docker run -d -p 8080:8080 --name firewatch-backend-dev --rm firewatch-backend >nul 2>&1
    ) else (
        goto maven_start
    )
) else (
    :maven_start
    if exist "mvnw.cmd" (
        echo ☕ Using Maven wrapper to run backend...
        start /b mvnw.cmd spring-boot:run >backend.log 2>&1
    ) else (
        echo ❌ Neither Docker nor Maven wrapper found!
        pause
        exit /b 1
    )
)

REM Wait for backend to start
echo ⏳ Waiting for backend to start on port 8080...
:wait_backend
call :check_port 8080
if %errorlevel%==0 (
    echo.
    echo ✅ Backend started successfully on http://localhost:8080
    cd ..
    exit /b 0
) else (
    timeout /t 2 >nul
    echo|set /p="."
    goto wait_backend
)

REM Function to start ngrok
:start_ngrok
echo.
echo 🌐 Starting ngrok...
echo ------------------

where ngrok >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ngrok not found! Please install ngrok:
    echo    1. Download from https://ngrok.com/download
    echo    2. Extract to a folder in PATH
    echo    3. Run: ngrok authtoken ^<your-auth-token^>
    exit /b 1
)

REM Kill any existing ngrok process
taskkill /F /IM ngrok.exe >nul 2>&1
timeout /t 2 >nul

echo 🚀 Starting ngrok tunnel for backend (port 8080)...
start /b ngrok http 8080 --log=stdout >ngrok.log 2>&1

REM Wait for ngrok to start
echo ⏳ Waiting for ngrok to establish tunnel...
timeout /t 5 >nul

where curl >nul 2>&1
if %errorlevel%==0 (
    where jq >nul 2>&1
    if %errorlevel%==0 (
        for /f "delims=" %%i in ('curl -s http://localhost:4040/api/tunnels ^| jq -r ".tunnels[0].public_url" 2^>nul') do set NGROK_URL=%%i
        if not "!NGROK_URL!"=="null" if not "!NGROK_URL!"=="" (
            echo ✅ ngrok tunnel established: !NGROK_URL!
            echo 📝 Use this URL for Twilio webhook configuration
        ) else (
            echo ⚠️  ngrok started but couldn't retrieve public URL
            echo    Check ngrok dashboard at http://localhost:4040
        )
    ) else (
        echo ✅ ngrok started - check dashboard at http://localhost:4040 for public URL
    )
) else (
    echo ✅ ngrok started - check dashboard at http://localhost:4040 for public URL
)
exit /b 0

REM Function to start frontend
:start_frontend
echo.
echo ⚛️  Starting Frontend...
echo ----------------------

cd frontend

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm not found! Please install Node.js and npm
    pause
    exit /b 1
)

REM Kill any existing frontend process
call :kill_port 3000

echo 📦 Installing dependencies...
npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install frontend dependencies
    pause
    exit /b 1
)

echo 🚀 Starting React development server...
start /b npm start

REM Wait for frontend to start
echo ⏳ Waiting for frontend to start on port 3000...
:wait_frontend
call :check_port 3000
if %errorlevel%==0 (
    echo.
    echo ✅ Frontend started successfully on http://localhost:3000
    cd ..
    exit /b 0
) else (
    timeout /t 2 >nul
    echo|set /p="."
    goto wait_frontend
)

REM Function to show final status
:show_status
echo.
echo 🎉 FireWatch System Status
echo =========================
echo 🔧 Backend:   http://localhost:8080
echo ⚛️  Frontend:  http://localhost:3000
where curl >nul 2>&1
if %errorlevel%==0 (
    where jq >nul 2>&1
    if %errorlevel%==0 (
        for /f "delims=" %%i in ('curl -s http://localhost:4040/api/tunnels ^| jq -r ".tunnels[0].public_url" 2^>nul') do set NGROK_URL=%%i
        if not "!NGROK_URL!"=="null" if not "!NGROK_URL!"=="" (
            echo 🌐 ngrok:     !NGROK_URL!
        )
    )
)
echo 📊 ngrok UI:  http://localhost:4040
echo.
echo 📝 Next steps:
echo    1. Configure Twilio webhook with the ngrok URL + '/api/webhook/whatsapp'
echo    2. Access the frontend to manage the system
echo    3. Test WhatsApp integration
echo.
echo 🛑 To stop all services, press Ctrl+C and run:
echo    stop_firewatch.bat
exit /b 0

REM Main execution
setlocal enabledelayedexpansion

echo 🔍 Checking prerequisites...
echo.

REM Check if we're in the right directory
if not exist "backend" (
    echo ❌ Error: Run this script from the FireWatchProject root directory
    echo    Current directory should contain 'backend' and 'frontend' folders
    pause
    exit /b 1
)
if not exist "frontend" (
    echo ❌ Error: Run this script from the FireWatchProject root directory
    echo    Current directory should contain 'backend' and 'frontend' folders
    pause
    exit /b 1
)

REM Start all services
call :start_backend
call :start_ngrok
call :start_frontend
call :show_status

REM Keep script running
echo 🔄 Services running... Press Ctrl+C to stop all services
:monitor_loop
timeout /t 10 >nul

REM Check if services are still running
call :check_port 8080
if %errorlevel% neq 0 (
    echo ⚠️  Backend stopped unexpectedly
    goto cleanup
)

call :check_port 3000
if %errorlevel% neq 0 (
    echo ⚠️  Frontend stopped unexpectedly
    goto cleanup
)

goto monitor_loop

:cleanup
echo.
echo 🛑 Shutting down FireWatch services...
call :kill_port 8080
call :kill_port 3000
taskkill /F /IM ngrok.exe >nul 2>&1
docker stop firewatch-backend-dev >nul 2>&1
echo ✅ All services stopped
pause
exit /b 0