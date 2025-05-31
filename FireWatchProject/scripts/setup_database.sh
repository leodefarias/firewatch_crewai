#!/bin/bash

# Script de configuração do banco de dados FireWatch
# Uso: ./setup_database.sh [mysql|postgres|h2]

set -e

DATABASE_TYPE=${1:-mysql}
PROJECT_ROOT=$(dirname $(dirname $(readlink -f $0)))

echo "🔥 FireWatch Database Setup"
echo "=========================="
echo "Tipo de banco: $DATABASE_TYPE"
echo "Diretório do projeto: $PROJECT_ROOT"
echo ""

# Função para verificar se o Docker está rodando
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
        exit 1
    fi
    echo "✅ Docker está rodando"
}

# Função para configurar MySQL
setup_mysql() {
    echo "🐬 Configurando MySQL..."
    
    cd "$PROJECT_ROOT/database"
    
    # Para e remove containers existentes
    docker-compose down -v 2>/dev/null || true
    
    # Inicia MySQL
    docker-compose up -d mysql-firewatch
    
    # Aguarda o MySQL ficar disponível
    echo "⏳ Aguardando MySQL ficar disponível..."
    for i in {1..30}; do
        if docker-compose exec -T mysql-firewatch mysql -u firewatch_user -pfirewatch_pass -e "SELECT 1" firewatch > /dev/null 2>&1; then
            echo "✅ MySQL está pronto!"
            break
        fi
        echo "   Tentativa $i/30..."
        sleep 5
    done
    
    # Executa scripts adicionais se necessário
    if [ -f "$PROJECT_ROOT/database/init/additional_data.sql" ]; then
        echo "📊 Executando dados adicionais..."
        docker-compose exec -T mysql-firewatch mysql -u firewatch_user -pfirewatch_pass firewatch < "$PROJECT_ROOT/database/init/additional_data.sql"
    fi
    
    echo "✅ MySQL configurado com sucesso!"
    echo "🌐 Acesso via Adminer: http://localhost:8081"
    echo "🌐 Acesso via phpMyAdmin: http://localhost:8082"
    echo ""
    echo "Credenciais:"
    echo "  Host: localhost:3306"
    echo "  Database: firewatch"
    echo "  User: firewatch_user"
    echo "  Password: firewatch_pass"
}

# Função para configurar PostgreSQL
setup_postgres() {
    echo "🐘 Configurando PostgreSQL..."
    
    cd "$PROJECT_ROOT/database"
    
    # Para e remove containers existentes
    docker-compose down -v 2>/dev/null || true
    
    # Inicia PostgreSQL
    docker-compose up -d postgres-firewatch
    
    # Aguarda o PostgreSQL ficar disponível
    echo "⏳ Aguardando PostgreSQL ficar disponível..."
    for i in {1..30}; do
        if docker-compose exec -T postgres-firewatch pg_isready -U firewatch_user -d firewatch > /dev/null 2>&1; then
            echo "✅ PostgreSQL está pronto!"
            break
        fi
        echo "   Tentativa $i/30..."
        sleep 3
    done
    
    echo "✅ PostgreSQL configurado com sucesso!"
    echo "🌐 Acesso via Adminer: http://localhost:8081"
    echo ""
    echo "Credenciais:"
    echo "  Host: localhost:5432"
    echo "  Database: firewatch"
    echo "  User: firewatch_user"
    echo "  Password: firewatch_pass"
}

# Função para configurar H2 (desenvolvimento)
setup_h2() {
    echo "🗄️ Configurando H2 (banco em memória)..."
    
    # H2 é configurado automaticamente pelo Spring Boot
    # Apenas atualiza o application.properties
    
    cat > "$PROJECT_ROOT/backend/src/main/resources/application-dev.properties" << EOF
# H2 Development Configuration
spring.datasource.url=jdbc:h2:mem:firewatch
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=password

spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.defer-datasource-initialization=true
spring.sql.init.mode=always

spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
spring.h2.console.settings.web-allow-others=true

# Twilio Configuration
twilio.account.sid=\${TWILIO_ACCOUNT_SID:your_account_sid}
twilio.auth.token=\${TWILIO_AUTH_TOKEN:your_auth_token}
twilio.whatsapp.from=\${TWILIO_WHATSAPP_FROM:+14155238886}

server.port=8080
EOF
    
    echo "✅ H2 configurado com sucesso!"
    echo "🌐 Console H2: http://localhost:8080/h2-console"
    echo ""
    echo "Credenciais H2:"
    echo "  JDBC URL: jdbc:h2:mem:firewatch"
    echo "  User: sa"
    echo "  Password: password"
}

