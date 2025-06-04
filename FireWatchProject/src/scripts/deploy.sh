#!/bin/bash

# Script de deployment do FireWatch
# Uso: ./deploy.sh [environment] [version]

set -e

ENVIRONMENT=${1:-development}
VERSION=${2:-latest}
PROJECT_ROOT=$(dirname $(dirname $(readlink -f $0)))
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "🚀 FireWatch Deployment Script"
echo "==============================="
echo "Environment: $ENVIRONMENT"
echo "Version: $VERSION"
echo "Project Root: $PROJECT_ROOT"
echo "Timestamp: $TIMESTAMP"
echo ""

# Função para verificar pré-requisitos
check_prerequisites() {
    echo "🔍 Verificando pré-requisitos..."
    
    # Verifica Docker
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker não está instalado"
        exit 1
    fi
    
    # Verifica Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose não está instalado"
        exit 1
    fi
    
    # Verifica se arquivo .env existe
    if [ ! -f "$PROJECT_ROOT/.env" ]; then
        echo "⚠️  Arquivo .env não encontrado"
        echo "   Copiando .env.example para .env..."
        cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
        echo "   ✅ Configure o arquivo .env com suas credenciais antes de continuar"
        echo "   📝 Edite o arquivo: $PROJECT_ROOT/.env"
        exit 1
    fi
    
    echo "✅ Pré-requisitos verificados"
}

# Função para fazer backup
backup_data() {
    echo "💾 Fazendo backup dos dados..."
    
    BACKUP_DIR="$PROJECT_ROOT/backups/$TIMESTAMP"
    mkdir -p "$BACKUP_DIR"
    
    # Backup do banco de dados se estiver rodando
    if docker-compose ps firewatch-mysql | grep -q "Up"; then
        echo "   📊 Backup do MySQL..."
        docker-compose exec -T firewatch-mysql mysqldump -u firewatch_user -pfirewatch_pass firewatch > "$BACKUP_DIR/mysql_backup.sql"
    fi
    
    # Backup de logs
    if [ -d "$PROJECT_ROOT/logs" ]; then
        echo "   📝 Backup dos logs..."
        cp -r "$PROJECT_ROOT/logs" "$BACKUP_DIR/"
    fi
    
    echo "✅ Backup salvo em: $BACKUP_DIR"
}

# Função para deployment de desenvolvimento
deploy_development() {
    echo "🔧 Deployment para DESENVOLVIMENTO..."
    
    cd "$PROJECT_ROOT"
    
    # Para serviços existentes
    docker-compose down
    
    # Remove containers e volumes órfãos
    docker-compose down --remove-orphans -v
    
    # Rebuilda imagens
    docker-compose build --no-cache
    
    # Inicia serviços
    docker-compose up -d
    
    echo "✅ Deployment de desenvolvimento concluído"
    echo "🌐 Frontend: http://localhost:3000"
    echo "🔗 Backend: http://localhost:8080"
    echo "🗄️ Adminer: http://localhost:8081"
}

# Função para deployment de produção
deploy_production() {
    echo "🏭 Deployment para PRODUÇÃO..."
    
    cd "$PROJECT_ROOT"
    
    # Faz backup antes do deploy
    backup_data
    
    # Para serviços
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
    
    # Pull das imagens mais recentes
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull
    
    # Rebuilda apenas se necessário
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
    
    # Inicia serviços em produção
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    
    echo "✅ Deployment de produção concluído"
    echo "🌐 Aplicação: http://localhost"
    echo "📊 Grafana: http://localhost:3001"
    echo "📈 Prometheus: http://localhost:9090"
}

# Função para deployment de staging
deploy_staging() {
    echo "🧪 Deployment para STAGING..."
    
    cd "$PROJECT_ROOT"
    
    # Para serviços
    docker-compose -f docker-compose.yml -f docker-compose.staging.yml down
    
    # Inicia serviços de staging
    docker-compose -f docker-compose.yml -f docker-compose.staging.yml up -d
    
    echo "✅ Deployment de staging concluído"
}

# Função para verificar saúde dos serviços
check_health() {
    echo "🏥 Verificando saúde dos serviços..."
    
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "   Tentativa $attempt/$max_attempts..."
        
        # Verifica backend
        if curl -s http://localhost:8080/actuator/health > /dev/null; then
            echo "   ✅ Backend está saudável"
            break
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            echo "   ❌ Backend não está respondendo após $max_attempts tentativas"
            return 1
        fi
        
        sleep 10
        ((attempt++))
    done
    
    # Verifica frontend (se não for produção com nginx)
    if [ "$ENVIRONMENT" = "development" ]; then
        if curl -s http://localhost:3000 > /dev/null; then
            echo "   ✅ Frontend está saudável"
        else
            echo "   ⚠️  Frontend pode não estar acessível ainda"
        fi
    fi
    
    # Verifica banco de dados
    if docker-compose exec -T firewatch-mysql mysql -u firewatch_user -pfirewatch_pass -e "SELECT 1" firewatch > /dev/null 2>&1; then
        echo "   ✅ Banco de dados está saudável"
    else
        echo "   ⚠️  Banco de dados pode não estar pronto ainda"
    fi
    
    echo "✅ Verificação de saúde concluída"
}

