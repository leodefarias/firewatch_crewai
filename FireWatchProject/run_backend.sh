#!/bin/bash

echo "🔥 FireWatch Backend Startup Script"
echo "==================================="

# Check if Docker is available
if command -v docker &> /dev/null; then
    echo "🐳 Docker found - using Docker to run backend"
    echo ""
    
    # Build and run with Docker
    cd backend
    
    echo "📦 Building backend image..."
    docker build -t firewatch-backend .
    
    echo "🚀 Starting backend container..."
    docker run -p 8080:8080 \
        --env-file ../.env \
        --name firewatch-backend-dev \
        --rm \
        firewatch-backend
        
elif [ -f "mvnw" ]; then
    echo "☕ Using Maven wrapper to run backend"
    echo ""
    
    cd backend
    echo "🚀 Starting Spring Boot application..."
    ./mvnw spring-boot:run
    
else
    echo "❌ Neither Docker nor Maven wrapper found!"
    echo ""
    echo "Please install either:"
    echo "1. Docker: https://docs.docker.com/get-docker/"
    echo "2. Maven: sudo apt install maven"
    echo ""
    echo "Or use the Docker approach:"
    echo "  docker-compose up firewatch-backend"
    exit 1
fi