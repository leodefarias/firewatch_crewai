# 🔥 FireWatch - Sistema de Monitoramento de Queimadas

**FireWatch** é uma plataforma completa para detectar, registrar e gerenciar ocorrências de incêndios e queimadas, utilizando tecnologias modernas como Spring Boot, React e notificações via WhatsApp através da API do Twilio.

## 🎯 Características Principais

- 🔥 **Detecção e Registro**: Sistema completo para registrar ocorrências de incêndio
- 📱 **Alertas WhatsApp**: Notificações automáticas via Twilio API
- 🗺️ **Mapa Interativo**: Visualização geográfica com React + Leaflet
- 🚒 **Gestão de Equipes**: Coordenação de equipes de combate
- 📊 **Simulação**: Sistema Python com algoritmos de priorização
- 🐳 **Containerizado**: Deploy completo com Docker

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React         │    │   Spring Boot   │    │   MySQL         │
│   Frontend      │◄──►│   Backend       │◄──►│   Database      │
│   (Port 3000)   │    │   (Port 8080)   │    │   (Port 3306)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │              ┌─────────────────┐              │
         │              │   Twilio API    │              │
         └──────────────┤   WhatsApp      │──────────────┘
                        │   Integration   │
                        └─────────────────┘
                                 │
         ┌─────────────────┐
         │   Python        │
         │   Simulator     │
         │   (Algorithms)  │
         └─────────────────┘
                                │
                        ┌─────────────────┐
                        │   Redis Cache   │
                        │   (Port 6379)   │
                        └─────────────────┘
```

## 🚀 Quick Start

### Pré-requisitos

**Para todos os sistemas:**
- Docker Desktop 20.10+
- Docker Compose 2.0+
- Git

**Para desenvolvimento nativo:**
- Node.js 18+ LTS (para desenvolvimento)
- Java 17+ (para desenvolvimento)
- Python 3.11+ (para desenvolvimento)

**Windows específico:**
- PowerShell 5.1+ (incluído no Windows 10/11)
- Windows Terminal (recomendado)
- Chocolatey ou winget (opcional, para instalação de ferramentas)

### Instalação Rápida

#### 🐧 Linux/macOS
```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/firewatch.git
cd firewatch

# 2. Configure e execute
cd src/
./quick_setup.sh

# 3. Execute com Docker
cd .. && docker-compose up
```

#### 🪟 Windows

**Opção 1: Docker (Recomendado)**
```powershell
# 1. Clone o repositório
git clone https://github.com/seu-usuario/firewatch.git
cd firewatch

# 2. Configure
cd src/
.\quick_setup.bat

# 3. Execute tudo de uma vez
.\start_firewatch_windows.bat
```

**Opção 2: Serviços Individuais**
```powershell
# Configure primeiro
.\quick_setup.bat

