#!/bin/bash

# Script para testar o webhook do WhatsApp
# Simula uma mensagem do Twilio com localização

echo "🔥 Testando webhook do FireWatch WhatsApp..."

# URL do webhook (ajustar conforme necessário)
WEBHOOK_URL="http://localhost:8080/api/webhook/whatsapp"

echo "Enviando teste 1: Mensagem com coordenadas na mensagem..."
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "From=whatsapp:+5511999999999" \
  -d "Body=Incêndio urgente! Lat: -23.5505, Long: -46.6333. Fogo descontrolado na floresta!" \
  -v

echo -e "\n\n"

echo "Enviando teste 2: Mensagem com parâmetros de localização..."
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "From=whatsapp:+5511888888888" \
  -d "Body=Socorro! Tem fogo aqui perto de casa, muita fumaça!" \
  -d "Latitude=-22.9068" \
  -d "Longitude=-43.1729" \
  -v

echo -e "\n\n"

echo "Enviando teste 3: Mensagem sem localização..."
curl -X POST $WEBHOOK_URL \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "From=whatsapp:+5511777777777" \
  -d "Body=Oi, quero reportar um incêndio mas não sei como enviar localização" \
  -v

echo -e "\n\n✅ Testes concluídos!"
echo "Verifique o terminal do backend para logs e o frontend para novas ocorrências."
echo "Webhook URL configurada: $WEBHOOK_URL"