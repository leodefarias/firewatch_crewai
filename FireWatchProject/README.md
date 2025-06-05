# 🔥 FireWatch Project

Sistema integrado de monitoramento e alerta de queimadas com WhatsApp, desenvolvido para proteger comunidades brasileiras.

## 📁 Estrutura do Projeto

```
FireWatchProject/
├── src/                          # Código executável
│   ├── backend/                  # API Spring Boot
│   ├── frontend/                 # Interface React
│   ├── database/                 # Scripts de banco de dados
│   ├── simulador/                # Simulador Python
│   ├── scripts/                  # Scripts de automação
│   └── *.sh                      # Scripts de execução
├── documentation/                # Documentação
│   ├── README.md                # Documentação principal
│   ├── SETUP_WHATSAPP.md        # Configuração WhatsApp
│   ├── API.md                   # Documentação da API
│   ├── database_design.md       # Design do banco
│   └── *.pdf, *.docx           # Outros documentos
├── docker-compose.yml           # Orquestração dos serviços
└── .env                        # Variáveis de ambiente
```

## 🚀 Início Rápido

### 🐧 Linux/macOS
1. **Clone e configure**:
   ```bash
   cd src/
   ./quick_setup.sh
   ```

2. **Execute com Docker**:
   ```bash
   docker-compose up
   ```

### 🪟 Windows
1. **Setup rápido**:
   ```powershell
   cd src/
   .\quick_setup.bat
   ```

2. **Iniciar com Docker**:
   ```batch
   .\start_firewatch_windows.bat
   ```

   **Ou executar serviços individuais**:
   ```powershell
   .\start_database.bat    # MySQL + Redis
   .\start_backend.bat     # Spring Boot API
   .\start_frontend.bat    # React App
   ```

### 🌐 Acesso
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- Documentação: `/documentation/`

## 🆕 Novidades na Geocodificação

O sistema agora permite **denúncias por endereço**! Em vez de coordenadas GPS, você pode simplesmente informar:
- "Rua das Flores, 123, Centro, São Paulo, SP"
- O sistema converte automaticamente para coordenadas usando OpenStreetMap

## 📱 WhatsApp Integration

Configure o WhatsApp seguindo: `documentation/SETUP_WHATSAPP.md`

## 📚 Documentação

Toda documentação está em `documentation/`:
- Configuração e setup
- API endpoints  
- Design do banco de dados
- Diagramas e especificações

## 🛠️ Desenvolvimento

### 📋 Pré-requisitos

**Para todos os sistemas:**
- Docker Desktop 20.10+
- Git

**Para desenvolvimento nativo:**
- Java 17+ (OpenJDK recomendado)
- Node.js 18+ LTS
- Python 3.11+

**Windows específico:**
- PowerShell 5.1+ (já incluso no Windows 10/11)
- Windows Subsystem for Linux (WSL2) - opcional

### 🔧 Tecnologias
- **Backend**: `src/backend/` - Spring Boot + Java 17
- **Frontend**: `src/frontend/` - React + Bootstrap
- **Database**: MySQL + Redis
- **Integração**: Twilio WhatsApp API

### 🧪 Scripts de Teste

**Linux/macOS:**
```bash
./test_api.sh
```

**Windows:**
```powershell
.\test_api.bat
```