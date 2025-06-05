#!/bin/bash

echo ""
echo "🔥 Stopping FireWatch Database Services..."
echo ""

# Check if Docker is running
if ! docker ps >/dev/null 2>&1; then
    echo "⚠️  Docker is not running or accessible"
    exit 0
fi

# Navigate to project root
cd ..

echo "🛑 Stopping database containers..."

# Stop database services
if docker-compose stop firewatch-mysql firewatch-redis firewatch-adminer; then
    echo ""
    echo "✅ Database services stopped successfully!"
    echo ""
    
    # Show status
    echo "📊 Container Status:"
    docker-compose ps firewatch-mysql firewatch-redis firewatch-adminer
    
    echo ""
    echo "🔧 Available commands:"
    echo "   ./start_database.sh       # Restart database services"
    echo "   docker-compose down       # Remove containers completely"
    echo ""
    
else
    echo ""
    echo "❌ Failed to stop some services!"
    echo "🔍 Check running containers:"
    echo "   docker ps"
fi

echo ""
read -p "Press any key to continue..."