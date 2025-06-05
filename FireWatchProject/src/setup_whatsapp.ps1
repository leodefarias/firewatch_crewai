# 🔥 FireWatch - WhatsApp Setup Script (Windows)
# ===============================================

Write-Host "🔥 FireWatch - WhatsApp Integration Setup" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

# Check if .env file exists
if (!(Test-Path "../.env")) {
    Write-Host "❌ .env file not found!" -ForegroundColor Red
    Write-Host "📝 Run .\quick_setup.ps1 first to create .env file" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found .env file" -ForegroundColor Green

# Check if ngrok is installed
try {
    $ngrokVersion = ngrok version 2>$null
    if ($ngrokVersion) {
        Write-Host "✅ ngrok is installed: $ngrokVersion" -ForegroundColor Green
    } else {
        throw "ngrok not found"
    }
} catch {
    Write-Host "❌ ngrok not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Install ngrok for Windows:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://ngrok.com/download" -ForegroundColor Gray
    Write-Host "2. Extract ngrok.exe to a folder in your PATH" -ForegroundColor Gray
    Write-Host "3. Or use chocolatey: choco install ngrok" -ForegroundColor Gray
    Write-Host "4. Or use winget: winget install ngrok.ngrok" -ForegroundColor Gray
    Write-Host ""
    Write-Host "⚠️  You'll also need to create a free ngrok account and run:" -ForegroundColor Yellow
    Write-Host "   ngrok config add-authtoken YOUR_TOKEN" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

# Check if backend is running
Write-Host ""
Write-Host "🔍 Checking if backend is running..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/health" -UseBasicParsing -TimeoutSec 5 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend is running on port 8080" -ForegroundColor Green
    } else {
        throw "Backend not responding"
    }
} catch {
    Write-Host "❌ Backend is not running!" -ForegroundColor Red
    Write-Host "🚀 Start backend first:" -ForegroundColor Yellow
    Write-Host "   .\start_backend.ps1" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Do you want to continue anyway? (y/n)"
    if ($choice -ne "y" -and $choice -ne "Y") {
        exit 1
    }
}

# Read .env file to check Twilio configuration
Write-Host ""
Write-Host "🔍 Checking Twilio configuration..." -ForegroundColor Cyan
$envContent = Get-Content "../.env" -Raw
$hasAccountSid = $envContent -match "TWILIO_ACCOUNT_SID=(?!your_account_sid_here)(.+)"
$hasAuthToken = $envContent -match "TWILIO_AUTH_TOKEN=(?!your_auth_token_here)(.+)"
$hasWhatsAppFrom = $envContent -match "TWILIO_WHATSAPP_FROM=(.+)"

