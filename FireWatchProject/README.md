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

### 🐧 Linux (Recomendado)

**📋 Siga exatamente esta ordem:**

#### **1. 🌐 Iniciar ngrok**
```bash
cd src
./start_ngrok.sh
```

📋 **Anote a URL gerada:**
```
https://abc123.ngrok-free.app
```

#### **2. 🔧 Configurar Twilio Console**
**🌐 Acesse:** https://console.twilio.com/
**📱 Navegue:** Messaging → Try it out → Send a WhatsApp message
**⚙️ Configure Sandbox:**
- **When a message comes in:** `https://SUA_URL_NGROK.ngrok-free.app/api/webhook/whatsapp`
- **HTTP Method:** POST
- **🔴 CLIQUE SAVE CONFIGURATION**

#### **3. 💻 Iniciar Backend**
```bash
# Opção 1: Normal
./start_backend.sh

# Opção 2: Baixa memória (recomendado)
./start_backend_low_memory.sh
```

⏳ **Aguarde até ver:**
```
Started FirewatchApplication in X.XX seconds (JVM running for X.XX)
```

#### **4. 🌐 Iniciar Frontend**
```bash
# Instalar dependências (primeira vez)
cd frontend
npm install
cd ..

# Iniciar aplicação
./start_frontend.sh
```

🌐 **Acesse:** http://localhost:3000

### 🐧 Linux/macOS (Alternativo com Docker)
1. **Clone e configure**:
   ```bash
   cd src/
   ./quick_setup.sh
   ```

2. **Execute com Docker**:
   ```bash
   docker-compose up
   ```

### 🌐 Acesso
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- Documentação: `/documentation/`

## ✅ Verificação do Sistema

### **🔍 Testes Rápidos:**

**1. Backend funcionando:**
```bash
curl http://localhost:8080/api/health
# Deve retornar: "FireWatch API is running!"
```

**2. ngrok ativo:**
- Dashboard: http://localhost:4040
- Deve mostrar túnel ativo

**3. Frontend carregando:**
- http://localhost:3000
- Deve mostrar mapa e interface

## 📱 Uso no WhatsApp

### **🚀 Ativação (uma vez só):**
```
join pride-grandmother
```

### **👤 Cadastro (sempre que reiniciar):**
```
NOME: Seu Nome ENDERECO: Seu Endereço (SEM acento) CIDADE: Sua Cidade
```

### **🔥 Denúncia:**
```
(Endereço da Denúncia)
```

### **❌ Backend erro 137 (memória):**
```bash
./start_backend_low_memory.sh
```

### **❌ Webhook não funciona:**
1. Verificar ngrok ativo
2. Verificar URL no Twilio
3. Verificar backend rodando
4. Recadastrar usuário

### **❌ Mapa não atualiza:**
- Aguardar 30 segundos
- Ou recarregar página (F5)

## 🆕 Novidades na Geocodificação

O sistema agora permite **denúncias por endereço**! Em vez de coordenadas GPS, você pode simplesmente informar:
- "Rua das Flores, 123, Centro, São Paulo, SP"
- O sistema converte automaticamente para coordenadas usando OpenStreetMap
## 🛠️ Desenvolvimento

### 📋 Pré-requisitos

**Para todos os sistemas:**
- Docker Desktop 20.10+
- Git

**Para desenvolvimento nativo:**
- Java 17+ (OpenJDK recomendado)
- Node.js 18+ LTS
- Python 3.11+

### 🔧 Tecnologias
- **Backend**: `src/backend/` - Spring Boot + Java 17
- **Frontend**: `src/frontend/` - React + Bootstrap
- **Database**: MySQL + Redis
- **Integração**: Twilio WhatsApp API
