# 📱 Como Usar o FireWatch via WhatsApp

## 🔥 Sistema de Denúncia de Incêndios via WhatsApp

O FireWatch permite reportar incêndios diretamente pelo WhatsApp de forma rápida e eficiente.

---

## ⚙️ Configuração Inicial do Sistema (Para Desenvolvedores)

**ANTES de usar o WhatsApp, configure o sistema nesta ordem:**

### **1. 🌐 Iniciar ngrok:**
```bash
./start_ngrok.sh
```
- Anote a URL gerada (ex: `https://abc123.ngrok-free.app`)

### **2. 🔧 Configurar Twilio Console:**
- Acesse: https://console.twilio.com/
- Vá em: **Messaging** → **Try it out** → **Send a WhatsApp message**
- Configure webhook: `https://SUA_URL_NGROK.ngrok-free.app/api/webhook/whatsapp`
- Método: **POST**
- Clique **Save Configuration**

### **3. 💻 Iniciar Backend:**
```bash
./start_backend.sh
# ou se tiver pouca memória:
./start_backend_low_memory.sh
```
- Aguarde até ver: `Started FirewatchApplication`

### **4. 🌐 Iniciar Frontend:**
```bash
./start_frontend.sh
```
- Acesse: http://localhost:3000

✅ **Sistema pronto para usar!**

---

## 📞 Número do FireWatch

**Adicione este número aos seus contatos:**
```
+1 (415) 523-8886
```

⚠️ **Importante:** Este é um número de sandbox do Twilio para demonstração.

---

## 🚀 Passo 1: Ativação no WhatsApp

**Antes de usar, você deve se juntar ao sandbox:**

Envie esta mensagem para ativar:
```
join yellow-dog
```

✅ **Você receberá uma confirmação quando ativado com sucesso.**

---

## 👤 Passo 2: Cadastro de Usuário

**⚠️ ATENÇÃO: Você precisa se cadastrar SEMPRE que o sistema reiniciar!**

**Na primeira vez (e após cada reinício), envie seus dados no formato EXATO:**

```
NOME: Seu Nome Completo
ENDERECO: Sua Rua, Número, Bairro
CIDADE: Sua Cidade
```

### 📝 Exemplo de Cadastro CORRETO:
```
NOME: João Silva
ENDERECO: Rua das Flores, 123, Centro
CIDADE: São Paulo
```

### ⚠️ **Regras CRÍTICAS:**
- Use **exatamente** `ENDERECO` (SEM acento, não `ENDEREÇO`)
- Use **exatamente** as palavras `NOME:`, `ENDERECO:`, `CIDADE:`
- Cada item em uma **linha separada** no WhatsApp
- **Não esqueça** os dois pontos (`:`) após cada palavra
- **Não adicione** espaços extras

### ❌ **ERRADO:**
```
ENDEREÇO: Rua das Flores, 123    ← COM acento
Nome: João Silva                 ← Minúscula
ENDERECO Rua das Flores         ← Sem dois pontos
```

### ✅ **CORRETO:**
```
NOME: João Silva
ENDERECO: Rua das Flores, 123, Centro
CIDADE: São Paulo
```

✅ **Você receberá uma confirmação de cadastro bem-sucedido:**
```
✅ Cadastro realizado com sucesso!

👤 Nome: João Silva
📍 Endereço: Rua das Flores, 123, Centro
🏙️ Cidade: São Paulo
📱 Telefone: +5511999999999

🔥 Agora você pode reportar incêndios!
📍 Envie sua localização ou coordenadas quando detectar um incêndio.
```

---

## 🔥 Passo 3: Denunciar Incêndios

**Após o cadastro bem-sucedido, você pode reportar incêndios de 3 formas:**

### 🎯 **Opção 1: Coordenadas GPS (100% Funcional - Mais Rápido)**
```
Incêndio! Lat: -23.5505, Long: -46.6333
```

⚡ **Vantagens:**
- ✅ Resposta imediata (menos de 1 segundo)
- ✅ Precisão máxima
- ✅ Funciona sempre

### 📍 **Opção 2: Compartilhar Localização (100% Funcional - Recomendado)**
1. Toque no clipe 📎
2. Selecione "Localização" 
3. Escolha "Localização atual"
4. Adicione descrição: `Incêndio florestal urgente!`

⚡ **Vantagens:**
- ✅ Mais fácil de usar
- ✅ WhatsApp envia coordenadas automaticamente
- ✅ Não precisa saber lat/long

### 🏠 **Opção 3: Endereço (90% Funcional - Mais Lento)**
```
Incêndio na Rua Augusta, 123, São Paulo
```

⚠️ **Limitações:**
- ⏱️ Pode demorar 3-5 segundos (geocodificação)
- 🌐 Depende do serviço OpenStreetMap
- 📍 Precisão pode variar

---

## 💬 Exemplos de Mensagens

### 🆘 **Emergência Grave:**
```
URGENTE! Incêndio descontrolado!
Lat: -23.5505, Long: -46.6333
Pessoas em risco!
```

