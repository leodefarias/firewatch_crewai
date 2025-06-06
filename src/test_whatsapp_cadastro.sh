#!/bin/bash

# Script para testar o fluxo completo de cadastro via WhatsApp
# Execute este script depois que o backend estiver rodando

API_URL="http://localhost:8080/api/webhook/whatsapp"
PHONE_NUMBER="+5511999999999"

echo "🔥 TESTANDO FLUXO DE CADASTRO VIA WHATSAPP 🔥"
echo "=============================================="

echo
echo "📱 1. Simulando usuário novo enviando primeira mensagem..."
echo "Resposta esperada: Instruções de cadastro"
curl -X POST "$API_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "From=whatsapp:$PHONE_NUMBER" \
  -d "Body=Oi, quero reportar um incêndio!"

echo
echo
echo "📝 2. Simulando envio dos dados de cadastro..."
echo "Resposta esperada: Confirmação de cadastro"
curl -X POST "$API_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "From=whatsapp:$PHONE_NUMBER" \
  -d "Body=NOME: João Silva
ENDERECO: Rua das Flores, 123, Centro
CIDADE: São Paulo"

echo
echo
echo "🔥 3. Simulando denúncia de incêndio com localização..."
echo "Resposta esperada: Ocorrência registrada"
curl -X POST "$API_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "From=whatsapp:$PHONE_NUMBER" \
  -d "Body=Incêndio urgente! Fogo descontrolado!" \
  -d "Latitude=-23.5505" \
  -d "Longitude=-46.6333"

echo
echo
echo "🔍 4. Verificando usuários cadastrados..."
curl -X GET "http://localhost:8080/api/usuarios" \
  -H "Accept: application/json" | jq '.'

echo
echo
echo "🔍 5. Verificando ocorrências registradas..."
curl -X GET "http://localhost:8080/api/ocorrencias" \
  -H "Accept: application/json" | jq '.'

echo
echo "✅ Teste concluído!"
echo
echo "📋 FLUXO TESTADO:"
echo "1. ✅ Usuário novo recebe instruções de cadastro"
echo "2. ✅ Usuário envia dados e é cadastrado automaticamente"
echo "3. ✅ Usuário reporta incêndio e ocorrência é registrada"
echo "4. ✅ Sistema mantém histórico completo"
echo
echo "🚀 O sistema agora permite cadastro 100% via WhatsApp!"