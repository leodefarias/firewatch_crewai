# 🔥 FireWatch Project - Windows Setup Guide

Sistema integrado de monitoramento e alerta de queimadas com WhatsApp, desenvolvido para proteger comunidades brasileiras.

## 🚀 Início Rápido - Windows

### 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Docker Desktop** (Recomendado): https://www.docker.com/products/docker-desktop
- **Java 17+**: https://adoptium.net/
- **Node.js 18+**: https://nodejs.org/
- **Git**: https://git-scm.com/download/win
- **ngrok**: https://ngrok.com/download

### 🔧 Configuração Inicial

1. **Configure o ambiente**:
   ```batch
   cd src
   quick_setup.bat
   ```

2. **Edite as credenciais do Twilio**:
   ```batch
   notepad ..\env
   ```
   Configure:
   - `TWILIO_ACCOUNT_SID`
   - `TWILIO_AUTH_TOKEN`
   - `TWILIO_WHATSAPP_FROM`

### 🌐 Inicialização Passo a Passo

**📋 Siga exatamente esta ordem:**

#### **1. 🌐 Iniciar ngrok**
```batch
cd src
start_ngrok.bat
```

📋 **Anote a URL gerada (exemplo):**
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
```batch
# Opção 1: Normal
start_backend.bat

# Opção 2: Baixa memória (recomendado para PCs mais fracos)
start_backend_low_memory.bat
```

⏳ **Aguarde até ver:**
```
Started FirewatchApplication in X.XX seconds (JVM running for X.XX)
```

#### **4. 🌐 Iniciar Frontend**
```batch
# O script já instala as dependências automaticamente
start_frontend.bat
```

🌐 **Acesse:** http://localhost:3000

### 🐳 Alternativa com Docker (Recomendado)

1. **Inicie todos os serviços com Docker**:
   ```batch
   docker-compose up -d
   ```

2. **Para parar todos os serviços**:
   ```batch
   docker-compose down
   ```

## ✅ Verificação do Sistema

### **🔍 Testes Automatizados:**

**1. Teste completo da API:**
```batch
test_api.bat
```

**2. Teste específico do webhook:**
```batch
test_webhook.bat
```

**3. Teste de cadastro WhatsApp:**
```batch
test_whatsapp_cadastro.bat
```

### **🔍 Testes Manuais:**

**1. Backend funcionando:**
```batch
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

## 🛠️ Scripts Disponíveis

### 🚀 Inicialização:
- `start_firewatch.bat` - Inicia todos os serviços automaticamente
- `start_ngrok.bat` - Inicia apenas o túnel ngrok
- `start_backend.bat` - Inicia apenas o backend
- `start_backend_low_memory.bat` - Backend com configurações de baixa memória
- `start_frontend.bat` - Inicia apenas o frontend
- `start_database.bat` - Inicia apenas banco de dados (MySQL + Redis)

### 🛑 Parada:
- `stop_firewatch.bat` - Para todos os serviços
- `stop_ngrok.bat` - Para apenas o ngrok
- `stop_database.bat` - Para apenas o banco de dados

### 🧪 Testes:
- `test_api.bat` - Testa todos os endpoints da API
- `test_webhook.bat` - Testa especificamente o webhook
- `test_whatsapp_cadastro.bat` - Simula fluxo completo de cadastro

### 🔧 Configuração:
- `quick_setup.bat` - Configuração inicial e verificação de pré-requisitos
- `setup_whatsapp.bat` - Configuração completa do WhatsApp

## ❌ Solução de Problemas

### **❌ Backend erro de memória:**
```batch
start_backend_low_memory.bat
```

### **❌ Webhook não funciona:**
1. Verificar ngrok ativo
2. Verificar URL no Twilio
3. Verificar backend rodando
4. Recadastrar usuário

### **❌ Mapa não atualiza:**
- Aguardar 30 segundos
- Ou recarregar página (F5)

### **❌ Docker não inicia:**
1. Verificar se Docker Desktop está rodando
2. Verificar se portas não estão em uso
3. Reiniciar Docker Desktop

### **❌ Porta já em uso:**
```batch
# Verificar processos nas portas
netstat -an | findstr :8080
netstat -an | findstr :3000

# Parar todos os serviços
stop_firewatch.bat
```

## 🌐 Acesso aos Serviços

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:8080
- **Database Admin:** http://localhost:8081
- **ngrok Dashboard:** http://localhost:4040
- **Grafana (se usando Docker):** http://localhost:3001
- **Prometheus (se usando Docker):** http://localhost:9090

## 🆕 Novidades na Geocodificação

O sistema agora permite **denúncias por endereço**! Em vez de coordenadas GPS, você pode simplesmente informar:
- "Rua das Flores, 123, Centro, São Paulo, SP"
- O sistema converte automaticamente para coordenadas usando OpenStreetMap

## 📚 Diferenças do Linux

- Todos os scripts `.sh` foram convertidos para `.bat`
- Comandos de sistema adaptados para Windows
- Verificação de portas usando `netstat` em vez de `lsof`
- Processo kill usando `taskkill` em vez de `fuser`
- Paths adaptados para convenções Windows

## 🆘 Suporte

- **Documentação completa:** `documentation/`
- **Issues:** Reporte problemas no repositório
- **Logs:** Verificar console dos scripts para diagnóstico