# Execute serviços separadamente
.\start_database.bat    # MySQL + Redis
.\start_backend.bat     # Spring Boot API  
.\start_frontend.bat    # React App
.\setup_whatsapp.bat    # WhatsApp + ngrok
```

#### 🌐 Acesso à Aplicação
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8080
- **Adminer**: http://localhost:8081
- **Grafana**: http://localhost:3001

## 📁 Estrutura do Projeto

```
FireWatchProject/
├── 📱 frontend/              # React + Leaflet
│   ├── src/
│   │   ├── components/       # Componentes React
│   │   ├── services/         # API clients
│   │   └── App.js           # Aplicação principal
│   ├── package.json
│   └── Dockerfile
│
├── 🏗️ backend/               # Spring Boot
│   ├── src/main/java/firewatch/
│   │   ├── controller/       # REST Controllers
│   │   ├── service/          # Business Logic
│   │   ├── repository/       # Data Access
│   │   └── domain/           # Entities
│   ├── pom.xml
│   └── Dockerfile
│
├── 🐍 simulador/             # Python Algorithms
│   ├── simulador.py          # Priority queues & algorithms
│   ├── requirements.txt
│   └── Dockerfile
│
├── 🗄️ database/              # Database setup
│   ├── docker-compose.yml
│   ├── init/                 # SQL scripts
│   └── backups/              # Database backups
│
├── 📚 docs/                  # Documentation
│   ├── API.md                # API documentation
│   └── postman/              # Postman collections
│
├── 🔧 scripts/               # Deployment & utility scripts
│   ├── deploy.sh             # Main deployment script
│   ├── setup_database.sh     # Database setup
│   └── test_api.sh           # API testing
│
├── docker-compose.yml        # Full stack deployment
├── .env.example              # Environment variables template
└── README.md                 # This file
```

## 🛠️ Desenvolvimento

### Backend (Spring Boot)

#### 🐧 Linux/macOS
```bash
cd backend
./mvnw spring-boot:run
```

#### 🪟 Windows
```powershell
cd backend
.\mvnw.cmd spring-boot:run
```

**Ou use o script Windows:**
```powershell
.\start_backend.bat
```

**Endpoints principais:**
- `GET /api/ocorrencias` - Lista ocorrências
- `POST /api/ocorrencias` - Registra nova ocorrência
- `GET /api/equipes` - Lista equipes de combate
- `GET /api/usuarios` - Lista usuários

### Frontend (React)

#### 🐧 Linux/macOS
```bash
cd frontend
npm install
npm start
```

#### 🪟 Windows
```powershell
cd frontend
npm install
npm start
```

**Ou use o script Windows:**
```powershell
.\start_frontend.bat
```

**Funcionalidades:**
- 🗺️ Mapa interativo com ocorrências
- 📝 Formulários de cadastro
- 📊 Dashboard com estatísticas
- 👥 Gestão de equipes e usuários

### Simulador (Python)

#### 🐧 Linux/macOS
```bash
cd simulador
pip install -r requirements.txt
python simulador.py
```

#### 🪟 Windows
```powershell
cd simulador
pip install -r requirements.txt
python simulador.py
```

**Características:**
- 🔢 Algoritmos de priorização (Heap, Queue)
- 📈 Simulação de atendimento
- 🎯 Otimização de recursos
- 📊 Análise de performance


## 🗄️ Banco de Dados

### Configuração Rápida

#### 🐧 Linux/macOS
```bash
# MySQL com Docker
./scripts/setup_database.sh mysql

# H2 para desenvolvimento
./scripts/setup_database.sh h2
```

#### 🪟 Windows
```powershell
# Iniciar banco de dados
.\start_database.bat

# Parar banco de dados
.\stop_database.bat
```

### Entidades Principais

- 🏙️ **Cidade**: Localização geográfica
- 👤 **Usuario**: Cidadãos, bombeiros, administradores
- 🚒 **EquipeCombate**: Equipes disponíveis
- 🔥 **Ocorrencia**: Registro de incêndios
- 📧 **Notificacao**: Histórico de alertas

## 📱 Integração WhatsApp (Twilio)

### Configuração

1. Crie conta no [Twilio](https://www.twilio.com/)
2. Configure WhatsApp Business API
3. Adicione credenciais no `.env`:

```env
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_WHATSAPP_FROM=+14155238886
```

4. Configure o webhook no Twilio Console:
   - URL: `https://seu-dominio.com/api/webhook/whatsapp`
   - Método: `POST`
   - Eventos: `Incoming Messages`

### 🚨 Reportar Incêndios via WhatsApp

Os usuários podem reportar incêndios enviando mensagens para o número do Twilio com:

**Opção 1: Localização do WhatsApp**
1. Envie a localização atual através do WhatsApp
2. Adicione descrição: "Incêndio grande!", "Fogo na floresta", etc.

**Opção 2: Coordenadas na mensagem**
```
Incêndio urgente! Lat: -23.5505, Long: -46.6333. Fogo descontrolado!
```

**Opção 3: Coordenadas com vírgula**
```
Socorro! Fogo aqui: -22.9068, -43.1729
```

### Exemplo de Alerta Automático

```
🔥 ALERTA FIREWATCH 🔥

Nova ocorrência detectada!
📍 Localização: São Paulo, SP
⚠️ Severidade: 8/10
📝 Descrição: Incêndio florestal
⏰ Data: 15/01/2024 14:30

Coordenadas: -23.5505, -46.6333
```

### Resposta Automática

```
🔥 FIREWATCH - Ocorrência registrada!

📍 Localização: -23.550500, -46.633300
🏙️ Cidade: São Paulo
⚠️ Severidade: 8/10
🆔 ID: 123

✅ Equipes de combate foram notificadas!
🚒 Aguarde o atendimento.
```

### Teste Local