if ($hasAccountSid -and $hasAuthToken -and $hasWhatsAppFrom) {
    Write-Host "✅ Twilio credentials found in .env" -ForegroundColor Green
} else {
    Write-Host "⚠️  Twilio credentials not properly configured!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📝 Please edit .env file with your Twilio credentials:" -ForegroundColor Yellow
    Write-Host "   notepad ..\.env" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🔑 You need:" -ForegroundColor Cyan
    Write-Host "   - TWILIO_ACCOUNT_SID (from Twilio Console)" -ForegroundColor Gray
    Write-Host "   - TWILIO_AUTH_TOKEN (from Twilio Console)" -ForegroundColor Gray
    Write-Host "   - TWILIO_WHATSAPP_FROM (e.g., whatsapp:+14155238886)" -ForegroundColor Gray
    Write-Host ""
    
    $choice = Read-Host "Do you want to open .env file now? (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        notepad "../.env"
        Write-Host "Press any key after saving .env file..." -ForegroundColor DarkGray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

Write-Host ""
Write-Host "🌐 Starting ngrok tunnel..." -ForegroundColor Cyan
Write-Host ""

# Start ngrok in background and capture the URL
Write-Host "⏳ Starting ngrok tunnel for port 8080..." -ForegroundColor Yellow
$ngrokJob = Start-Job -ScriptBlock {
    ngrok http 8080 --log=stdout
}

# Wait a bit for ngrok to start
Start-Sleep 5

# Get the public URL from ngrok API
try {
    $ngrokApi = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -UseBasicParsing
    $publicUrl = $ngrokApi.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1 -ExpandProperty public_url
    
    if ($publicUrl) {
        Write-Host "✅ ngrok tunnel created successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 Your public URL:" -ForegroundColor Cyan
        Write-Host "   $publicUrl" -ForegroundColor White
        Write-Host ""
        Write-Host "📱 Webhook URL for Twilio:" -ForegroundColor Cyan
        Write-Host "   $publicUrl/api/webhook/whatsapp" -ForegroundColor White
        Write-Host ""
        
        # Copy webhook URL to clipboard if possible
        try {
            "$publicUrl/api/webhook/whatsapp" | Set-Clipboard
            Write-Host "📋 Webhook URL copied to clipboard!" -ForegroundColor Green
        } catch {
            Write-Host "📋 Please copy the webhook URL manually" -ForegroundColor Yellow
        }
        
        Write-Host ""
        Write-Host "⚙️  Next steps for Twilio configuration:" -ForegroundColor Cyan
        Write-Host "=======================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. 🌐 Go to Twilio Console: https://console.twilio.com/" -ForegroundColor White
        Write-Host ""
        Write-Host "2. 📱 Navigate to: Messaging > Try it out > Send a WhatsApp message" -ForegroundColor White
        Write-Host ""
        Write-Host "3. 🔧 Configure Sandbox Settings:" -ForegroundColor White
        Write-Host "   - Webhook URL: $publicUrl/api/webhook/whatsapp" -ForegroundColor Gray
        Write-Host "   - HTTP Method: POST" -ForegroundColor Gray
        Write-Host "   - Events: Incoming Messages" -ForegroundColor Gray
        Write-Host ""
        Write-Host "4. 📲 Join WhatsApp Sandbox:" -ForegroundColor White
        Write-Host "   - Send 'join <sandbox-keyword>' to +1 415 523 8886" -ForegroundColor Gray
        Write-Host "   - Example: 'join yellow-dog'" -ForegroundColor Gray
        Write-Host ""
        Write-Host "5. 🧪 Test by sending a location or coordinates:" -ForegroundColor White
        Write-Host "   - Send your location via WhatsApp" -ForegroundColor Gray
        Write-Host "   - Or send: 'Incêndio! Lat: -23.5505, Long: -46.6333'" -ForegroundColor Gray
        Write-Host ""
        Write-Host "🔍 Monitor webhook calls:" -ForegroundColor Cyan
        Write-Host "   - ngrok dashboard: http://localhost:4040" -ForegroundColor Gray
        Write-Host "   - Backend logs: Check console where backend is running" -ForegroundColor Gray
        Write-Host ""
        Write-Host "⚠️  Keep this window open to maintain the tunnel!" -ForegroundColor Yellow
        Write-Host "   Press Ctrl+C to stop ngrok when done" -ForegroundColor Red
        Write-Host ""
        
        # Wait for user input or job completion
        Write-Host "Press any key to stop ngrok tunnel..." -ForegroundColor DarkGray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
    } else {
        throw "Could not get public URL from ngrok"
    }
} catch {
    Write-Host "❌ Failed to get ngrok tunnel information!" -ForegroundColor Red
    Write-Host "🔍 Check if ngrok started correctly:" -ForegroundColor Yellow
    Write-Host "   - Visit http://localhost:4040 for ngrok dashboard" -ForegroundColor Gray
    Write-Host "   - Check if port 8080 is available" -ForegroundColor Gray
}

# Clean up
if ($ngrokJob) {
    Write-Host ""
    Write-Host "🛑 Stopping ngrok tunnel..." -ForegroundColor Yellow
    Stop-Job $ngrokJob -PassThru | Remove-Job
}

Write-Host ""
Write-Host "✅ WhatsApp setup script completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📚 For more detailed instructions, see:" -ForegroundColor Cyan
Write-Host "   documentation\SETUP_WHATSAPP.md" -ForegroundColor Gray