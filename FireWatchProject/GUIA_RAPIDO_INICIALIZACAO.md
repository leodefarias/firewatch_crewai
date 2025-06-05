# 🚀 Guia Rápido de Inicialização do FireWatch

## ⚡ Checklist de Startup (Siga EXATAMENTE nesta ordem)

### **1. 🌐 Iniciar ngrok**
```bash
cd src
./start_ngrok.sh
```

📋 **Anote a URL gerada:**
```
https://abc123.ngrok-free.app
```

### **2. 🔧 Configurar Twilio Console**

**🌐 Acesse:** https://console.twilio.com/

**📱 Navegue:** Messaging → Try it out → Send a WhatsApp message

**⚙️ Configure Sandbox:**
- **When a message comes in:** `https://SUA_URL_NGROK.ngrok-free.app/api/webhook/whatsapp`
- **HTTP Method:** POST
- **🔴 CLIQUE SAVE CONFIGURATION**

### **3. 💻 Iniciar Backend**
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

### **4. 🌐 Iniciar Frontend**
```bash
./start_frontend.sh
```

🌐 **Acesse:** http://localhost:3000

---

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

---

## 📱 Uso no WhatsApp

### **🚀 Ativação (uma vez só):**
```
join yellow-dog
```

### **👤 Cadastro (sempre que reiniciar):**
```
NOME: Seu Nome
ENDERECO: Seu Endereço (SEM acento)
CIDADE: Sua Cidade
```

### **🔥 Denúncia:**
```
Incêndio! Lat: -23.5505, Long: -46.6333
```

---

## 🆘 Troubleshooting

### **❌ ngrok offline:**
```bash
./stop_ngrok.sh
./start_ngrok.sh
# Atualizar URL no Twilio
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

---

## 🔄 Fluxo Completo de Teste

### **1. Sistema inicializado → 2. WhatsApp ativado → 3. Usuário cadastrado → 4. Denúncia enviada → 5. Mapa atualizado**

**Tempo total:** ~2-3 minutos

---

## 📊 Status dos Componentes

| Componente | Status | Comando Verificação |
|------------|--------|-------------------|
| ngrok | ✅ | `curl localhost:4040` |
| Backend | ✅ | `curl localhost:8080/api/health` |
| Frontend | ✅ | Abrir `localhost:3000` |
| WhatsApp | ✅ | Enviar "teste" |
| Database | ✅ | Automático com backend |

---

## 🎯 Resumo Final

**🟢 Funcional 100%:**
- Webhook WhatsApp → Backend
- Cadastro de usuários  
- Coordenadas GPS
- Compartilhamento de localização
- Mapa em tempo real

**🟡 Funcional 90%:**
- Geocodificação de endereços (pode ser lenta)

**🔴 Limitações:**
- H2 Database (reseta ao reiniciar)
- ngrok URL muda a cada restart

---

**🎉 Sistema pronto para demonstração acadêmica!**