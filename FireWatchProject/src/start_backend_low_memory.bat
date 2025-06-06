@echo off
chcp 65001 >nul

echo.
echo 🔥 Starting FireWatch Backend Service (Low Memory Mode)
echo ======================================================
echo.

REM Check if Java is available
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java not found! Please install Java 17+
    echo 📥 Download from: https://adoptium.net/
    pause
    exit /b 1
)

for /f "tokens=*" %%a in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    echo ✅ Java found: %%a
    goto java_found
)
:java_found

REM Navigate to backend directory
if not exist "backend" (
    echo ❌ Backend directory not found
    pause
    exit /b 1
)

cd backend
echo 📁 Working directory: %cd%

REM Check if Maven wrapper exists
if not exist "mvnw.cmd" (
    echo ❌ Maven wrapper (mvnw.cmd) not found!
    echo 💡 Make sure you're in the correct backend directory
    pause
    exit /b 1
)

echo 🔨 Building and starting Spring Boot application (Low Memory Mode)...
echo.

REM Check if database is running
echo 🔍 Checking database connection...
docker ps --filter "name=firewatch-mysql" --filter "status=running" --format "table {{.Names}}" | findstr "firewatch-mysql" >nul
if %errorlevel%==0 (
    echo ✅ MySQL container is running
) else (
    echo ⚠️  MySQL container not running. Starting database first...
    cd ..
    call start_database.bat
    cd backend
)

echo.
echo 🚀 Starting Spring Boot application in Low Memory Mode...
echo    ⚠️  This will use minimal memory settings for systems with limited RAM
echo    📊 Memory: 256MB heap, 128MB metaspace
echo    This may take a few minutes on first run...
echo.

REM Set low memory environment variables
set SPRING_PROFILES_ACTIVE=development
set MAVEN_OPTS=-Xmx256m -Xms128m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC -XX:+UseStringDeduplication

REM Additional JVM flags for low memory usage
set JAVA_OPTS=-server -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:+DisableExplicitGC

echo 💾 Memory settings applied:
echo    Heap: 256MB max, 128MB initial
echo    Metaspace: 128MB max
echo    GC: G1 with string deduplication
echo.

REM Start the application
mvnw.cmd spring-boot:run
if %errorlevel%==0 (
    echo ✅ Backend started successfully in low memory mode!
) else (
    echo.
    echo ❌ Failed to start backend service!
    echo.
    echo 📋 Troubleshooting:
    echo 1. Check if port 8080 is already in use:
    echo    netstat -an ^| findstr :8080
    echo.
    echo 2. Check database connection:
    echo    start_database.bat
    echo.
    echo 3. Check available memory:
    echo    Open Task Manager and check available RAM
    echo.
    echo 4. Try reducing memory further (edit this script):
    echo    Change -Xmx256m to -Xmx192m or -Xmx128m
    echo.
    echo 5. Clean and rebuild:
    echo    mvnw.cmd clean install
    echo.
    pause
)