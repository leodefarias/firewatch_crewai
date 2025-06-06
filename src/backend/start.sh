#!/bin/bash

echo "🔥 FireWatch Backend - Loading environment and starting..."

# Load environment variables from .env file
if [ -f "../.env" ]; then
    echo "📝 Loading environment variables from .env..."
    export $(grep -v '^#' ../.env | xargs)
    echo "✅ Environment variables loaded!"
    echo "   TWILIO_ACCOUNT_SID: ${TWILIO_ACCOUNT_SID:0:8}..."
    echo "   TWILIO_AUTH_TOKEN: ${TWILIO_AUTH_TOKEN:0:8}..."
    echo "   TWILIO_WHATSAPP_FROM: $TWILIO_WHATSAPP_FROM"
else
    echo "⚠️  .env file not found, using default values"
fi

echo ""
echo "🚀 Starting Spring Boot application..."
./mvnw spring-boot:run