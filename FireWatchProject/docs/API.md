# 🔥 FireWatch API Documentation

Sistema de monitoramento e alerta de queimadas com backend Spring Boot.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Autenticação](#autenticação)
- [Endpoints](#endpoints)
  - [Cidades](#cidades)
  - [Usuários](#usuários)
  - [Equipes de Combate](#equipes-de-combate)
  - [Ocorrências](#ocorrências)
  - [Notificações](#notificações)
- [Modelos de Dados](#modelos-de-dados)
- [Códigos de Status](#códigos-de-status)
- [Exemplos de Uso](#exemplos-de-uso)

## 🌐 Visão Geral

**Base URL:** `http://localhost:8080/api`

**Formato de resposta:** JSON

**Charset:** UTF-8

### Headers necessários
```
Content-Type: application/json
Accept: application/json
```

## 🔐 Autenticação

Atualmente, a API não requer autenticação. Em produção, recomenda-se implementar JWT ou OAuth2.

## 📍 Endpoints

### Cidades

#### GET /api/cidades
Lista todas as cidades cadastradas.

**Resposta:**
```json
[
  {
    "id": 1,
    "nome": "São Paulo",
    "latitude": -23.5505,
    "longitude": -46.6333,
    "estado": "SP"
  }
]
```

#### GET /api/cidades/{id}
Busca cidade por ID.

**Parâmetros:**
- `id` (path) - ID da cidade

**Resposta:**
```json
{
  "id": 1,
  "nome": "São Paulo",
  "latitude": -23.5505,
  "longitude": -46.6333,
  "estado": "SP"
}
```

#### POST /api/cidades
Cadastra nova cidade.

**Body:**
```json
{
  "nome": "Nova Cidade",
  "latitude": -23.5505,
  "longitude": -46.6333,
  "estado": "SP"
}
```

#### PUT /api/cidades/{id}
Atualiza cidade existente.

#### DELETE /api/cidades/{id}
Remove cidade.

---

### Usuários

#### GET /api/usuarios
Lista todos os usuários.

#### GET /api/usuarios/{id}
Busca usuário por ID.

#### GET /api/usuarios/telefone/{telefone}
Busca usuário por telefone.

#### GET /api/usuarios/cidade/{cidadeId}
Lista usuários por cidade.

#### POST /api/usuarios
Cadastra novo usuário.

**Body:**
```json
{
  "nome": "João Silva",
  "telefone": "+5511999999999",
  "email": "joao@email.com",
  "tipoUsuario": "CIDADAO",
  "cidade": {
    "id": 1
  }
}
```

**Tipos de usuário:**
- `CIDADAO`
- `BOMBEIRO`
- `ADMINISTRADOR`

---

### Equipes de Combate

#### GET /api/equipes
Lista todas as equipes.

#### GET /api/equipes/disponiveis
Lista equipes disponíveis.

#### GET /api/equipes/regiao/{regiao}
Lista equipes por região.

#### POST /api/equipes
Cadastra nova equipe.

**Body:**
```json
{
  "nome": "Bombeiros SP - Zona Norte",
  "regiao": "São Paulo",
  "numeroMembros": 5,
  "tipoEquipamento": "Caminhão-pipa, equipamento básico"
}
```

#### PUT /api/equipes/{id}/status?status=DISPONIVEL
Atualiza status da equipe.

**Status possíveis:**
- `DISPONIVEL`
- `EM_ACAO`
- `INDISPONIVEL`

---

### Ocorrências

#### GET /api/ocorrencias
Lista todas as ocorrências.

**Query Parameters:**
- `status` - Filtrar por status
- `severidade` - Filtrar por severidade mínima
- `cidade` - Filtrar por cidade

#### GET /api/ocorrencias/{id}
Busca ocorrência por ID.

#### GET /api/ocorrencias/prioridade
Lista ocorrências ordenadas por prioridade.

#### POST /api/ocorrencias
Registra nova ocorrência.

**Body:**
```json
{
  "descricao": "Incêndio em mata atlântica",
  "severidade": 8,
  "latitude": -23.5505,
  "longitude": -46.6333,
  "cidade": {
    "id": 1,
    "nome": "São Paulo"
  }
}
```

**Severidade:** 1-10 (1 = baixa, 10 = crítica)

#### PUT /api/ocorrencias/{id}/atribuir-equipe/{equipeId}
Atribui equipe à ocorrência.

#### PUT /api/ocorrencias/{id}/finalizar
Finaliza ocorrência.

---

### Notificações

#### GET /api/notificacoes
Lista todas as notificações.

#### GET /api/notificacoes/usuario/{usuarioId}
Lista notificações de um usuário.

#### GET /api/notificacoes/ocorrencia/{ocorrenciaId}
Lista notificações de uma ocorrência.

---

## 📊 Modelos de Dados

### Cidade
```json
{
  "id": "number",
  "nome": "string",
  "latitude": "number",
  "longitude": "number",
  "estado": "string (2 caracteres)"
}
```

### Usuário
```json
{
  "id": "number",
  "nome": "string",
  "telefone": "string",
  "email": "string",
  "tipoUsuario": "CIDADAO|BOMBEIRO|ADMINISTRADOR",
  "cidade": "Cidade"
}
```

### Equipe de Combate
```json
{
  "id": "number",
  "nome": "string",
  "status": "DISPONIVEL|EM_ACAO|INDISPONIVEL",
  "regiao": "string",
  "numeroMembros": "number",
  "tipoEquipamento": "string"
}
```

### Ocorrência
```json
{
  "id": "number",
  "dataHora": "datetime",
  "severidade": "number (1-10)",
  "descricao": "string",
  "latitude": "number",
  "longitude": "number",
  "status": "ABERTA|EM_ATENDIMENTO|FINALIZADA",
  "cidade": "Cidade",
  "equipeResponsavel": "EquipeCombate?"
}
```

### Notificação
```json
{
  "id": "number",
  "mensagem": "string",
  "timestamp": "datetime",
  "status": "ENVIADA|FALHADA|PENDENTE",
  "tipoNotificacao": "WHATSAPP_ALERTA|SMS_ALERTA|EMAIL_ALERTA",
  "usuario": "Usuario",
  "ocorrencia": "Ocorrencia?"
}
```

## 🔄 Códigos de Status

| Código | Descrição |
|--------|-----------|
| 200 | OK - Sucesso |
| 201 | Created - Recurso criado |
| 400 | Bad Request - Dados inválidos |
| 404 | Not Found - Recurso não encontrado |
| 500 | Internal Server Error - Erro interno |

## 📝 Exemplos de Uso

### Cadastrar cidade e registrar ocorrência

```bash
# 1. Cadastrar cidade
curl -X POST http://localhost:8080/api/cidades \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Campinas",
    "latitude": -22.9099,
    "longitude": -47.0626,
    "estado": "SP"
  }'

# 2. Registrar ocorrência
curl -X POST http://localhost:8080/api/ocorrencias \
  -H "Content-Type: application/json" \
  -d '{
    "descricao": "Incêndio em área industrial",
    "severidade": 7,
    "latitude": -22.9099,
    "longitude": -47.0626,
    "cidade": {
      "id": 1,
      "nome": "Campinas"
    }
  }'
```

### Buscar ocorrências ativas

```bash
curl -X GET "http://localhost:8080/api/ocorrencias?status=ABERTA"
```

### Atribuir equipe a ocorrência

```bash
curl -X PUT http://localhost:8080/api/ocorrencias/1/atribuir-equipe/1
```

## 🧪 Collection do Postman

Para facilitar os testes, disponibilizamos uma collection do Postman em `docs/postman/FireWatch_API.postman_collection.json`.

## 🔍 Filtros e Paginação

### Filtros suportados

**Ocorrências:**
- `status`: ABERTA, EM_ATENDIMENTO, FINALIZADA
- `severidade`: número de 1 a 10
- `cidade`: ID da cidade

**Usuários:**
- `tipoUsuario`: CIDADAO, BOMBEIRO, ADMINISTRADOR
- `cidade`: ID da cidade

**Equipes:**
- `status`: DISPONIVEL, EM_ACAO, INDISPONIVEL
- `regiao`: nome da região

### Exemplos de filtros

```bash
# Ocorrências críticas (severidade >= 8)
GET /api/ocorrencias?severidade=8

# Equipes disponíveis em São Paulo
GET /api/equipes?status=DISPONIVEL&regiao=São Paulo

# Bombeiros de uma cidade específica
GET /api/usuarios?tipoUsuario=BOMBEIRO&cidade=1
```

## 🚨 Tratamento de Erros

### Estrutura de erro padrão

```json
{
  "timestamp": "2024-01-15T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Dados inválidos fornecidos",
  "path": "/api/ocorrencias"
}
```

### Erros comuns

| Erro | Causa | Solução |
|------|-------|---------|
| 400 | Dados inválidos | Verificar formato JSON e campos obrigatórios |
| 404 | Recurso não encontrado | Verificar se ID existe |
| 500 | Erro interno | Contatar administrador |

## 📊 Monitoramento

### Health Check

```bash
GET /actuator/health
```

### Métricas

```bash
GET /actuator/metrics
```

## 🔄 Integração com WhatsApp

O sistema integra automaticamente com a API do Twilio para envio de alertas via WhatsApp quando uma nova ocorrência é registrada.

### Configuração necessária

```properties
twilio.account.sid=your_account_sid
twilio.auth.token=your_auth_token
twilio.whatsapp.from=+14155238886
```

---

**Versão:** 1.0.0  
**Última atualização:** Janeiro 2024  
**Contato:** firewatch@exemplo.com