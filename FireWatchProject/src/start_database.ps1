# 🔥 FireWatch - Start Database Services (Windows)
# ================================================

Write-Host "🔥 Starting FireWatch Database Services..." -ForegroundColor Yellow
Write-Host ""

# Check if Docker is running
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Docker not running"
    }
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running!" -ForegroundColor Red
    Write-Host "📥 Start Docker Desktop and try again" -ForegroundColor Yellow
    exit 1
}

Write-Host "🐳 Starting MySQL and Redis containers..." -ForegroundColor Cyan

# Navigate to project root
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Start only database services
docker-compose up -d firewatch-mysql firewatch-redis

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Database services started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Service Status:" -ForegroundColor Cyan
    Write-Host "==================" -ForegroundColor Cyan
    Write-Host "🗄️  MySQL:    localhost:3306" -ForegroundColor White
    Write-Host "🔴 Redis:     localhost:6379" -ForegroundColor White
    Write-Host "🔧 Adminer:   http://localhost:8081" -ForegroundColor White
    Write-Host ""
    Write-Host "🔑 Database Credentials:" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host "Database: firewatch" -ForegroundColor White
    Write-Host "Username: firewatch_user" -ForegroundColor White
    Write-Host "Password: firewatch_pass" -ForegroundColor White
    Write-Host ""
    Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
    
    # Wait for MySQL to be ready
    $maxAttempts = 30
    $attempt = 0
    do {
        $attempt++
        Write-Host "   Checking MySQL connection (attempt $attempt/$maxAttempts)..." -ForegroundColor Gray
        $result = docker exec firewatch-mysql mysqladmin ping -h localhost -u firewatch_user -pfirewatch_pass 2>$null
        if ($result -match "mysqld is alive") {
            Write-Host "✅ MySQL is ready!" -ForegroundColor Green
            break
        }
        Start-Sleep 2
    } while ($attempt -lt $maxAttempts)
    
    if ($attempt -ge $maxAttempts) {
        Write-Host "⚠️  MySQL took longer than expected to start" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "🚀 Next steps:" -ForegroundColor Cyan
    Write-Host "   .\start_backend.ps1   # Start Spring Boot API" -ForegroundColor Gray
    Write-Host "   .\start_frontend.ps1  # Start React frontend" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🛑 To stop database services:" -ForegroundColor Red
    Write-Host "   .\stop_database.ps1" -ForegroundColor Gray
    
} else {
    Write-Host ""
    Write-Host "❌ Failed to start database services!" -ForegroundColor Red
    Write-Host "🔍 Check Docker Desktop and try again" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 Troubleshooting:" -ForegroundColor Cyan
    Write-Host "   docker-compose logs firewatch-mysql" -ForegroundColor Gray
    Write-Host "   docker-compose logs firewatch-redis" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")