#!/bin/bash

echo ""
echo "🔥 FireWatch - WhatsApp Integration Setup"
echo "=========================================="
echo ""

# Check if .env file exists
if [ ! -f "../env" ]; then
    echo "❌ .env file not found!"
    echo "📝 Run ./quick_setup.sh first to create .env file"
    exit 1
fi

echo "✅ Found .env file"

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok not found!"
    echo ""
    echo "📥 Install ngrok for Linux:"
    echo "1. Download from: https://ngrok.com/download"
    echo "2. Extract and move to PATH:"
    echo "   sudo mv ngrok /usr/local/bin/"
    echo "3. Or use snap: sudo snap install ngrok"
    echo ""
    echo "⚠️  You'll also need to create a free ngrok account and run:"
    echo "   ngrok config add-authtoken YOUR_TOKEN"
    echo ""
    exit 1
fi

echo "✅ ngrok is installed: $(ngrok version)"

# Check if backend is running
echo ""
echo "🔍 Checking if backend is running..."
if curl -s http://localhost:8080/api/health >/dev/null 2>&1; then
    echo "✅ Backend is running on port 8080"
else
    echo "❌ Backend is not running!"
    echo "🚀 Start backend first:"
    echo "   ./start_backend.sh"
    echo ""
    read -p "Do you want to continue anyway? (y/n): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check Twilio configuration
echo ""
echo "🔍 Checking Twilio configuration..."
if grep -v "your_account_sid_here" "../env" | grep -q "TWILIO_ACCOUNT_SID" && \
   grep -v "your_auth_token_here" "../env" | grep -q "TWILIO_AUTH_TOKEN"; then
    echo "✅ Twilio credentials found in .env"
else
    echo "⚠️  Twilio credentials not properly configured!"
    echo ""
    echo "📝 Please edit .env file with your Twilio credentials:"
    echo "   nano ../env"
    echo ""
    echo "🔑 You need:"
    echo "   - TWILIO_ACCOUNT_SID (from Twilio Console)"
    echo "   - TWILIO_AUTH_TOKEN (from Twilio Console)"
    echo "   - TWILIO_WHATSAPP_FROM (e.g., whatsapp:+14155238886)"
    echo ""
    read -p "Do you want to open .env file now? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        ${EDITOR:-nano} "../env"
        echo "Press any key after saving .env file..."
        read -n 1 -s
    fi
fi

echo ""
echo "🌐 Starting ngrok tunnel..."
echo ""

# Start ngrok in background
echo "⏳ Starting ngrok tunnel for port 8080..."
ngrok http 8080 --log=stdout &
NGROK_PID=$!

# Wait for ngrok to start
sleep 5

# Get the public URL from ngrok API
echo "🔍 Getting tunnel information..."
if curl -s http://localhost:4040/api/tunnels | grep -q "https://"; then
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*\.ngrok\.io' | head -1)
    
    if [ ! -z "$NGROK_URL" ]; then
        echo "✅ ngrok tunnel created successfully!"
        echo ""
        echo "🔗 Your public URL:"
        echo "   $NGROK_URL"
        echo ""
        echo "📱 Webhook URL for Twilio:"
        echo "   $NGROK_URL/api/webhook/whatsapp"
        echo ""
        
        # Copy webhook URL to clipboard if xclip is available
        if command -v xclip &> /dev/null; then
            echo "$NGROK_URL/api/webhook/whatsapp" | xclip -selection clipboard
            echo "📋 Webhook URL copied to clipboard!"
        else
            echo "📋 Please copy the webhook URL manually"
        fi
        
        echo ""
        echo "⚙️  Next steps for Twilio configuration:"
        echo "======================================="
        echo ""
        echo "1. 🌐 Go to Twilio Console: https://console.twilio.com/"
        echo ""
        echo "2. 📱 Navigate to: Messaging > Try it out > Send a WhatsApp message"
        echo ""
        echo "3. 🔧 Configure Sandbox Settings:"
        echo "   - Webhook URL: $NGROK_URL/api/webhook/whatsapp"
        echo "   - HTTP Method: POST"
        echo "   - Events: Incoming Messages"
        echo ""
        echo "4. 📲 Join WhatsApp Sandbox:"
        echo "   - Send 'join <sandbox-keyword>' to +1 415 523 8886"
        echo "   - Example: 'join yellow-dog'"
        echo ""
        echo "5. 🧪 Test by sending a location or coordinates:"
        echo "   - Send your location via WhatsApp"
        echo "   - Or send: 'Incêndio! Lat: -23.5505, Long: -46.6333'"
        echo ""
        echo "🔍 Monitor webhook calls:"
        echo "   - ngrok dashboard: http://localhost:4040"
        echo "   - Backend logs: Check console where backend is running"
        echo ""
        echo "⚠️  Keep this window open to maintain the tunnel!"
        echo "   Press any key to stop ngrok when done"
        echo ""
        
        read -n 1 -s
        
    else
        echo "❌ Could not get public URL from ngrok"
    fi
else
    echo "❌ Failed to get ngrok tunnel information!"
    echo "🔍 Check if ngrok started correctly:"
    echo "   - Visit http://localhost:4040 for ngrok dashboard"
    echo "   - Check if port 8080 is available"
fi

# Clean up - kill ngrok process
echo ""
echo "🛑 Stopping ngrok tunnel..."
kill $NGROK_PID 2>/dev/null

echo ""
echo "✅ WhatsApp setup script completed!"
echo ""
echo "📚 For more detailed instructions, see:"
echo "   documentation/SETUP_WHATSAPP.md"
echo ""