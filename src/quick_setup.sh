#!/bin/bash

echo ""
echo "🔥 FireWatch - Quick Linux/macOS Setup Script"
echo "=============================================="
echo ""

# Check if .env exists
if [ ! -f "../env" ]; then
    echo "📝 Creating .env file from template..."
    if [ -f "../.env.example" ]; then
        cp "../.env.example" "../env"
        echo "✅ .env file created!"
    else
        echo "❌ .env.example not found! Creating basic .env..."
        cat > "../env" << EOF
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
EOF
        echo "✅ Basic .env file created!"
    fi
    echo ""
    echo "⚠️  IMPORTANT: Edit .env file with your Twilio credentials:"
    echo "   - TWILIO_ACCOUNT_SID"
    echo "   - TWILIO_AUTH_TOKEN"
    echo "   - TWILIO_WHATSAPP_FROM"
    echo ""
else
    echo "✅ .env file already exists"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found!"
    echo "📥 Install Docker from: https://docs.docker.com/get-docker/"
    echo "   Ubuntu/Debian: sudo apt update && sudo apt install docker.io docker-compose"
    echo "   macOS: brew install docker docker-compose"
    echo ""
else
    echo "✅ Docker is installed: $(docker --version)"
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not found!"
    echo "📥 Docker Compose installation:"
    echo "   Ubuntu/Debian: sudo apt install docker-compose"
    echo "   macOS: brew install docker-compose"
else
    echo "✅ Docker Compose is installed: $(docker-compose --version)"
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java not found!"
    echo "📥 Install Java 17+ from:"
    echo "   Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "   macOS: brew install openjdk@17"
    echo "   Or download from: https://adoptium.net/"
    echo ""
else
    echo "✅ Java is installed: $(java -version 2>&1 | head -n 1)"
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found!"
    echo "📥 Install Node.js 18+ from:"
    echo "   Ubuntu/Debian: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    echo "   macOS: brew install node"
    echo "   Or download from: https://nodejs.org/"
    echo ""
else
    echo "✅ Node.js is installed: $(node --version)"
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python not found!"
    echo "📥 Install Python 3.11+ from:"
    echo "   Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "   macOS: brew install python@3.11"
    echo ""
else
    echo "✅ Python is installed: $(python3 --version)"
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git not found!"
    echo "📥 Install Git from:"
    echo "   Ubuntu/Debian: sudo apt install git"
    echo "   macOS: brew install git"
    echo ""
else
    echo "✅ Git is installed: $(git --version)"
fi

echo ""
echo "🚀 Next Steps for Linux/macOS:"
echo "=============================="
echo ""
echo "1. 📝 Configure Twilio credentials in .env file:"
echo "   nano ../env"
echo ""
echo "2. 🐳 Start with Docker (Recommended):"
echo "   cd ..; docker-compose up -d"
echo ""
echo "3. 🌐 Or start services individually:"
echo "   ./start_database.sh      # Start MySQL + Redis"
echo "   ./start_backend.sh       # Start Spring Boot API"
echo "   ./start_frontend.sh      # Start React app"
echo ""
echo "4. 🔗 For WhatsApp integration:"
echo "   ./setup_whatsapp.sh      # Setup ngrok + webhook"
echo ""
echo "5. 🧪 Test the application:"
echo "   ./test_api.sh            # Test API endpoints"
echo ""
echo "6. 🌐 Access the application:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:8080"
echo "   - Database Admin: http://localhost:8081"
echo ""
echo "💾 Low memory options:"
echo "   ./start_backend_low_memory.sh  # Use if system has limited RAM"
echo ""
echo "📚 For detailed instructions, see: documentation/README.md"
echo ""
echo "🆘 Need help? Check the troubleshooting section in documentation/"
echo ""

# Make scripts executable
chmod +x *.sh 2>/dev/null

echo "📝 All scripts are now executable!"
echo ""
read -p "Press any key to continue..."