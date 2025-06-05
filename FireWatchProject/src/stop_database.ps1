# 🔥 FireWatch - Stop Database Services (Windows)
# ===============================================

Write-Host "🔥 Stopping FireWatch Database Services..." -ForegroundColor Yellow
Write-Host ""

# Check if Docker is running
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Docker is not running or accessible" -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "⚠️  Docker is not running" -ForegroundColor Yellow
    exit 0
}

# Navigate to project root
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "🛑 Stopping database containers..." -ForegroundColor Cyan

# Stop database services
docker-compose stop firewatch-mysql firewatch-redis firewatch-adminer

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Database services stopped successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Show status
    Write-Host "📊 Container Status:" -ForegroundColor Cyan
    docker-compose ps firewatch-mysql firewatch-redis firewatch-adminer
    
    Write-Host ""
    Write-Host "🔧 Available commands:" -ForegroundColor Cyan
    Write-Host "   .\start_database.ps1    # Restart database services" -ForegroundColor Gray
    Write-Host "   docker-compose down     # Remove containers completely" -ForegroundColor Gray
    Write-Host ""
    
} else {
    Write-Host ""
    Write-Host "❌ Failed to stop some services!" -ForegroundColor Red
    Write-Host "🔍 Check running containers:" -ForegroundColor Yellow
    Write-Host "   docker ps" -ForegroundColor Gray
}

Write-Host "Press any key to continue..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")