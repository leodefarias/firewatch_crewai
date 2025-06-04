#!/bin/bash

# Script para testar a API FireWatch
# Uso: ./test_api.sh [base_url]

set -e

BASE_URL=${1:-"http://localhost:8080/api"}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="api_test_results_$TIMESTAMP.log"

echo "🔥 Testando API FireWatch"
echo "========================"
echo "Base URL: $BASE_URL"
echo "Log File: $LOG_FILE"
echo ""

# Função para fazer requisições e capturar resposta
make_request() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    echo "📡 $description"
    echo "   $method $endpoint"
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$BASE_URL$endpoint" 2>&1)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            -H "Content-Type: application/json" \
            "$BASE_URL$endpoint" 2>&1)
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    echo "   Status: $http_code" | tee -a "$LOG_FILE"
    
    if [[ "$http_code" =~ ^2[0-9][0-9]$ ]]; then
        echo "   ✅ Sucesso" | tee -a "$LOG_FILE"
    else
        echo "   ❌ Erro" | tee -a "$LOG_FILE"
        echo "   Response: $body" | tee -a "$LOG_FILE"
    fi
    
    echo "" | tee -a "$LOG_FILE"
    
    # Salva resposta completa no log
    echo "=== $description ===" >> "$LOG_FILE"
    echo "Request: $method $endpoint" >> "$LOG_FILE"
    if [ -n "$data" ]; then
        echo "Data: $data" >> "$LOG_FILE"
    fi
    echo "Status: $http_code" >> "$LOG_FILE"
    echo "Response: $body" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    return $http_code
}

# Função para verificar se API está online
check_api_health() {
    echo "🏥 Verificando saúde da API..."
    
    if curl -s "$BASE_URL/../actuator/health" > /dev/null 2>&1; then
        echo "✅ API está online"
        return 0
    else
        echo "❌ API não está respondendo"
        echo "   Certifique-se de que o backend está rodando em: ${BASE_URL%/api}"
        return 1
    fi
}

# Testes básicos de CRUD
test_basic_crud() {
    echo "🧪 Executando testes básicos de CRUD"
    echo "===================================="
    
    # Teste 1: Listar cidades
    make_request "GET" "/cidades" "" "Listar todas as cidades"
    
    # Teste 2: Cadastrar nova cidade
    cidade_data='{
        "nome": "Teste Cidade API",
        "latitude": -23.5505,
        "longitude": -46.6333,
        "estado": "SP"
    }'
    make_request "POST" "/cidades" "$cidade_data" "Cadastrar nova cidade"
    
    # Teste 3: Listar usuários
    make_request "GET" "/usuarios" "" "Listar todos os usuários"
    
    # Teste 4: Cadastrar novo usuário
    usuario_data='{
        "nome": "Usuário Teste API",
        "telefone": "+5511000000001",
        "email": "teste.api@firewatch.com",
        "tipoUsuario": "CIDADAO",
        "cidade": {"id": 1}
    }'
    make_request "POST" "/usuarios" "$usuario_data" "Cadastrar novo usuário"
    
    # Teste 5: Listar equipes
    make_request "GET" "/equipes" "" "Listar todas as equipes"
    
    # Teste 6: Cadastrar nova equipe
    equipe_data='{
        "nome": "Equipe Teste API",
        "regiao": "São Paulo",
        "numeroMembros": 4,
        "tipoEquipamento": "Equipamento de teste"
    }'
    make_request "POST" "/equipes" "$equipe_data" "Cadastrar nova equipe"
}

# Testes de ocorrências
test_ocorrencias() {
    echo "🔥 Testando funcionalidades de ocorrências"
    echo "=========================================="
    
    # Teste 1: Listar ocorrências
    make_request "GET" "/ocorrencias" "" "Listar todas as ocorrências"
    
    # Teste 2: Registrar ocorrência de baixa severidade
    ocorrencia_baixa='{
        "descricao": "Teste API - Incêndio de baixa severidade",
        "severidade": 3,
        "latitude": -23.5505,
        "longitude": -46.6333,
        "cidade": {"id": 1, "nome": "São Paulo"}
    }'
    make_request "POST" "/ocorrencias" "$ocorrencia_baixa" "Registrar ocorrência (baixa severidade)"
    
    # Teste 3: Registrar ocorrência de alta severidade
    ocorrencia_alta='{
        "descricao": "Teste API - Incêndio de alta severidade",
        "severidade": 9,
        "latitude": -22.9068,
        "longitude": -43.1729,
        "cidade": {"id": 2, "nome": "Rio de Janeiro"}
    }'
    make_request "POST" "/ocorrencias" "$ocorrencia_alta" "Registrar ocorrência (alta severidade)"
    
    # Teste 4: Listar por prioridade
    make_request "GET" "/ocorrencias/prioridade" "" "Listar ocorrências por prioridade"
    
    # Teste 5: Buscar ocorrência específica
    make_request "GET" "/ocorrencias/1" "" "Buscar ocorrência por ID"
    
    # Teste 6: Atribuir equipe (se existir)
    make_request "PUT" "/ocorrencias/1/atribuir-equipe/1" "" "Atribuir equipe à ocorrência"
    
    # Teste 7: Finalizar ocorrência
    make_request "PUT" "/ocorrencias/1/finalizar" "" "Finalizar ocorrência"
}

