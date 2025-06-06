#!/bin/bash

echo ""
echo "🔥 FireWatch - Testing API Endpoints..."
echo "======================================="
echo ""

baseUrl="http://localhost:8080/api"

# Check if backend is running
echo "🔍 Checking if backend is running..."
if ! curl -s $baseUrl/health >/dev/null 2>&1; then
    echo "❌ Backend is not running!"
    echo "🚀 Start backend first:"
    echo "   ./start_backend.sh"
    echo ""
    exit 1
fi
echo "✅ Backend is responding!"

echo ""
echo "🚀 Starting API tests..."
echo ""

# Function to test endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local method="${3:-GET}"
    
    echo "🧪 Testing: $name"
    if curl -s -X $method "$url" >/dev/null 2>&1; then
        echo "   ✅ SUCCESS"
    else
        echo "   ❌ FAILED"
    fi
    echo ""
}

# Test basic endpoints
test_endpoint "Health Check" "$baseUrl/health"
test_endpoint "Get All Cities" "$baseUrl/cidades"
test_endpoint "Get All Users" "$baseUrl/usuarios"
test_endpoint "Get All Teams" "$baseUrl/equipes"
test_endpoint "Get All Incidents" "$baseUrl/ocorrencias"
test_endpoint "Get All Notifications" "$baseUrl/notificacoes"

# Test creating a new incident
echo "🧪 Testing: Create New Incident"
if curl -s -X POST -H "Content-Type: application/json" \
   -d '{"latitude":-23.5505,"longitude":-46.6333,"descricao":"Test incident from API test script","severidade":5,"usuarioId":1}' \
   "$baseUrl/ocorrencias" >/dev/null 2>&1; then
    echo "   ✅ SUCCESS"
else
    echo "   ❌ FAILED"
fi
echo ""

# Test individual record retrieval
test_endpoint "Get Incident #1" "$baseUrl/ocorrencias/1"
test_endpoint "Get User #1" "$baseUrl/usuarios/1"
test_endpoint "Get City #1" "$baseUrl/cidades/1"

# Test WhatsApp webhook
echo "🧪 Testing: WhatsApp Webhook"
if curl -s -X POST -H "Content-Type: application/x-www-form-urlencoded" \
   -d "From=whatsapp:+5511999999999&Body=Test message&Latitude=-23.5505&Longitude=-46.6333" \
   "$baseUrl/webhook/whatsapp" >/dev/null 2>&1; then
    echo "   ✅ SUCCESS"
else
    echo "   ❌ FAILED"
fi
echo ""

echo "📊 API Tests Completed!"
echo ""
echo "🔍 Additional checks:"
echo "   🌐 Frontend: http://localhost:3000"
echo "   🗄️  Database: http://localhost:8081 (Adminer)"
echo "   📊 API Docs: $baseUrl/swagger-ui.html"
echo ""

read -p "Press any key to continue..."