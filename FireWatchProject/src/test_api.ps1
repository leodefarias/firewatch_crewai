# 🔥 FireWatch - API Test Script (Windows)
# =========================================

Write-Host "🔥 FireWatch - Testing API Endpoints..." -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Yellow
Write-Host ""

$baseUrl = "http://localhost:8080/api"
$testResults = @()

# Function to test an endpoint
function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Body = $null
    )
    
    Write-Host "🧪 Testing: $Name" -ForegroundColor Cyan
    Write-Host "   URL: $Url" -ForegroundColor Gray
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            UseBasicParsing = $true
            TimeoutSec = 10
        }
        
        if ($Body) {
            $params.Body = ($Body | ConvertTo-Json)
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-WebRequest @params
        
        if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300) {
            Write-Host "   ✅ SUCCESS (Status: $($response.StatusCode))" -ForegroundColor Green
            
            # Try to parse JSON response
            try {
                $jsonResponse = $response.Content | ConvertFrom-Json
                if ($jsonResponse -is [array]) {
                    Write-Host "   📊 Returned $($jsonResponse.Count) items" -ForegroundColor White
                } elseif ($jsonResponse.PSObject.Properties.Count -gt 0) {
                    Write-Host "   📄 Returned object with $($jsonResponse.PSObject.Properties.Count) properties" -ForegroundColor White
                }
            } catch {
                Write-Host "   📄 Response: $($response.Content.Substring(0, [Math]::Min(100, $response.Content.Length)))..." -ForegroundColor White
            }
            
            return @{ Name = $Name; Status = "SUCCESS"; Code = $response.StatusCode }
        } else {
            Write-Host "   ⚠️  UNEXPECTED STATUS: $($response.StatusCode)" -ForegroundColor Yellow
            return @{ Name = $Name; Status = "WARNING"; Code = $response.StatusCode }
        }
    } catch {
        $errorMessage = $_.Exception.Message
        if ($errorMessage -match "(\d{3})") {
            $statusCode = $matches[1]
            Write-Host "   ❌ FAILED (Status: $statusCode)" -ForegroundColor Red
        } else {
            Write-Host "   ❌ FAILED (Connection Error)" -ForegroundColor Red
        }
        Write-Host "   💬 Error: $errorMessage" -ForegroundColor Red
        return @{ Name = $Name; Status = "FAILED"; Code = $statusCode }
    }
    
    Write-Host ""
}

# Check if backend is running
Write-Host "🔍 Checking if backend is running..." -ForegroundColor Cyan
try {
    $healthCheck = Invoke-WebRequest -Uri "$baseUrl/health" -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Backend is responding!" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend is not running!" -ForegroundColor Red
    Write-Host "🚀 Start backend first:" -ForegroundColor Yellow
    Write-Host "   .\start_backend.ps1" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "🚀 Starting API tests..." -ForegroundColor Green
Write-Host ""

# Test basic endpoints
$testResults += Test-Endpoint "Health Check" "$baseUrl/health"
$testResults += Test-Endpoint "Get All Cities" "$baseUrl/cidades"
$testResults += Test-Endpoint "Get All Users" "$baseUrl/usuarios"
$testResults += Test-Endpoint "Get All Teams" "$baseUrl/equipes"
$testResults += Test-Endpoint "Get All Incidents" "$baseUrl/ocorrencias"
$testResults += Test-Endpoint "Get All Notifications" "$baseUrl/notificacoes"

# Test creating a new incident (POST)
Write-Host "🧪 Testing: Create New Incident" -ForegroundColor Cyan
$newIncident = @{
    latitude = -23.5505
    longitude = -46.6333
    descricao = "Test incident from API test script"
    severidade = 5
    usuarioId = 1
}

$testResults += Test-Endpoint "Create Incident" "$baseUrl/ocorrencias" "POST" $newIncident

# Test individual record retrieval
$testResults += Test-Endpoint "Get Incident #1" "$baseUrl/ocorrencias/1"
$testResults += Test-Endpoint "Get User #1" "$baseUrl/usuarios/1"
$testResults += Test-Endpoint "Get City #1" "$baseUrl/cidades/1"

# Test WhatsApp webhook endpoint
$webhookTest = @{
    From = "whatsapp:+5511999999999"
    Body = "Test message for webhook"
    Latitude = "-23.5505"
    Longitude = "-46.6333"
}

$testResults += Test-Endpoint "WhatsApp Webhook" "$baseUrl/webhook/whatsapp" "POST" $webhookTest

Write-Host ""
Write-Host "📊 Test Results Summary:" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan

$successCount = ($testResults | Where-Object { $_.Status -eq "SUCCESS" }).Count
$warningCount = ($testResults | Where-Object { $_.Status -eq "WARNING" }).Count
$failedCount = ($testResults | Where-Object { $_.Status -eq "FAILED" }).Count

foreach ($result in $testResults) {
    $color = switch ($result.Status) {
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "FAILED" { "Red" }
    }
    
    $icon = switch ($result.Status) {
        "SUCCESS" { "✅" }
        "WARNING" { "⚠️ " }
        "FAILED" { "❌" }
    }
    
    Write-Host "$icon $($result.Name)" -ForegroundColor $color
}

Write-Host ""
Write-Host "📈 Summary:" -ForegroundColor Cyan
Write-Host "   ✅ Success: $successCount" -ForegroundColor Green
Write-Host "   ⚠️  Warning: $warningCount" -ForegroundColor Yellow
Write-Host "   ❌ Failed:  $failedCount" -ForegroundColor Red

Write-Host ""
if ($failedCount -eq 0) {
    Write-Host "🎉 All tests passed! API is working correctly." -ForegroundColor Green
} elseif ($failedCount -le 2) {
    Write-Host "⚠️  Some tests failed, but core functionality appears to work." -ForegroundColor Yellow
} else {
    Write-Host "❌ Multiple tests failed. Check backend logs and database connection." -ForegroundColor Red
}

Write-Host ""
Write-Host "🔍 Additional checks:" -ForegroundColor Cyan
Write-Host "   🌐 Frontend: http://localhost:3000" -ForegroundColor Gray
Write-Host "   🗄️  Database: http://localhost:8081 (Adminer)" -ForegroundColor Gray
Write-Host "   📊 API Docs: $baseUrl/swagger-ui.html" -ForegroundColor Gray
Write-Host ""

Write-Host "Press any key to continue..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")