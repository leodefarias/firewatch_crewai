#!/bin/bash

NGROK_PID="/tmp/ngrok.pid"

echo "🛑 Stopping ngrok..."

# Check if PID file exists
if [ ! -f "$NGROK_PID" ]; then
    echo "⚠️  ngrok PID file not found"
    echo "🔍 Trying to find ngrok process..."
    
    # Try to kill by process name
    if pkill -f "ngrok http" 2>/dev/null; then
        echo "✅ ngrok stopped"
    else
        echo "❌ No ngrok process found"
    fi
    exit 0
fi

# Kill process by PID
PID=$(cat $NGROK_PID)
if kill $PID 2>/dev/null; then
    echo "✅ ngrok stopped (PID: $PID)"
    rm "$NGROK_PID"
else
    echo "⚠️  Process $PID not found, cleaning up PID file"
    rm "$NGROK_PID"
fi

# Verify it's really stopped
sleep 1
if ! curl -s http://localhost:4040/api/tunnels >/dev/null 2>&1; then
    echo "✅ ngrok dashboard is offline"
else
    echo "⚠️  ngrok might still be running"
fi