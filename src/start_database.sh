#!/bin/bash

echo ""
echo "🔥 Starting FireWatch Database Services..."
echo ""

# Check if Docker is running
if ! docker ps >/dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "📥 Start Docker and try again"
    echo "   sudo systemctl start docker"
    exit 1
fi

echo "✅ Docker is running"

echo "🐳 Starting MySQL and Redis containers..."

# Navigate to project root
cd ..

# Start only database services
if docker-compose up -d firewatch-mysql firewatch-redis; then
    echo ""
    echo "✅ Database services started successfully!"
    echo ""
    echo "📊 Service Status:"
    echo "=================="
    echo "🗄️  MySQL:    localhost:3306"
    echo "🔴 Redis:     localhost:6379"
    echo "🔧 Adminer:   http://localhost:8081"
    echo ""
    echo "🔑 Database Credentials:"
    echo "========================"
    echo "Database: firewatch"
    echo "Username: firewatch_user"
    echo "Password: firewatch_pass"
    echo ""
    echo "⏳ Waiting for services to be ready..."
    
    # Wait for MySQL to be ready
    attempt=0
    max_attempts=30
    while [ $attempt -lt $max_attempts ]; do
        attempt=$((attempt + 1))
        echo "   Checking MySQL connection (attempt $attempt/$max_attempts)..."
        if docker exec firewatch-mysql mysqladmin ping -h localhost -u firewatch_user -pfirewatch_pass >/dev/null 2>&1; then
            echo "✅ MySQL is ready!"
            break
        fi
        if [ $attempt -eq $max_attempts ]; then
            echo "⚠️  MySQL took longer than expected to start"
            break
        fi
        sleep 2
    done
    
    echo ""
    echo "🚀 Next steps:"
    echo "   ./start_backend.sh       # Start Spring Boot API"
    echo "   ./start_frontend.sh      # Start React frontend"
    echo ""
    echo "🛑 To stop database services:"
    echo "   ./stop_database.sh"
    
else
    echo ""
    echo "❌ Failed to start database services!"
    echo "🔍 Check Docker and try again"
    echo ""
    echo "📋 Troubleshooting:"
    echo "   docker-compose logs firewatch-mysql"
    echo "   docker-compose logs firewatch-redis"
fi

echo ""
read -p "Press any key to continue..."