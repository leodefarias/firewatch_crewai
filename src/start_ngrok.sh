#!/bin/bash

NGROK_LOG="/tmp/ngrok.log"
NGROK_PID="/tmp/ngrok.pid"

echo "🌐 Starting ngrok for FireWatch..."

# Check if ngrok is already running
if [ -f "$NGROK_PID" ] && kill -0 $(cat $NGROK_PID) 2>/dev/null; then
    echo "⚠️  ngrok is already running!"
    echo "🔗 Current URL:"
    curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^"]*\.ngrok[^"]*' | head -1
    echo ""
    echo "🔧 To stop: ./stop_ngrok.sh"
    exit 0
fi

# Start ngrok in background
echo "🚀 Starting ngrok tunnel for port 8080..."
nohup ngrok http 8080 > "$NGROK_LOG" 2>&1 &
echo $! > "$NGROK_PID"

# Wait for ngrok to start
sleep 3

# Get the public URL
echo "🔍 Getting tunnel URL..."
sleep 2

NGROK_URL=""
for i in {1..10}; do
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels 2>/dev/null | grep -o 'https://[^"]*\.ngrok[^"]*' | head -1)
    if [ ! -z "$NGROK_URL" ]; then
        break
    fi
    echo "   Waiting for ngrok... ($i/10)"
    sleep 2
done

if [ ! -z "$NGROK_URL" ]; then
    echo ""
    echo "✅ ngrok started successfully!"
    echo ""
    echo "🔗 Your public URL:"
    echo "   $NGROK_URL"
    echo ""
    echo "📱 Webhook URL for Twilio:"
    echo "   $NGROK_URL/api/webhook/whatsapp"
    echo ""
    
    # Try to copy to clipboard
    if command -v xclip >/dev/null 2>&1; then
        echo "$NGROK_URL/api/webhook/whatsapp" | xclip -selection clipboard
        echo "📋 Webhook URL copied to clipboard!"
    fi
    
    echo ""
    echo "🔧 Management:"
    echo "   View dashboard: http://localhost:4040"
    echo "   Stop ngrok: ./stop_ngrok.sh"
    echo "   View logs: tail -f $NGROK_LOG"
    echo ""
    echo "⚠️  Remember to update Twilio webhook URL:"
    echo "   https://console.twilio.com → Messaging → WhatsApp Sandbox"
    echo ""
else
    echo "❌ Failed to start ngrok!"
    echo "📝 Check logs: cat $NGROK_LOG"
    
    # Clean up
    if [ -f "$NGROK_PID" ]; then
        kill $(cat $NGROK_PID) 2>/dev/null
        rm "$NGROK_PID"
    fi
fi