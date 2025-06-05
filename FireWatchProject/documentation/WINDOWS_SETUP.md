# 🪟 FireWatch - Guia Completo para Windows

Este guia fornece instruções detalhadas para executar o FireWatch no Windows 10/11.

## 📋 Pré-requisitos

### Obrigatórios
- **Windows 10/11** (64-bit)
- **Docker Desktop** para Windows
- **Git** para Windows
- **PowerShell 5.1+** (incluído no Windows)

### Opcionais (para desenvolvimento nativo)
- **Java 17+** (OpenJDK recomendado)
- **Node.js 18+ LTS**
- **Python 3.11+**
- **Windows Terminal** (recomendado)

## 🚀 Instalação Rápida

### Opção 1: Instalação Automática com winget

```powershell
# Instalar todas as dependências de uma vez
winget install Docker.DockerDesktop
winget install Git.Git
winget install OpenJS.NodeJS
winget install EclipseAdoptium.Temurin.17.JDK
winget install Python.Python.3.11
winget install Microsoft.WindowsTerminal
```

### Opção 2: Instalação Manual

1. **Docker Desktop**
   - Download: https://docs.docker.com/desktop/install/windows/
   - Execute como Administrador
   - Reinicie o computador após instalação

2. **Git**
   - Download: https://git-scm.com/download/win
   - Use configurações padrão durante instalação

3. **Node.js** (opcional)
   - Download: https://nodejs.org/
   - Escolha versão LTS

4. **Java 17** (opcional)
   - Download: https://adoptium.net/
   - Escolha JDK 17 LTS

## 🔧 Configuração Inicial

### 1. Clone o Repositório

```powershell
# Abra PowerShell ou Windows Terminal
git clone https://github.com/seu-usuario/firewatch.git
cd firewatch
```

### 2. Execute o Setup

```powershell
cd src
.\quick_setup.bat
```

Este script irá:
- ✅ Verificar todas as dependências
- 📝 Criar arquivo `.env` com configurações padrão
- 💡 Mostrar próximos passos

## 🚀 Executando o FireWatch

### Opção 1: Docker (Recomendado)

**Execução Completa:**
```powershell
# Inicia todos os serviços
.\start_firewatch_windows.bat
```

**Verificar Status:**
```batch
docker-compose ps
```

### Opção 2: Serviços Individuais

**1. Banco de Dados:**
```powershell
.\start_database.bat
```

**2. Backend API:**
```powershell
.\start_backend.bat
```

**3. Frontend:**
```powershell
.\start_frontend.bat
```

**4. WhatsApp (opcional):**
```powershell
.\setup_whatsapp.bat
```

## 🌐 Acessando a Aplicação

Após iniciar os serviços:

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Frontend | http://localhost:3000 | Interface principal |
| Backend | http://localhost:8080 | API REST |
| Adminer | http://localhost:8081 | Admin banco de dados |
| Grafana | http://localhost:3001 | Monitoramento |

**Credenciais padrão:**
- Adminer: `firewatch_user` / `firewatch_pass`
- Grafana: `admin` / `firewatch123`

## 🧪 Testando a Instalação

```powershell
# Testar todos os endpoints da API
.\test_api.bat
```

Resultado esperado:
```
✅ Health Check
✅ Get All Cities  
✅ Get All Users
✅ Get All Teams
✅ Get All Incidents
```

## 📱 Configuração WhatsApp

### 1. Configurar Twilio

Edite o arquivo `.env`:
```powershell
notepad .env
```

Adicione suas credenciais:
```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxxxx  
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886
```

### 2. Instalar ngrok

```powershell
# Opção 1: winget
winget install ngrok.ngrok

# Opção 2: chocolatey
choco install ngrok

# Opção 3: Download manual
# https://ngrok.com/download
```

### 3. Configurar Webhook

```powershell
# Executa script completo de configuração
.\setup_whatsapp.bat
```

