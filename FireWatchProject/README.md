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

1. **Clone e configure**:
   ```bash
   cd src/
   ./quick_setup.sh
   ```

2. **Execute com Docker**:
   ```bash
   docker-compose up
   ```

3. **Acesse**:
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

- **Backend**: `src/backend/` - Spring Boot + Java 17
- **Frontend**: `src/frontend/` - React + Bootstrap
- **Database**: MySQL + Redis
- **Integração**: Twilio WhatsApp API