# Função para configurar produção
setup_production() {
    echo "🏭 Configurando ambiente de produção..."
    
    cat > "$PROJECT_ROOT/backend/src/main/resources/application-prod.properties" << EOF
# Production Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/firewatch?useSSL=true&serverTimezone=UTC
spring.datasource.username=firewatch_user
spring.datasource.password=firewatch_pass
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=false
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect

# Security
spring.sql.init.mode=never
spring.h2.console.enabled=false

# Production Twilio
twilio.account.sid=\${TWILIO_ACCOUNT_SID}
twilio.auth.token=\${TWILIO_AUTH_TOKEN}
twilio.whatsapp.from=\${TWILIO_WHATSAPP_FROM}

# Performance
spring.jpa.properties.hibernate.jdbc.batch_size=25
spring.jpa.properties.hibernate.order_inserts=true
spring.jpa.properties.hibernate.order_updates=true
spring.jpa.properties.hibernate.jdbc.batch_versioned_data=true

server.port=8080
logging.level.org.springframework.web=WARN
logging.level.org.hibernate=WARN
EOF
    
    echo "✅ Configuração de produção criada!"
}

# Função para iniciar todos os serviços
start_all_services() {
    echo "🚀 Iniciando todos os serviços..."
    
    cd "$PROJECT_ROOT/database"
    docker-compose up -d
    
    echo "⏳ Aguardando todos os serviços ficarem disponíveis..."
    sleep 10
    
    echo "✅ Serviços disponíveis:"
    echo "🐬 MySQL: localhost:3306"
    echo "🐘 PostgreSQL: localhost:5432"
    echo "🗄️ Redis: localhost:6379"
    echo "🌐 Adminer: http://localhost:8081"
    echo "🌐 phpMyAdmin: http://localhost:8082"
}

# Função para parar serviços
stop_services() {
    echo "🛑 Parando serviços..."
    cd "$PROJECT_ROOT/database"
    docker-compose down
    echo "✅ Serviços parados"
}

# Função para verificar status
check_status() {
    echo "📊 Status dos serviços:"
    cd "$PROJECT_ROOT/database"
    docker-compose ps
}

# Função para backup
backup_database() {
    echo "💾 Fazendo backup do banco de dados..."
    
    BACKUP_DIR="$PROJECT_ROOT/backups"
    mkdir -p "$BACKUP_DIR"
    
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    
    case $DATABASE_TYPE in
        mysql)
            docker-compose exec -T mysql-firewatch mysqldump -u firewatch_user -pfirewatch_pass firewatch > "$BACKUP_DIR/firewatch_mysql_$TIMESTAMP.sql"
            ;;
        postgres)
            docker-compose exec -T postgres-firewatch pg_dump -U firewatch_user firewatch > "$BACKUP_DIR/firewatch_postgres_$TIMESTAMP.sql"
            ;;
    esac
    
    echo "✅ Backup salvo em: $BACKUP_DIR/firewatch_${DATABASE_TYPE}_$TIMESTAMP.sql"
}

# Menu principal
show_menu() {
    echo ""
    echo "🔥 FireWatch Database Manager"
    echo "============================"
    echo "1. Configurar MySQL"
    echo "2. Configurar PostgreSQL"
    echo "3. Configurar H2 (desenvolvimento)"
    echo "4. Configurar Produção"
    echo "5. Iniciar todos os serviços"
    echo "6. Parar serviços"
    echo "7. Verificar status"
    echo "8. Fazer backup"
    echo "9. Sair"
    echo ""
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1) setup_mysql ;;
        2) setup_postgres ;;
        3) setup_h2 ;;
        4) setup_production ;;
        5) start_all_services ;;
        6) stop_services ;;
        7) check_status ;;
        8) backup_database ;;
        9) echo "👋 Até logo!"; exit 0 ;;
        *) echo "❌ Opção inválida" ;;
    esac
}

# Função principal
main() {
    check_docker
    
    # Se argumento foi passado, executa diretamente
    if [ $# -gt 0 ]; then
        case $1 in
            mysql) setup_mysql ;;
            postgres) setup_postgres ;;
            h2) setup_h2 ;;
            production) setup_production ;;
            start) start_all_services ;;
            stop) stop_services ;;
            status) check_status ;;
            backup) backup_database ;;
            *) echo "❌ Opção inválida: $1"; exit 1 ;;
        esac
    else
        # Menu interativo
        while true; do
            show_menu
        done
    fi
}

# Executa função principal
main "$@"