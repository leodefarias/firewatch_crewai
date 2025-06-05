# 🔥 FireWatch - Start Frontend Service (Windows)
# ===============================================

Write-Host "🔥 Starting FireWatch Frontend Service..." -ForegroundColor Yellow
Write-Host ""

# Check if Node.js is available
try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js/npm not found! Please install Node.js 18+" -ForegroundColor Red
    Write-Host "📥 Download from: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Navigate to frontend directory
$frontendPath = Join-Path $PSScriptRoot "frontend"
if (!(Test-Path $frontendPath)) {
    Write-Host "❌ Frontend directory not found at: $frontendPath" -ForegroundColor Red
    exit 1
}

Set-Location $frontendPath
Write-Host "📁 Working directory: $frontendPath" -ForegroundColor Cyan

# Check if package.json exists
if (!(Test-Path "package.json")) {
    Write-Host "❌ package.json not found!" -ForegroundColor Red
    Write-Host "💡 Make sure you're in the correct frontend directory" -ForegroundColor Yellow
    exit 1
}

# Install dependencies if node_modules doesn't exist
if (!(Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan
    Write-Host "   This may take a few minutes on first run..." -ForegroundColor Gray
    Write-Host ""
    
    try {
        npm install
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Dependencies installed successfully!" -ForegroundColor Green
        } else {
            throw "npm install failed"
        }
    } catch {
        Write-Host "❌ Failed to install dependencies!" -ForegroundColor Red
        Write-Host "🔍 Try running: npm install --verbose" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✅ Dependencies already installed" -ForegroundColor Green
}

# Check if backend is running
Write-Host ""
Write-Host "🔍 Checking backend API connection..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/health" -UseBasicParsing -TimeoutSec 5 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend API is running" -ForegroundColor Green
    } else {
        throw "Backend not responding"
    }
} catch {
    Write-Host "⚠️  Backend API not responding. Make sure to start backend first:" -ForegroundColor Yellow
    Write-Host "   .\start_backend.ps1" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🚀 Starting React development server..." -ForegroundColor Green
Write-Host ""
Write-Host "📊 Frontend will be available at:" -ForegroundColor Cyan
Write-Host "   http://localhost:3000" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Development server features:" -ForegroundColor Cyan
Write-Host "   ✨ Hot reload enabled" -ForegroundColor White
Write-Host "   🔍 Error overlay enabled" -ForegroundColor White
Write-Host "   📱 Mobile responsive" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  To stop the server, press Ctrl+C" -ForegroundColor Yellow
Write-Host ""

# Set environment variables
$env:REACT_APP_API_URL = "http://localhost:8080/api"
$env:BROWSER = "none"  # Prevent auto-opening browser

# Start the development server
try {
    npm start
} catch {
    Write-Host ""
    Write-Host "❌ Failed to start frontend service!" -ForegroundColor Red
    Write-Host ""
    Write-Host "📋 Troubleshooting:" -ForegroundColor Cyan
    Write-Host "1. Check if port 3000 is already in use:" -ForegroundColor Yellow
    Write-Host "   netstat -ano | findstr :3000" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Clear npm cache:" -ForegroundColor Yellow
    Write-Host "   npm cache clean --force" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Reinstall dependencies:" -ForegroundColor Yellow
    Write-Host "   Remove-Item node_modules -Recurse -Force" -ForegroundColor Gray
    Write-Host "   npm install" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Check Node.js version:" -ForegroundColor Yellow
    Write-Host "   node --version (should be 18+)" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}