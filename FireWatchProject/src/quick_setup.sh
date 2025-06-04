#!/bin/bash

echo "🔥 FireWatch - Quick WhatsApp Setup Script"
echo "=========================================="

# Check if .env exists
if [ ! -f ../.env ]; then
    echo "📝 Creating .env file from template..."
    cp ../.env.example ../.env
    echo "✅ .env file created!"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env file with your Twilio credentials:"
    echo "   - TWILIO_ACCOUNT_SID"
    echo "   - TWILIO_AUTH_TOKEN"
    echo "   - TWILIO_WHATSAPP_FROM"
    echo ""
else
    echo "✅ .env file already exists"
fi

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok not found!"
    echo "📥 Install ngrok from: https://ngrok.com/download"
    echo "   Ubuntu/Debian: sudo snap install ngrok"
    echo "   macOS: brew install ngrok"
    echo ""
else
    echo "✅ ngrok is installed"
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java not found!"
    echo "📥 Install Java 17+:"
    echo "   Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "   macOS: brew install openjdk@17"
    echo ""
else
    echo "✅ Java is installed: $(java -version 2>&1 | head -n 1)"
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found!"
    echo "📥 Install Node.js 18+:"
    echo "   Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    echo "   macOS: brew install node"
    echo ""
else
    echo "✅ Node.js is installed: $(node -v)"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found!"
    echo "📥 Install Docker from: https://docs.docker.com/get-docker/"
    echo ""
else
    echo "✅ Docker is installed: $(docker -v)"
fi

echo ""
echo "🚀 Next Steps:"
echo "=============="
echo ""
echo "1. 📝 Configure Twilio credentials in .env file:"
echo "   nano ../.env"
echo ""
echo "2. 🐳 Start database:"
echo "   cd .. && docker-compose up firewatch-mysql firewatch-redis -d"
echo ""
echo "3. ☕ Start backend (in new terminal):"
echo "   cd src/backend && ./mvnw spring-boot:run"
echo ""
echo "4. 🌐 Expose backend with ngrok (in new terminal):"
echo "   ngrok http 8080"
echo ""
echo "5. 🔗 Configure Twilio webhook:"
echo "   - Copy ngrok HTTPS URL (e.g., https://abc123.ngrok.io)"
echo "   - Go to Twilio Console → Messaging → WhatsApp sandbox settings"
echo "   - Set webhook: https://your-ngrok-url.ngrok.io/api/webhook/whatsapp"
echo ""
echo "6. 📱 Start frontend (in new terminal):"
echo "   cd src/frontend && npm install && npm start"
echo ""
echo "7. 🧪 Test by sending WhatsApp message with location to Twilio sandbox number"
echo ""
echo "📚 For detailed instructions, see: documentation/SETUP_WHATSAPP.md"
echo ""
echo "🆘 Need help? Check the troubleshooting section in documentation/SETUP_WHATSAPP.md"