O script irá:
1. ✅ Verificar se backend está rodando
2. 🌐 Iniciar túnel ngrok
3. 📋 Copiar URL do webhook para clipboard
4. 💬 Mostrar instruções para Twilio Console

## 🛠️ Desenvolvimento

### Scripts Disponíveis

| Script | Função |
|--------|---------|
| `quick_setup.bat` | Setup inicial e verificação |
| `start_database.bat` | Inicia MySQL + Redis |
| `start_backend.bat` | Inicia Spring Boot API |
| `start_frontend.bat` | Inicia React app |
| `setup_whatsapp.bat` | Configura WhatsApp + ngrok |
| `stop_database.bat` | Para serviços de banco |
| `test_api.bat` | Testa todos endpoints |

### Desenvolvimento Nativo

**Backend:**
```powershell
cd src/backend
.\mvnw.cmd spring-boot:run
```

**Frontend:**
```powershell
cd src/frontend
npm install
npm start
```

**Simulador:**
```powershell
cd src/simulador
pip install -r requirements.txt
python simulador.py
```

## 🚨 Troubleshooting

### Problemas Comuns

**1. Docker não inicia**
```powershell
# Verificar se Docker Desktop está rodando
docker ps

# Se não funcionar:
# - Abrir Docker Desktop manualmente
# - Verificar se virtualização está habilitada no BIOS
# - Reiniciar computador
```

**2. Porta em uso**
```powershell
# Verificar o que está usando a porta 8080
netstat -ano | findstr :8080

# Matar processo se necessário
taskkill /PID <PID_NUMBER> /F
```

**3. PowerShell Execution Policy**
```powershell
# Se scripts não executam, configurar policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**4. Java não encontrado**
```powershell
# Verificar instalação
java -version

# Se não funcionar:
# - Reinstalar Java
# - Verificar variável JAVA_HOME
# - Adicionar Java ao PATH
```

**5. Node.js não encontrado**
```powershell
# Verificar instalação
node --version
npm --version

# Se não funcionar:
# - Reinstalar Node.js
# - Fechar e reabrir terminal
```

### Logs e Diagnóstico

**Docker logs:**
```powershell
# Ver logs de todos serviços
docker-compose logs -f

# Ver logs específicos
docker-compose logs firewatch-backend
docker-compose logs firewatch-frontend
```

**Verificar saúde dos serviços:**
```powershell
# API health check
Invoke-WebRequest http://localhost:8080/api/health

# Frontend check
Invoke-WebRequest http://localhost:3000
```

## 📚 Recursos Adicionais

### Ferramentas Úteis

- **Windows Terminal**: Interface moderna para PowerShell
- **VS Code**: Editor recomendado para desenvolvimento
- **Postman**: Testar APIs (import: `documentation/postman/`)
- **Docker Desktop**: Interface gráfica para containers

### Atalhos Windows

- `Win + R` → `cmd` ou `powershell`: Abrir terminal
- `Win + X` → `A`: PowerShell como Admin
- `Ctrl + Shift + Esc`: Gerenciador de Tarefas
- `Win + .`: Emojis (útil para commits)

### Links Úteis

- [Docker Desktop Download](https://docs.docker.com/desktop/install/windows/)
- [Node.js Download](https://nodejs.org/)
- [Java Download](https://adoptium.net/)
- [Git Download](https://git-scm.com/download/win)
- [ngrok Download](https://ngrok.com/download)

## 💡 Dicas de Performance

1. **SSD recomendado** para containers Docker
2. **Mínimo 8GB RAM** para execução completa
3. **Antivírus** pode interferir com Docker - adicionar exceções
4. **WSL2** oferece melhor performance que containers Windows

## 🔒 Considerações de Segurança

- Nunca commitar arquivo `.env` com credenciais reais
- Usar ngrok apenas para desenvolvimento
- Manter Docker Desktop atualizado
- Configurar firewall para portas necessárias

---

**Desenvolvido com ❤️ para Windows users**

🆘 **Precisa de ajuda?** Abra uma issue no GitHub ou consulte a documentação completa em `/documentation/`