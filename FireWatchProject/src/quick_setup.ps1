# 🔥 FireWatch - Quick Windows Setup Script
# =============================================

Write-Host "🔥 FireWatch - Quick Windows Setup Script" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

# Check if .env exists
if (!(Test-Path "../env")) {
    Write-Host "📝 Creating .env file from template..." -ForegroundColor Green
    if (Test-Path "../.env.example") {
        Copy-Item "../.env.example" "../env"
        Write-Host "✅ .env file created!" -ForegroundColor Green
    } else {
        Write-Host "❌ .env.example not found! Creating basic .env..." -ForegroundColor Red
        $envContent = @'
# Twilio Configuration
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886

# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=firewatch
DB_USERNAME=firewatch_user
DB_PASSWORD=firewatch_pass

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=firewatch123

# Application Configuration
SERVER_PORT=8080
REACT_APP_API_URL=http://localhost:8080/api
'@
        $envContent | Out-File -FilePath "../env" -Encoding UTF8
        Write-Host "✅ Basic .env file created!" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Edit .env file with your Twilio credentials:" -ForegroundColor Yellow
    Write-Host "   - TWILIO_ACCOUNT_SID" -ForegroundColor Yellow
    Write-Host "   - TWILIO_AUTH_TOKEN" -ForegroundColor Yellow
    Write-Host "   - TWILIO_WHATSAPP_FROM" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "✅ .env file already exists" -ForegroundColor Green
}

# Check if Docker Desktop is installed
try {
    $dockerVersion = docker --version 2>$null
    if ($dockerVersion) {
        Write-Host "✅ Docker is installed: $dockerVersion" -ForegroundColor Green
    } else {
        throw "Docker not found"
    }
} catch {
    Write-Host "❌ Docker Desktop not found!" -ForegroundColor Red
    Write-Host "📥 Install Docker Desktop from: https://docs.docker.com/desktop/install/windows/" -ForegroundColor Yellow
    Write-Host "   - Download Docker Desktop for Windows" -ForegroundColor Yellow
    Write-Host "   - Run installer as Administrator" -ForegroundColor Yellow
    Write-Host "   - Restart computer after installation" -ForegroundColor Yellow
    Write-Host ""
}

# Check if Docker Compose is available
try {
    $composeVersion = docker-compose --version 2>$null
    if ($composeVersion) {
        Write-Host "✅ Docker Compose is installed: $composeVersion" -ForegroundColor Green
    } else {
        throw "Docker Compose not found"
    }
} catch {
    Write-Host "❌ Docker Compose not found!" -ForegroundColor Red
    Write-Host "📥 Docker Compose comes with Docker Desktop" -ForegroundColor Yellow
}

# Check if Java is installed
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    if ($javaVersion) {
        Write-Host "✅ Java is installed: $javaVersion" -ForegroundColor Green
    } else {
        throw "Java not found"
    }
} catch {
    Write-Host "❌ Java not found!" -ForegroundColor Red
    Write-Host "📥 Install Java 17+ from:" -ForegroundColor Yellow
    Write-Host "   - https://adoptium.net/ (Recommended)" -ForegroundColor Yellow
    Write-Host "   - Or use: winget install EclipseAdoptium.Temurin.17.JDK" -ForegroundColor Yellow
    Write-Host ""
}

# Check if Node.js is installed
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host "✅ Node.js is installed: $nodeVersion" -ForegroundColor Green
    } else {
        throw "Node.js not found"
    }
} catch {
    Write-Host "❌ Node.js not found!" -ForegroundColor Red
    Write-Host "📥 Install Node.js 18+ from:" -ForegroundColor Yellow
    Write-Host "   - https://nodejs.org/ (Download LTS version)" -ForegroundColor Yellow
    Write-Host "   - Or use: winget install OpenJS.NodeJS" -ForegroundColor Yellow
    Write-Host ""
}

# Check if Python is installed
try {
    $pythonVersion = python --version 2>$null
    if ($pythonVersion) {
        Write-Host "✅ Python is installed: $pythonVersion" -ForegroundColor Green
    } else {
        throw "Python not found"
    }
} catch {
    Write-Host "❌ Python not found!" -ForegroundColor Red
    Write-Host "📥 Install Python 3.11+ from:" -ForegroundColor Yellow
    Write-Host "   - https://python.org/downloads/" -ForegroundColor Yellow
    Write-Host "   - Or use: winget install Python.Python.3.11" -ForegroundColor Yellow
    Write-Host ""
}

# Check if Git is installed
try {
    $gitVersion = git --version 2>$null
    if ($gitVersion) {
        Write-Host "✅ Git is installed: $gitVersion" -ForegroundColor Green
    } else {
        throw "Git not found"
    }
} catch {
    Write-Host "❌ Git not found!" -ForegroundColor Red
    Write-Host "📥 Install Git from:" -ForegroundColor Yellow
    Write-Host "   - https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "   - Or use: winget install Git.Git" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "🚀 Next Steps for Windows:" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 📝 Configure Twilio credentials in .env file:" -ForegroundColor White
Write-Host "   notepad ..\env" -ForegroundColor Gray
Write-Host ""
Write-Host "2. 🐳 Start with Docker (Recommended):" -ForegroundColor White
Write-Host "   cd ..; docker-compose up -d" -ForegroundColor Gray
Write-Host ""
Write-Host "3. 🌐 Or start services individually:" -ForegroundColor White
Write-Host "   .\start_database.ps1     # Start MySQL + Redis" -ForegroundColor Gray
Write-Host "   .\start_backend.ps1      # Start Spring Boot API" -ForegroundColor Gray
Write-Host "   .\start_frontend.ps1     # Start React app" -ForegroundColor Gray
Write-Host ""
Write-Host "4. 🔗 For WhatsApp integration:" -ForegroundColor White
Write-Host "   .\setup_whatsapp.ps1     # Setup ngrok + webhook" -ForegroundColor Gray
Write-Host ""
Write-Host "5. 🧪 Test the application:" -ForegroundColor White
Write-Host "   .\test_api.ps1           # Test API endpoints" -ForegroundColor Gray
Write-Host ""
Write-Host "6. 🌐 Access the application:" -ForegroundColor White
Write-Host "   - Frontend: http://localhost:3000" -ForegroundColor Gray
Write-Host "   - Backend API: http://localhost:8080" -ForegroundColor Gray
Write-Host "   - Database Admin: http://localhost:8081" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 For detailed instructions, see: documentation\README.md" -ForegroundColor Green
Write-Host ""
Write-Host "🆘 Need help? Check the troubleshooting section in documentation\" -ForegroundColor Yellow

# Pause to let user read the output
Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')