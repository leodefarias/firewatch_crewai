@echo off
chcp 65001 >nul

echo.
echo 🔥 Starting FireWatch Backend Service...
echo.

REM Check if Java is available
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java not found! Please install Java 17+
    echo 📥 Download from: https://adoptium.net/
    pause
    exit /b 1
)

REM Get Java version
echo ✅ Java found:
java -version
echo.

REM Navigate to backend directory
if not exist "backend" (
    echo ❌ Backend directory not found
    echo 💡 Current directory: %cd%
    pause
    exit /b 1
)

cd backend
echo 📁 Working directory: %cd%

REM Check what files exist in backend directory
echo 📂 Backend directory contents:
dir /b
echo.

REM Check if Maven wrapper exists (try both .cmd and .bat extensions)
if exist "mvnw.cmd" (
    set MAVEN_WRAPPER=mvnw.cmd
    echo ✅ Found Maven wrapper: mvnw.cmd
) else if exist "mvnw.bat" (
    set MAVEN_WRAPPER=mvnw.bat
    echo ✅ Found Maven wrapper: mvnw.bat
) else if exist "mvnw" (
    set MAVEN_WRAPPER=mvnw
    echo ✅ Found Maven wrapper: mvnw
) else (
    echo ❌ Maven wrapper not found!
    echo 💡 Looking for: mvnw.cmd, mvnw.bat, or mvnw
    echo 📂 Current directory contents:
    dir
    echo.
    echo 🔧 Possible solutions:
    echo 1. Run 'mvn wrapper:wrapper' to generate Maven wrapper
    echo 2. Use Maven directly: 'mvn spring-boot:run'
    echo 3. Check if you're in the correct directory
    pause
    
    REM Try to use Maven directly if available
    where mvn >nul 2>&1
    if %errorlevel% equ 0 (
        echo 💡 Found Maven installation, using 'mvn' instead
        set MAVEN_WRAPPER=mvn
    ) else (
        echo ❌ Maven not found either. Please install Maven or generate wrapper.
        pause
        exit /b 1
    )
)

echo 🔨 Building and starting Spring Boot application...
echo.

REM Check if Docker is running and database status
echo 🔍 Checking Docker and database status...
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Docker Desktop is not running!
    echo 🐳 Please start Docker Desktop first
    echo.
    echo 💡 Options:
    echo    1. Start Docker Desktop manually
    echo    2. Continue without database ^(may cause errors^)
    echo    3. Exit and start Docker first
    echo.
    choice /c 123 /m "Choose option"
    if %errorlevel% equ 1 (
        echo 🔄 Waiting for you to start Docker Desktop...
        echo    Press any key when Docker is ready...
        pause >nul
    ) else if %errorlevel% equ 3 (
        echo 👋 Exiting. Please start Docker Desktop and run again.
        pause
        exit /b 1
    )
    echo ⚠️  Continuing without database verification...
) else (
    docker ps --filter "name=firewatch-mysql" --filter "status=running" --format "table {{.Names}}" 2>nul | findstr "firewatch-mysql" >nul
    if %errorlevel% equ 0 (
        echo ✅ MySQL container is running
    ) else (
        echo ⚠️  MySQL container not running. Starting database first...
        cd ..
        if exist "start_database.bat" (
            call start_database.bat
        ) else (
            echo ❌ start_database.bat not found!
            echo 💡 Please start the database manually first
        )
        cd backend
    )
)

echo.
echo 🚀 Starting Spring Boot application...
echo    This may take a few minutes on first run...
echo.

REM Set environment variables
set SPRING_PROFILES_ACTIVE=development
set MAVEN_OPTS=-Xmx512m -Xms256m -XX:MaxMetaspaceSize=128m

echo 🔧 Environment:
echo    SPRING_PROFILES_ACTIVE=%SPRING_PROFILES_ACTIVE%
echo    MAVEN_OPTS=%MAVEN_OPTS%
echo.

REM Start the application
echo 📦 Running: %MAVEN_WRAPPER% spring-boot:run
echo.
%MAVEN_WRAPPER% spring-boot:run
set backend_exit_code=%errorlevel%

if %backend_exit_code% equ 0 (
    echo.
    echo ✅ Backend started successfully!
) else (
    echo.
    echo ❌ Failed to start backend service! ^(Exit code: %backend_exit_code%^)
    echo.
    echo 📋 Troubleshooting:
    echo 1. Check if port 8080 is already in use:
    echo    netstat -an ^| findstr :8080
    echo.
    echo 2. Check database connection:
    echo    start_database.bat
    echo.
    echo 3. Check Java version ^(needs Java 17+^):
    echo    java -version
    echo.
    echo 4. Clean and rebuild:
    echo    %MAVEN_WRAPPER% clean install
    echo.
    echo 5. Check Maven wrapper permissions:
    echo    dir %MAVEN_WRAPPER%
    echo.
    echo 6. Try manual Maven command:
    echo    %MAVEN_WRAPPER% clean compile
    echo.
    pause
)

echo.
echo 🏁 Script finished.
pause