#### 🐧 Linux/macOS
```bash
# Testar webhook localmente
./test_webhook.sh

# Usar ngrok para expor localhost
ngrok http 8080
# Configure webhook: https://xyz.ngrok.io/api/webhook/whatsapp
```

#### 🪟 Windows
```powershell
# Setup completo do WhatsApp
.\setup_whatsapp.bat

# Ou manualmente:
# 1. Instalar ngrok: winget install ngrok.ngrok
# 2. Executar: ngrok http 8080
# 3. Configurar webhook no Twilio Console
```

## 🧪 Testes

### Testes Automatizados

#### 🐧 Linux/macOS
```bash
# Backend (JUnit)
cd backend
./mvnw test

# Frontend (Jest)
cd frontend
npm test

# API Integration Tests
./scripts/test_api.sh
```

#### 🪟 Windows
```powershell
# Backend (JUnit)
cd backend
.\mvnw.cmd test

# Frontend (Jest)
cd frontend
npm test

# API Integration Tests
.\test_api.bat
```

### Postman Collection

Importe a collection em `docs/postman/FireWatch_API.postman_collection.json` para testar todos os endpoints.

## 🐳 Deploy com Docker

### Desenvolvimento

```bash
./scripts/deploy.sh development
```

### Produção

```bash
./scripts/deploy.sh production
```

### Serviços Disponíveis

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Frontend | http://localhost:3000 | Interface React |
| Backend | http://localhost:8080 | API Spring Boot |
| Adminer | http://localhost:8081 | Admin do banco |
| Grafana | http://localhost:3001 | Monitoramento |
| Prometheus | http://localhost:9090 | Métricas |

## 📊 Monitoramento

### Grafana Dashboards

- 🔥 **Ocorrências**: Métricas de incêndios
- 👥 **Equipes**: Performance das equipes
- 📱 **Notificações**: Taxa de entrega
- 🏥 **Sistema**: Saúde da aplicação

### Logs

```bash
# Logs em tempo real
docker-compose logs -f

# Logs específicos
docker-compose logs firewatch-backend
docker-compose logs firewatch-frontend
```


## 🔧 Configuração Avançada

### Variáveis de Ambiente

```env
# Banco de dados
DB_HOST=localhost
DB_PORT=3306
DB_NAME=firewatch

# Performance
THREAD_POOL_SIZE=10
CACHE_TTL_SECONDS=300

# Integração
WEBHOOK_URL_INCIDENT=https://api.exemplo.com/webhook
```

### Profiles Spring

- `development`: Desenvolvimento local
- `staging`: Ambiente de testes
- `production`: Produção
- `docker`: Containers Docker

## 🚨 Troubleshooting

### Problemas Comuns

**1. API não responde**
```bash
# Verificar logs
docker-compose logs firewatch-backend

# Verificar health
curl http://localhost:8080/actuator/health
```

**2. WhatsApp não envia**
```bash
# Verificar credenciais Twilio
echo $TWILIO_ACCOUNT_SID
echo $TWILIO_AUTH_TOKEN
```

**3. Banco não conecta**
```bash
# Verificar MySQL
docker-compose exec firewatch-mysql mysql -u firewatch_user -p
```

### Logs de Debug

```bash
# Ativar logs detalhados
export LOG_LEVEL=DEBUG
./scripts/deploy.sh development
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit: `git commit -m 'Add nova funcionalidade'`
4. Push: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

### Padrões de Código

- **Java**: Google Java Style Guide
- **JavaScript**: ESLint + Prettier
- **Python**: PEP 8
- **Commits**: Conventional Commits

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

## 🆘 Suporte

- 📧 **Email**: firewatch@exemplo.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/seu-usuario/firewatch/issues)
- 📚 **Docs**: [Wiki do Projeto](https://github.com/seu-usuario/firewatch/wiki)
- 💬 **Chat**: [Discord](https://discord.gg/firewatch)

## 🙏 Agradecimentos

- [Spring Boot](https://spring.io/projects/spring-boot)
- [React](https://reactjs.org/)
- [Leaflet](https://leafletjs.com/)
- [Twilio](https://www.twilio.com/)
- [Docker](https://www.docker.com/)

---

**Desenvolvido com ❤️ para salvar vidas e proteger o meio ambiente**

🔥 **FireWatch** - *Tecnologia a serviço da prevenção*