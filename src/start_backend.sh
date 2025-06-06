#!/bin/bash

echo ""
echo "🔥 Starting FireWatch Backend Service..."
echo ""

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "❌ Java not found! Please install Java 17+"
    echo "📥 Install with: sudo apt install openjdk-17-jdk"
    exit 1
fi

echo "✅ Java found: $(java -version 2>&1 | head -n 1)"

# Navigate to backend directory
if [ ! -d "backend" ]; then
    echo "❌ Backend directory not found"
    exit 1
fi

cd backend
echo "📁 Working directory: $(pwd)"

# Check if Maven wrapper exists
if [ ! -f "mvnw" ]; then
    echo "❌ Maven wrapper (mvnw) not found!"
    echo "💡 Make sure you're in the correct backend directory"
    exit 1
fi

echo "🔨 Building and starting Spring Boot application..."
echo ""

# Check if database is running
echo "🔍 Checking database connection..."
if docker ps --filter "name=firewatch-mysql" --filter "status=running" --format "table {{.Names}}" | grep -q "firewatch-mysql"; then
    echo "✅ MySQL container is running"
else
    echo "⚠️  MySQL container not running. Starting database first..."
    cd ..
    ./start_database.sh
    cd backend
fi

echo ""
echo "🚀 Starting Spring Boot application..."
echo "   This may take a few minutes on first run..."
echo ""

# Set environment variables
export SPRING_PROFILES_ACTIVE=development
export MAVEN_OPTS="-Xmx512m -Xms256m -XX:MaxMetaspaceSize=128m"

# Start the application
if ./mvnw spring-boot:run; then
    echo "✅ Backend started successfully!"
else
    echo ""
    echo "❌ Failed to start backend service!"
    echo ""
    echo "📋 Troubleshooting:"
    echo "1. Check if port 8080 is already in use:"
    echo "   sudo netstat -tulpn | grep :8080"
    echo ""
    echo "2. Check database connection:"
    echo "   ./start_database.sh"
    echo ""
    echo "3. Check Java version:"
    echo "   java -version"
    echo ""
    echo "4. Clean and rebuild:"
    echo "   ./mvnw clean install"
    echo ""
    read -p "Press any key to continue..."
fi