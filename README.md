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
│   └── *.sh / *.bat              # Scripts de execução
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

### 🪟 Windows

**📋 Siga exatamente esta ordem:**

#### **1. 🐳 Inicie o Docker Desktop**
Abra o Docker Desktop e aguarde até que ele esteja rodando.

#### **2. 🗄️ Inicie o Banco de Dados**
No terminal (cmd ou PowerShell), execute:
```bat
src\start_database.bat
```

#### **3. 🌐 Inicie o ngrok**
No terminal:
```bat
src\start_ngrok.bat
```
**Anote a URL gerada**, por exemplo:
```
https://abc123.ngrok-free.app
```

#### **4. 🔧 Configure o Twilio Console**
Acesse: https://console.twilio.com/  
Navegue: Messaging → Try it out → Send a WhatsApp message  
Configure o Sandbox:
- **When a message comes in:** `https://SUA_URL_NGROK.ngrok-free.app/api/webhook/whatsapp`
- **HTTP Method:** POST  
**Clique em SAVE CONFIGURATION**

#### **5. 💻 Inicie o Backend**
No terminal:
```bat
src\start_backend.bat
```
Aguarde até ver:
```
Started FirewatchApplication in X.XX seconds (JVM running for X.XX)
```

#### **6. 🌐 Inicie o Frontend**
No terminal:
```bat
cd src\frontend
npm install
cd ..
src\start_frontend.bat
```

🌐 **Acesse:** http://localhost:3000

---

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

---

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

---

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
A frase de ativação do WhatsApp (ex: `join pride-grandmother`) é fornecida pelo próprio painel do Twilio, na seção do Sandbox do WhatsApp.  
**Copie exatamente a frase exibida no painel Twilio** e envie para o número do Sandbox no WhatsApp para ativar seu acesso.

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
- **Linux:**  
  ```bash
  ./start_backend_low_memory.sh
  ```
- **Windows:**  
  ```bat
  src\start_backend_low_memory.bat
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

---

## ⚠️ Importante: Configuração das Credenciais Twilio

Para testar o código, é necessário criar uma conta gratuita na [Twilio](https://www.twilio.com/).  
Após criar sua conta, substitua as credenciais de exemplo no arquivo `.env` pelas suas credenciais reais da Twilio (SID, TOKEN, número do WhatsApp, etc).

Exemplo de variáveis no `.env`:
```
TWILIO_ACCOUNT_SID=SEU_SID_AQUI
TWILIO_AUTH_TOKEN=SEU_TOKEN_AQUI
TWILIO_WHATSAPP_NUMBER=SEU_NUMERO_AQUI
```

Sem isso, o envio e recebimento de mensagens WhatsApp não funcionará.

---

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