# Função para executar testes pós-deployment
run_tests() {
    echo "🧪 Executando testes pós-deployment..."
    
    # Aguarda serviços ficarem prontos
    sleep 30
    
    # Executa testes da API
    if [ -f "$PROJECT_ROOT/scripts/test_api.sh" ]; then
        echo "   🔗 Testando API..."
        bash "$PROJECT_ROOT/scripts/test_api.sh" http://localhost:8080/api
    fi
    
    echo "✅ Testes concluídos"
}

# Função para mostrar logs
show_logs() {
    echo "📋 Logs dos serviços:"
    docker-compose logs --tail=50 -f
}

# Função para limpar recursos antigos
cleanup() {
    echo "🧹 Limpando recursos antigos..."
    
    # Remove imagens não utilizadas
    docker image prune -f
    
    # Remove volumes órfãos
    docker volume prune -f
    
    # Remove containers parados
    docker container prune -f
    
    echo "✅ Limpeza concluída"
}

# Função para rollback
rollback() {
    echo "🔄 Executando rollback..."
    
    if [ ! -d "$PROJECT_ROOT/backups" ]; then
        echo "❌ Nenhum backup encontrado para rollback"
        exit 1
    fi
    
    # Encontra backup mais recente
    LATEST_BACKUP=$(ls -1t "$PROJECT_ROOT/backups/" | head -n1)
    
    if [ -z "$LATEST_BACKUP" ]; then
        echo "❌ Nenhum backup válido encontrado"
        exit 1
    fi
    
    echo "   📦 Usando backup: $LATEST_BACKUP"
    
    # Para serviços
    docker-compose down
    
    # Restaura banco de dados
    if [ -f "$PROJECT_ROOT/backups/$LATEST_BACKUP/mysql_backup.sql" ]; then
        echo "   🗄️ Restaurando banco de dados..."
        docker-compose up -d firewatch-mysql
        sleep 20
        docker-compose exec -T firewatch-mysql mysql -u firewatch_user -pfirewatch_pass firewatch < "$PROJECT_ROOT/backups/$LATEST_BACKUP/mysql_backup.sql"
    fi
    
    # Inicia serviços
    docker-compose up -d
    
    echo "✅ Rollback concluído"
}

# Função para mostrar status
show_status() {
    echo "📊 Status dos serviços:"
    docker-compose ps
    
    echo ""
    echo "💾 Uso de recursos:"
    docker stats --no-stream
    
    echo ""
    echo "🌐 URLs disponíveis:"
    echo "   Frontend: http://localhost:3000"
    echo "   Backend: http://localhost:8080"
    echo "   API Docs: http://localhost:8080/swagger-ui.html"
    echo "   H2 Console: http://localhost:8080/h2-console"
    echo "   Adminer: http://localhost:8081"
    echo "   Grafana: http://localhost:3001"
    echo "   Prometheus: http://localhost:9090"
}

# Menu principal
show_menu() {
    echo ""
    echo "🔥 FireWatch Deployment Manager"
    echo "==============================="
    echo "1. Deploy Development"
    echo "2. Deploy Staging"
    echo "3. Deploy Production"
    echo "4. Check Health"
    echo "5. Run Tests"
    echo "6. Show Logs"
    echo "7. Show Status"
    echo "8. Cleanup"
    echo "9. Rollback"
    echo "10. Backup Data"
    echo "11. Exit"
    echo ""
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1) deploy_development ;;
        2) deploy_staging ;;
        3) deploy_production ;;
        4) check_health ;;
        5) run_tests ;;
        6) show_logs ;;
        7) show_status ;;
        8) cleanup ;;
        9) rollback ;;
        10) backup_data ;;
        11) echo "👋 Até logo!"; exit 0 ;;
        *) echo "❌ Opção inválida" ;;
    esac
}

# Função principal
main() {
    check_prerequisites
    
    # Se argumentos foram passados, executa diretamente
    if [ $# -gt 0 ]; then
        case $1 in
            development|dev) deploy_development ;;
            staging) deploy_staging ;;
            production|prod) deploy_production ;;
            health) check_health ;;
            test) run_tests ;;
            logs) show_logs ;;
            status) show_status ;;
            cleanup) cleanup ;;
            rollback) rollback ;;
            backup) backup_data ;;
            *) echo "❌ Ambiente inválido: $1"; exit 1 ;;
        esac
        
        # Executa verificação de saúde após deploy
        if [[ "$1" =~ ^(development|staging|production|dev|prod)$ ]]; then
            echo ""
            check_health
            show_status
        fi
    else
        # Menu interativo
        while true; do
            show_menu
        done
    fi
}

# Executa função principal
main "$@"