### 🔥 **Incêndio Comum:**
```
Incêndio! Lat: -23.5505, Long: -46.6333
Fogo na vegetação
```

### 🚨 **Com Localização Compartilhada:**
```
[Compartilhar localização atual]
+ Texto: "Incêndio florestal! Fumaça densa!"
```

---

## ✅ O que Acontece Depois

### 📨 **Resposta Automática:**
Você receberá uma confirmação como:

```
🔥 FIREWATCH - Ocorrência registrada!

👤 Reportado por: João Silva
📍 Localização: -23.550500, -46.633300
🏙️ Cidade: São Paulo
⚠️ Severidade: 7/10
🆔 ID: 1

✅ Equipes de combate foram notificadas!
🚒 Aguarde o atendimento.

Obrigado por ajudar a proteger nossa comunidade! 🙏
```

### 🗺️ **No Sistema:**
- ✅ Sua denúncia aparece no mapa em tempo real
- 🚒 Equipes de combate são notificadas
- 📊 Dados são registrados para estatísticas
- 🔔 Outros usuários da região são alertados

---

## 🎯 Níveis de Severidade

O sistema avalia automaticamente a severidade baseado na sua mensagem:

| Palavras-chave | Severidade | Cor no Mapa |
|---------------|------------|--------------|
| `urgente`, `grande`, `descontrolado`, `emergência` | 9/10 | 🔴 Vermelho |
| `incêndio`, `fogo`, `queimada`, `fumaça` | 7/10 | 🟠 Laranja |
| `pequeno`, `controlado`, `suspeita` | 4/10 | 🟢 Verde |

---

## 🚫 O que NÃO Fazer

### ❌ **Evite:**
- Fazer denúncias falsas (pode gerar penalidades legais)
- Enviar mensagens sem localização
- Aproximar-se do fogo
- Tentar combater sozinho incêndios grandes

### ⚠️ **Importante:**
- Sempre ligue **193 (Bombeiros)** em emergências graves
- Mantenha-se em local seguro
- Siga orientações das autoridades

---

## 🔄 Reinicialização do Sistema

### **⚠️ ATENÇÃO: Sempre que o backend reiniciar:**

**1. 🔄 Você precisa se recadastrar** (banco H2 reseta)
**2. 🌐 Se ngrok reiniciar, atualizar URL no Twilio**

### **🚀 Ordem de Reinicialização:**
1. `./start_ngrok.sh` → Anotar nova URL
2. Atualizar webhook no Twilio Console
3. `./start_backend.sh` → Aguardar inicialização
4. `./start_frontend.sh` → Acessar localhost:3000
5. **Refazer cadastro no WhatsApp**

---

## 🧪 Como Testar

### 📝 **Teste de Conectividade:**
```
teste
```
*Deve receber resposta automática*

### 🗺️ **Teste com Coordenadas:**
```
Incêndio! Lat: -23.5505, Long: -46.6333
```
*Deve aparecer no mapa em até 30 segundos*

### 🏠 **Teste com Endereço:**
```
Incêndio na Av Paulista, 1000, São Paulo
```
*Pode demorar 3-5 segundos para processar*

### 🧪 **Teste Completo de Sistema:**
```
TESTE - Lat: -23.5505, Long: -46.6333
Esta é uma denúncia de teste, não é emergência real
```

⚠️ **Sempre marque como TESTE para evitar acionamento desnecessário!**

---

## ❓ Perguntas Frequentes

### **P: Preciso pagar para usar?**
**R:** Não! O serviço é completamente gratuito.

### **P: Funciona 24 horas?**
**R:** Sim, mas depende do servidor estar ativo.

### **P: E se eu não souber as coordenadas?**
**R:** Use o compartilhamento de localização do WhatsApp (mais fácil).

### **P: Posso reportar incêndios em outras cidades?**
**R:** Sim, basta informar a localização correta.

### **P: E se for alarme falso?**
**R:** Denúncias falsas podem gerar penalidades legais.

---

## 📞 Outros Números de Emergência

**Em situações graves, SEMPRE ligue também para:**
- **🚒 Bombeiros:** 193
- **🚑 SAMU:** 192
- **👮 Polícia:** 190

---

## 🆘 Suporte Técnico

### **Se tiver problemas:**
- ✅ Verifique se fez a ativação (`join yellow-dog`)
- ✅ Confirme o formato exato das mensagens
- ✅ Aguarde alguns segundos para processamento
- ✅ Verifique se tem conexão com internet

### **Para desenvolvedores:**
- 📊 Dashboard ngrok: http://localhost:4040
- 🌐 Frontend: http://localhost:3000
- 🔧 API: http://localhost:8080/api

---

## 🤝 Como Ajudar

**Compartilhe este sistema com:**
- 👨‍👩‍👧‍👦 Familiares e amigos
- 🏘️ Vizinhos da sua comunidade
- 📱 Grupos do WhatsApp
- 🌐 Redes sociais

**Juntos somos mais fortes contra os incêndios! 🔥🌳**

---

**🔥 FireWatch - Protegendo Nossa Floresta 🌳**

*Sistema desenvolvido para demonstração acadêmica com Twilio Sandbox*