# Testes de notificações
test_notificacoes() {
    echo "📧 Testando sistema de notificações"
    echo "==================================="
    
    # Teste 1: Listar notificações
    make_request "GET" "/notificacoes" "" "Listar todas as notificações"
    
    # Teste 2: Buscar notificações por usuário
    make_request "GET" "/notificacoes/usuario/1" "" "Buscar notificações por usuário"
    
    # Teste 3: Buscar notificações por ocorrência
    make_request "GET" "/notificacoes/ocorrencia/1" "" "Buscar notificações por ocorrência"
}

# Testes de filtros e consultas especiais
test_filtros() {
    echo "🔍 Testando filtros e consultas especiais"
    echo "========================================="
    
    # Teste 1: Equipes disponíveis
    make_request "GET" "/equipes/disponiveis" "" "Buscar equipes disponíveis"
    
    # Teste 2: Equipes por região
    make_request "GET" "/equipes/regiao/São Paulo" "" "Buscar equipes por região"
    
    # Teste 3: Usuários por cidade
    make_request "GET" "/usuarios/cidade/1" "" "Buscar usuários por cidade"
    
    # Teste 4: Usuários por tipo
    make_request "GET" "/usuarios/tipo/BOMBEIRO" "" "Buscar usuários bombeiros"
    
    # Teste 5: Cidade por nome
    make_request "GET" "/cidades/nome/São Paulo" "" "Buscar cidade por nome"
}

# Testes de performance
test_performance() {
    echo "⚡ Testando performance da API"
    echo "============================="
    
    echo "📊 Fazendo 10 requisições simultâneas..."
    
    start_time=$(date +%s)
    
    for i in {1..10}; do
        curl -s "$BASE_URL/ocorrencias" > /dev/null &
    done
    
    wait
    
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    
    echo "   ⏱️  Tempo total: ${duration}s"
    echo "   📈 Throughput: $((10 / duration)) req/s"
}

# Testes de casos extremos
test_edge_cases() {
    echo "🎯 Testando casos extremos"
    echo "=========================="
    
    # Teste 1: Buscar recurso inexistente
    make_request "GET" "/ocorrencias/999999" "" "Buscar ocorrência inexistente (deve retornar 404)"
    
    # Teste 2: Dados inválidos
    dados_invalidos='{"severidade": 15, "descricao": ""}'
    make_request "POST" "/ocorrencias" "$dados_invalidos" "Tentar criar ocorrência com dados inválidos"
    
    # Teste 3: Endpoint inexistente
    make_request "GET" "/endpoint-inexistente" "" "Tentar acessar endpoint inexistente"
}

# Função para gerar relatório
generate_report() {
    echo ""
    echo "📊 RELATÓRIO DOS TESTES"
    echo "======================"
    echo "Timestamp: $TIMESTAMP"
    echo "Base URL: $BASE_URL"
    echo "Log completo: $LOG_FILE"
    echo ""
    
    total_tests=$(grep -c "Status:" "$LOG_FILE" || echo "0")
    success_tests=$(grep -c "Status: 2[0-9][0-9]" "$LOG_FILE" || echo "0")
    failed_tests=$((total_tests - success_tests))
    
    echo "Total de testes: $total_tests"
    echo "Sucessos: $success_tests"
    echo "Falhas: $failed_tests"
    
    if [ $failed_tests -eq 0 ]; then
        echo "🎉 Todos os testes passaram!"
    else
        echo "⚠️  Alguns testes falharam. Verifique o log para detalhes."
    fi
    
    echo ""
    echo "📋 Resumo por categoria:"
    
    # Analisa falhas por categoria
    if grep -q "❌" "$LOG_FILE"; then
        echo "   Falhas encontradas:"
        grep -B1 "❌" "$LOG_FILE" | grep "📡" | sed 's/📡 /   - /'
    fi
}

# Função principal
main() {
    echo "Iniciando testes da API FireWatch..." > "$LOG_FILE"
    echo "Timestamp: $TIMESTAMP" >> "$LOG_FILE"
    echo "Base URL: $BASE_URL" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    if ! check_api_health; then
        exit 1
    fi
    
    echo ""
    
    # Executa todos os testes
    test_basic_crud
    echo ""
    
    test_ocorrencias
    echo ""
    
    test_notificacoes
    echo ""
    
    test_filtros
    echo ""
    
    test_performance
    echo ""
    
    test_edge_cases
    echo ""
    
    generate_report
}

# Executa testes
main "$@"