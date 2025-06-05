# 🔥 FireWatch - Start Backend Service (Windows)
# ==============================================

Write-Host "🔥 Starting FireWatch Backend Service..." -ForegroundColor Yellow
Write-Host ""

# Check if Java is available
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "✅ Java found: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java not found! Please install Java 17+" -ForegroundColor Red
    exit 1
}

# Navigate to backend directory
$backendPath = Join-Path $PSScriptRoot "backend"
if (!(Test-Path $backendPath)) {
    Write-Host "❌ Backend directory not found at: $backendPath" -ForegroundColor Red
    exit 1
}

Set-Location $backendPath
Write-Host "📁 Working directory: $backendPath" -ForegroundColor Cyan

# Check if Maven wrapper exists
if (!(Test-Path "mvnw.cmd")) {
    Write-Host "❌ Maven wrapper (mvnw.cmd) not found!" -ForegroundColor Red
    Write-Host "💡 Make sure you're in the correct backend directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "🔨 Building and starting Spring Boot application..." -ForegroundColor Cyan
Write-Host ""

# Check if database is running
Write-Host "🔍 Checking database connection..." -ForegroundColor Yellow
try {
    $mysqlCheck = docker ps --filter "name=firewatch-mysql" --filter "status=running" --format "table {{.Names}}"
    if ($mysqlCheck -match "firewatch-mysql") {
        Write-Host "✅ MySQL container is running" -ForegroundColor Green
    } else {
        Write-Host "⚠️  MySQL container not running. Starting database first..." -ForegroundColor Yellow
        Set-Location $PSScriptRoot
        .\start_database.ps1
        Set-Location $backendPath
    }
} catch {
    Write-Host "⚠️  Could not check MySQL status. Proceeding anyway..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🚀 Starting Spring Boot application..." -ForegroundColor Green
Write-Host "   This may take a few minutes on first run..." -ForegroundColor Gray
Write-Host ""

# Set environment variables for Windows
$env:SPRING_PROFILES_ACTIVE = "development"

# Start the application
try {
    .\mvnw.cmd spring-boot:run
} catch {
    Write-Host ""
    Write-Host "❌ Failed to start backend service!" -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 Troubleshooting:" -ForegroundColor Cyan
    Write-Host "1. Check if port 8080 is already in use:" -ForegroundColor Yellow
    Write-Host "   netstat -ano | findstr :8080" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Check database connection:" -ForegroundColor Yellow
    Write-Host "   .\start_database.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Check Java version:" -ForegroundColor Yellow
    Write-Host "   java -version" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Clean and rebuild:" -ForegroundColor Yellow
    Write-Host "   .\mvnw.cmd clean install" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}