#!/bin/bash

echo "🔥 FireWatch Complete Startup Script"
echo "===================================="
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to check if a port is in use
port_in_use() {
    lsof -i :$1 &> /dev/null
}

# Function to kill processes on a specific port
kill_port() {
    local port=$1
    echo "🔄 Stopping any existing processes on port $port..."
    if port_in_use $port; then
        fuser -k $port/tcp 2>/dev/null || true
        sleep 2
    fi
}

# Function to start backend
start_backend() {
    echo "🚀 Starting Backend..."
    echo "---------------------"
    
    # Kill any existing backend process
    kill_port 8080
    
    cd backend
    
    if command_exists docker && [ -f "Dockerfile" ]; then
        echo "🐳 Using Docker to run backend..."
        docker build -t firewatch-backend . &> /dev/null &
        wait
        docker run -d -p 8080:8080 --name firewatch-backend-dev --rm firewatch-backend &> /dev/null
    elif [ -f "mvnw" ]; then
        echo "☕ Using Maven wrapper to run backend..."
        ./mvnw spring-boot:run &> backend.log &
    else
        echo "❌ Neither Docker nor Maven wrapper found!"
        exit 1
    fi
    
    # Wait for backend to start
    echo "⏳ Waiting for backend to start on port 8080..."
    while ! port_in_use 8080; do
        sleep 2
        echo -n "."
    done
    echo ""
    echo "✅ Backend started successfully on http://localhost:8080"
    
    cd ..
}

# Function to start ngrok
start_ngrok() {
    echo ""
    echo "🌐 Starting ngrok..."
    echo "------------------"
    
    if ! command_exists ngrok; then
        echo "❌ ngrok not found! Please install ngrok:"
        echo "   1. Download from https://ngrok.com/download"
        echo "   2. Extract to /usr/local/bin or add to PATH"
        echo "   3. Run: ngrok authtoken <your-auth-token>"
        return 1
    fi
    
    # Kill any existing ngrok process
    pkill -f ngrok 2>/dev/null || true
    sleep 2
    
    echo "🚀 Starting ngrok tunnel for backend (port 8080)..."
    ngrok http 8080 --log=stdout > ngrok.log 2>&1 &
    
    # Wait for ngrok to start and get the URL
    echo "⏳ Waiting for ngrok to establish tunnel..."
    sleep 5
    
    if command_exists curl && command_exists jq; then
        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' 2>/dev/null)
        if [ "$NGROK_URL" != "null" ] && [ ! -z "$NGROK_URL" ]; then
            echo "✅ ngrok tunnel established: $NGROK_URL"
            echo "📝 Use this URL for Twilio webhook configuration"
        else
            echo "⚠️  ngrok started but couldn't retrieve public URL"
            echo "   Check ngrok dashboard at http://localhost:4040"
        fi
    else
        echo "✅ ngrok started - check dashboard at http://localhost:4040 for public URL"
    fi
}

# Function to start frontend
start_frontend() {
    echo ""
    echo "⚛️  Starting Frontend..."
    echo "----------------------"
    
    cd frontend
    
    if ! command_exists npm; then
        echo "❌ npm not found! Please install Node.js and npm"
        exit 1
    fi
    
    # Kill any existing frontend process
    kill_port 3000
    
    echo "📦 Installing dependencies..."
    npm install
    
    if [ $? -eq 0 ]; then
        echo "🚀 Starting React development server..."
        npm start &
        
        # Wait for frontend to start
        echo "⏳ Waiting for frontend to start on port 3000..."
        while ! port_in_use 3000; do
            sleep 2
            echo -n "."
        done
        echo ""
        echo "✅ Frontend started successfully on http://localhost:3000"
    else
        echo "❌ Failed to install frontend dependencies"
        exit 1
    fi
    
    cd ..
}

# Function to show final status
show_status() {
    echo ""
    echo "🎉 FireWatch System Status"
    echo "========================="
    echo "🔧 Backend:   http://localhost:8080"
    echo "⚛️  Frontend:  http://localhost:3000"
    if command_exists curl && command_exists jq; then
        NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' 2>/dev/null)
        if [ "$NGROK_URL" != "null" ] && [ ! -z "$NGROK_URL" ]; then
            echo "🌐 ngrok:     $NGROK_URL"
        fi
    fi
    echo "📊 ngrok UI:  http://localhost:4040"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Configure Twilio webhook with the ngrok URL + '/api/webhook/whatsapp'"
    echo "   2. Access the frontend to manage the system"
    echo "   3. Test WhatsApp integration"
    echo ""
    echo "🛑 To stop all services, press Ctrl+C and run:"
    echo "   ./stop_firewatch.sh"
}

# Function to handle cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Shutting down FireWatch services..."
    kill_port 8080
    kill_port 3000
    pkill -f ngrok 2>/dev/null || true
    docker stop firewatch-backend-dev 2>/dev/null || true
    echo "✅ All services stopped"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main execution
echo "🔍 Checking prerequisites..."
echo ""

# Check if we're in the right directory
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: Run this script from the FireWatchProject root directory"
    echo "   Current directory should contain 'backend' and 'frontend' folders"
    exit 1
fi

# Start all services
start_backend
start_ngrok
start_frontend
show_status

# Keep script running
echo "🔄 Services running... Press Ctrl+C to stop all services"
while true; do
    sleep 10
    
    # Check if services are still running
    if ! port_in_use 8080; then
        echo "⚠️  Backend stopped unexpectedly"
        break
    fi
    
    if ! port_in_use 3000; then
        echo "⚠️  Frontend stopped unexpectedly"
        break
    fi
done

cleanup