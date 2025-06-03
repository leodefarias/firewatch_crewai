# Database Design - FireWatch System
## Documentação Técnica para Diagrama Entidade-Relacionamento

---

## 1. Descritivo do Projeto (10 pontos)

### 1.1 Justificativa e Objetivos

O **FireWatch** é um sistema integrado de monitoramento e combate às queimadas, desenvolvido para atender à crescente necessidade de resposta rápida e eficiente às ocorrências de incêndios no Brasil. Com o aumento das queimadas e seus impactos ambientais, sociais e econômicos, é fundamental ter uma plataforma tecnológica que integre detecção, coordenação de equipes e comunicação com a população.

### 1.2 Contexto e Desafios

O sistema foi concebido para abordar os seguintes desafios:

- **Detecção rápida**: Permitir que cidadãos reportem focos de incêndio via WhatsApp
- **Coordenação eficiente**: Gerenciar equipes de combate e seus recursos
- **Comunicação efetiva**: Notificar automaticamente usuários sobre situações de risco
- **Monitoramento geográfico**: Utilizar coordenadas GPS para localização precisa
- **Histórico de dados**: Manter registro completo para análise de padrões e prevenção

### 1.3 Objetivos Específicos

1. **Facilitar o reporte de ocorrências** através de múltiplos canais (WhatsApp, web, API)
2. **Otimizar a alocação de recursos** priorizando ocorrências por severidade e localização
3. **Garantir comunicação efetiva** com alertas automáticos para usuários em áreas de risco
4. **Prover visibilidade operacional** através de dashboards e relatórios
5. **Integrar dados geográficos** para análise espacial e tomada de decisão

---

## 2. Identificação das Entidades (10 pontos)

O modelo de dados do FireWatch foi estruturado com **7 entidades principais** que representam os elementos fundamentais do domínio de combate às queimadas:

### 2.1 Entidade: CIDADE
**Significado no mundo real**: Representa as unidades administrativas municipais que são monitoradas pelo sistema. Cada cidade possui coordenadas geográficas específicas e está vinculada a um estado, permitindo a localização precisa das ocorrências e a organização territorial das operações de combate.

### 2.2 Entidade: USUARIO
**Significado no mundo real**: Representa as pessoas que interagem com o sistema, incluindo três tipos principais: cidadãos comuns que reportam ocorrências, bombeiros que atuam no combate, e administradores que gerenciam o sistema. Cada usuário possui informações de contato essenciais para comunicação e está associado a uma cidade específica.

### 2.3 Entidade: EQUIPE_COMBATE
**Significado no mundo real**: Representa as unidades operacionais responsáveis pelo combate direto aos incêndios. Cada equipe possui recursos específicos (veículos, equipamentos), uma área de atuação definida, e um status operacional que determina sua disponibilidade para atendimento.

### 2.4 Entidade: OCORRENCIA
**Significado no mundo real**: Representa os registros de incêndios ou queimadas detectadas no sistema. Cada ocorrência contém informações críticas como localização GPS, nível de severidade, descrição detalhada e status de atendimento, servindo como o núcleo central para coordenação das ações de combate.

### 2.5 Entidade: NOTIFICACAO
**Significado no mundo real**: Representa as comunicações enviadas aos usuários sobre ocorrências, alertas de risco ou atualizações de status. Inclui diferentes tipos de notificação (WhatsApp, SMS, email) e mantém controle sobre entrega e confirmação de leitura.

### 2.6 Entidade: LOG_ACAO
**Significado no mundo real**: Representa o registro histórico de todas as ações realizadas no sistema, proporcionando auditoria completa e rastreabilidade das operações. Essencial para conformidade, análise de desempenho e investigação de incidentes.

### 2.7 Entidade: RECURSO_EQUIPE
**Significado no mundo real**: Representa os equipamentos, veículos e materiais disponíveis para cada equipe de combate. Inclui controle de manutenção, status de disponibilidade e quantidades, permitindo gestão eficiente dos recursos operacionais.

---

## 3. Identificação dos Atributos (20 pontos)

### 3.1 Entidade: CIDADE

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada cidade no sistema | ✅ **PK** |
| nome | VARCHAR(100) | Nome oficial da cidade conforme registro municipal | |
| latitude | DOUBLE PRECISION | Coordenada geográfica para localização no mapa | |
| longitude | DOUBLE PRECISION | Coordenada geográfica para localização no mapa | |
| estado | VARCHAR(2) | Sigla do estado brasileiro (SP, RJ, MG, etc.) | |
| created_at | TIMESTAMP | Data e hora de cadastro da cidade no sistema | |
| updated_at | TIMESTAMP | Data e hora da última atualização dos dados | |

### 3.2 Entidade: USUARIO

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada usuário | ✅ **PK** |
| nome | VARCHAR(150) | Nome completo da pessoa | |
| telefone | VARCHAR(20) | Número de telefone para contato (WhatsApp/SMS) | |
| email | VARCHAR(150) | Endereço de email para notificações | |
| endereco | VARCHAR(250) | Endereço residencial completo | |
| tipo_usuario | ENUM | Perfil de acesso: CIDADAO, BOMBEIRO, ADMINISTRADOR | |
| cidade_id | BIGINT | Referência à cidade de residência/atuação | 🔗 **FK** |
| ativo | BOOLEAN | Indica se o usuário está ativo no sistema | |
| created_at | TIMESTAMP | Data de cadastro no sistema | |
| updated_at | TIMESTAMP | Data da última atualização do perfil | |

### 3.3 Entidade: EQUIPE_COMBATE

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada equipe | ✅ **PK** |
| nome | VARCHAR(100) | Nome ou código de identificação da equipe | |
| status | ENUM | Situação operacional: DISPONIVEL, EM_ACAO, INDISPONIVEL | |
| regiao | VARCHAR(100) | Área geográfica de atuação da equipe | |
| numero_membros | INT | Quantidade atual de bombeiros na equipe | |
| tipo_equipamento | TEXT | Descrição dos equipamentos disponíveis | |
| capacidade_maxima | INT | Número máximo de membros que a equipe suporta | |
| custo_hora | DECIMAL(10,2) | Custo operacional por hora de atividade | |
| telefone_contato | VARCHAR(20) | Telefone direto para comunicação com a equipe | |
| created_at | TIMESTAMP | Data de criação da equipe | |
| updated_at | TIMESTAMP | Data da última atualização dos dados | |

### 3.4 Entidade: OCORRENCIA

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada ocorrência | ✅ **PK** |
| data_hora | TIMESTAMP | Momento exato em que a ocorrência foi reportada | |
| severidade | INT | Nível de gravidade do incêndio (1-10) | |
| descricao | TEXT | Relato detalhado da situação observada | |
| latitude | DOUBLE PRECISION | Coordenada GPS exata do local do incêndio | |
| longitude | DOUBLE PRECISION | Coordenada GPS exata do local do incêndio | |
| status | ENUM | Situação atual: ABERTA, EM_ATENDIMENTO, FINALIZADA | |
| prioridade | ENUM | Calculada automaticamente baseada na severidade | |
| cidade_id | BIGINT | Referência à cidade onde ocorreu o incêndio | 🔗 **FK** |
| equipe_id | BIGINT | Equipe designada para atendimento | 🔗 **FK** |
| usuario_reporter_id | BIGINT | Usuário que reportou a ocorrência | 🔗 **FK** |
| tempo_estimado_resolucao | INT | Previsão de tempo para controle (em minutos) | |
| area_afetada_km2 | DECIMAL(10,4) | Extensão da área atingida pelo fogo | |
| custo_estimado | DECIMAL(12,2) | Custo previsto para combate | |
| observacoes | TEXT | Informações adicionais sobre a operação | |
| finalizada_em | TIMESTAMP | Data e hora de finalização do atendimento | |
| created_at | TIMESTAMP | Data de criação do registro | |
| updated_at | TIMESTAMP | Data da última atualização | |

### 3.5 Entidade: NOTIFICACAO

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada notificação | ✅ **PK** |
| mensagem | TEXT | Conteúdo da mensagem enviada ao usuário | |
| timestamp | TIMESTAMP | Momento em que a notificação foi criada | |
| status | ENUM | Estado da entrega: PENDENTE, ENVIADA, FALHADA, LIDA | |
| tipo_notificacao | ENUM | Canal usado: WHATSAPP_ALERTA, SMS_ALERTA, EMAIL_ALERTA | |
| prioridade | ENUM | Urgência da mensagem: BAIXA, MEDIA, ALTA, URGENTE | |
| usuario_id | BIGINT | Destinatário da notificação | 🔗 **FK** |
| ocorrencia_id | BIGINT | Ocorrência relacionada à notificação | 🔗 **FK** |
| tentativas_envio | INT | Número de tentativas de entrega realizadas | |
| erro_envio | TEXT | Descrição do erro em caso de falha | |
| enviada_em | TIMESTAMP | Data e hora efetiva do envio | |
| lida_em | TIMESTAMP | Data e hora de confirmação de leitura | |
| created_at | TIMESTAMP | Data de criação da notificação | |

### 3.6 Entidade: LOG_ACAO

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada registro de log | ✅ **PK** |
| usuario_id | BIGINT | Usuário que executou a ação | 🔗 **FK** |
| acao | VARCHAR(100) | Tipo de operação realizada (INSERT, UPDATE, DELETE) | |
| tabela_afetada | VARCHAR(50) | Nome da tabela que foi modificada | |
| registro_id | BIGINT | ID do registro que foi alterado | |
| dados_anteriores | JSON | Estado anterior dos dados (para auditoria) | |
| dados_novos | JSON | Estado posterior dos dados | |
| ip_address | VARCHAR(45) | Endereço IP de origem da ação | |
| user_agent | TEXT | Informações do navegador/aplicativo usado | |
| timestamp | TIMESTAMP | Data e hora exata da execução | |

### 3.7 Entidade: RECURSO_EQUIPE

| Atributo | Tipo | Descrição no Mundo Real | Identificador |
|----------|------|-------------------------|---------------|
| **id** | BIGINT | Código único que identifica cada recurso | ✅ **PK** |
| equipe_id | BIGINT | Equipe proprietária do recurso | 🔗 **FK** |
| tipo_recurso | ENUM | Categoria: VEICULO, EQUIPAMENTO, FERRAMENTA, SUPRIMENTO | |
| nome | VARCHAR(100) | Identificação específica do recurso | |
| quantidade | INT | Número de unidades disponíveis | |
| status | ENUM | Condição atual: DISPONIVEL, EM_USO, MANUTENCAO | |
| ultima_manutencao | DATE | Data da última manutenção realizada | |
| proxima_manutencao | DATE | Data prevista para próxima manutenção | |
| created_at | TIMESTAMP | Data de cadastro do recurso | |
| updated_at | TIMESTAMP | Data da última atualização | |

---

## 4. Relacionamentos e Cardinalidades (20 pontos)

### 4.1 Relacionamento: CIDADE ↔ USUARIO
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Uma cidade pode ter vários usuários cadastrados, mas cada usuário pertence a apenas uma cidade
- **Cardinalidade**: 
  - CIDADE (1) ← possui → USUARIO (N)
- **Justificativa**: Necessário para organização territorial e envio de alertas por região geográfica

### 4.2 Relacionamento: CIDADE ↔ OCORRENCIA
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Uma cidade pode ter múltiplas ocorrências de incêndio, mas cada ocorrência acontece em apenas uma cidade
- **Cardinalidade**: 
  - CIDADE (1) ← localiza → OCORRENCIA (N)
- **Justificativa**: Fundamental para mapeamento geográfico e estatísticas municipais

### 4.3 Relacionamento: EQUIPE_COMBATE ↔ OCORRENCIA
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Uma equipe pode atender várias ocorrências ao longo do tempo, mas cada ocorrência é atendida por apenas uma equipe por vez
- **Cardinalidade**: 
  - EQUIPE_COMBATE (1) ← atende → OCORRENCIA (N)
- **Justificativa**: Essencial para controle operacional e alocação de recursos

### 4.4 Relacionamento: USUARIO ↔ OCORRENCIA (Reporter)
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Um usuário pode reportar várias ocorrências, mas cada ocorrência tem apenas um usuário reporter
- **Cardinalidade**: 
  - USUARIO (1) ← reporta → OCORRENCIA (N)
- **Justificativa**: Importante para rastreabilidade e validação de informações

### 4.5 Relacionamento: USUARIO ↔ NOTIFICACAO
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Um usuário pode receber múltiplas notificações, mas cada notificação é direcionada a apenas um usuário
- **Cardinalidade**: 
  - USUARIO (1) ← recebe → NOTIFICACAO (N)
- **Justificativa**: Necessário para sistema de alertas personalizado

### 4.6 Relacionamento: OCORRENCIA ↔ NOTIFICACAO
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Uma ocorrência pode gerar várias notificações (para diferentes usuários ou tipos), mas cada notificação refere-se a apenas uma ocorrência
- **Cardinalidade**: 
  - OCORRENCIA (1) ← gera → NOTIFICACAO (N)
- **Justificativa**: Fundamental para rastreamento de comunicações por incidente

### 4.7 Relacionamento: USUARIO ↔ LOG_ACAO
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Um usuário pode realizar várias ações no sistema, mas cada ação é executada por apenas um usuário
- **Cardinalidade**: 
  - USUARIO (1) ← executa → LOG_ACAO (N)
- **Justificativa**: Essencial para auditoria e segurança do sistema

### 4.8 Relacionamento: EQUIPE_COMBATE ↔ RECURSO_EQUIPE
- **Tipo**: Um para Muitos (1:N)
- **Significado**: Uma equipe pode possuir vários recursos (veículos, equipamentos), mas cada recurso pertence a apenas uma equipe
- **Cardinalidade**: 
  - EQUIPE_COMBATE (1) ← possui → RECURSO_EQUIPE (N)
- **Justificativa**: Necessário para gestão de ativos e planejamento operacional

---

## 5. Diagrama Entidade-Relacionamento (Modelo Conceitual) - 20 pontos

### 5.1 Representação Gráfica

```
                    CIDADE
                   ┌─────────┐
                   │ id (PK) │
                   │ nome    │
                   │ latitude│
                   │longitude│
                   │ estado  │
                   └─────────┘
                        │
                        │ 1:N
                        │
            ┌───────────┼───────────┐
            │           │           │
            ▼           ▼           ▼
       USUARIO     OCORRENCIA   
    ┌─────────┐    ┌─────────┐   
    │ id (PK) │    │ id (PK) │   
    │ nome    │    │data_hora│   
    │telefone │    │severidad│   
    │ email   │    │descricao│   
    │endereco │    │ latitude│   
    │tipo_user│    │longitude│   
    │cidade_id│    │ status  │   
    └─────────┘    │prioridad│   
         │         │cidade_id│   
         │ 1:N     │equipe_id│   
         │         │reporter │   
         ▼         └─────────┘   
   NOTIFICACAO           │
   ┌─────────┐           │ N:1
   │ id (PK) │           │
   │mensagem │           ▼
   │timestamp│    EQUIPE_COMBATE
   │ status  │    ┌─────────┐
   │  tipo   │    │ id (PK) │
   │prioridad│    │  nome   │
   │usuario_id│   │ status  │
   │ocorren_id│   │ regiao  │
   └─────────┘    │ membros │
         │        │equipamen│
         │ 1:N    └─────────┘
         │              │
         ▼              │ 1:N
   LOG_ACAO             ▼
   ┌─────────┐    RECURSO_EQUIPE
   │ id (PK) │    ┌─────────┐
   │usuario_id│   │ id (PK) │
   │  acao   │    │equipe_id│
   │ tabela  │    │  tipo   │
   │registro │    │  nome   │
   │timestamp│    │quantidad│
   └─────────┘    │ status  │
                  └─────────┘
```

### 5.2 Elementos do Diagrama

**Entidades Representadas:**
- ✅ CIDADE (com identificador id)
- ✅ USUARIO (com identificador id) 
- ✅ EQUIPE_COMBATE (com identificador id)
- ✅ OCORRENCIA (com identificador id)
- ✅ NOTIFICACAO (com identificador id)
- ✅ LOG_ACAO (com identificador id)
- ✅ RECURSO_EQUIPE (com identificador id)

**Relacionamentos Representados:**
- ✅ CIDADE → USUARIO (1:N)
- ✅ CIDADE → OCORRENCIA (1:N) 
- ✅ USUARIO → NOTIFICACAO (1:N)
- ✅ USUARIO → OCORRENCIA (1:N - reporter)
- ✅ USUARIO → LOG_ACAO (1:N)
- ✅ EQUIPE_COMBATE → OCORRENCIA (1:N)
- ✅ EQUIPE_COMBATE → RECURSO_EQUIPE (1:N)
- ✅ OCORRENCIA → NOTIFICACAO (1:N)

**Atributos Identificadores:**
- ✅ Todas as entidades possuem chaves primárias (PK) definidas
- ✅ Chaves estrangeiras (FK) representadas nos relacionamentos

---

## 6. Diagrama do Modelo Lógico - 20 pontos

### 6.1 Estrutura das Tabelas

#### Tabela: cidade
```sql
CREATE TABLE cidade (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    estado VARCHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_cidade_estado (nome, estado)
);
```

#### Tabela: usuario
```sql
CREATE TABLE usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    endereco VARCHAR(250),
    tipo_usuario ENUM('CIDADAO', 'BOMBEIRO', 'ADMINISTRADOR') NOT NULL DEFAULT 'CIDADAO',
    cidade_id BIGINT,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id) ON DELETE SET NULL,
    UNIQUE KEY unique_telefone (telefone)
);
```

#### Tabela: equipe_combate
```sql
CREATE TABLE equipe_combate (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    status ENUM('DISPONIVEL', 'EM_ACAO', 'INDISPONIVEL', 'MANUTENCAO') NOT NULL DEFAULT 'DISPONIVEL',
    regiao VARCHAR(100) NOT NULL,
    numero_membros INT NOT NULL DEFAULT 1,
    tipo_equipamento TEXT,
    capacidade_maxima INT DEFAULT 1,
    custo_hora DECIMAL(10,2),
    telefone_contato VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Tabela: ocorrencia
```sql
CREATE TABLE ocorrencia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    severidade INT NOT NULL CHECK (severidade >= 1 AND severidade <= 10),
    descricao TEXT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    status ENUM('ABERTA', 'EM_ATENDIMENTO', 'FINALIZADA', 'CANCELADA') NOT NULL DEFAULT 'ABERTA',
    prioridade ENUM('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') GENERATED ALWAYS AS (
        CASE 
            WHEN severidade >= 8 THEN 'CRITICA'
            WHEN severidade >= 6 THEN 'ALTA'
            WHEN severidade >= 4 THEN 'MEDIA'
            ELSE 'BAIXA'
        END
    ) STORED,
    cidade_id BIGINT NOT NULL,
    equipe_id BIGINT,
    usuario_reporter_id BIGINT,
    tempo_estimado_resolucao INT,
    area_afetada_km2 DECIMAL(10,4),
    custo_estimado DECIMAL(12,2),
    observacoes TEXT,
    finalizada_em TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id) ON DELETE RESTRICT,
    FOREIGN KEY (equipe_id) REFERENCES equipe_combate(id) ON DELETE SET NULL,
    FOREIGN KEY (usuario_reporter_id) REFERENCES usuario(id) ON DELETE SET NULL
);
```

#### Tabela: notificacao
```sql
CREATE TABLE notificacao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mensagem TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDENTE', 'ENVIADA', 'FALHADA', 'LIDA') NOT NULL DEFAULT 'PENDENTE',
    tipo_notificacao ENUM('WHATSAPP_ALERTA', 'SMS_ALERTA', 'EMAIL_ALERTA', 'PUSH_NOTIFICATION') NOT NULL,
    prioridade ENUM('BAIXA', 'MEDIA', 'ALTA', 'URGENTE') NOT NULL DEFAULT 'MEDIA',
    usuario_id BIGINT NOT NULL,
    ocorrencia_id BIGINT,
    tentativas_envio INT DEFAULT 0,
    erro_envio TEXT,
    enviada_em TIMESTAMP NULL,
    lida_em TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id) ON DELETE CASCADE
);
```

#### Tabela: log_acao
```sql
CREATE TABLE log_acao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id BIGINT,
    acao VARCHAR(100) NOT NULL,
    tabela_afetada VARCHAR(50),
    registro_id BIGINT,
    dados_anteriores JSON,
    dados_novos JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL
);
```

#### Tabela: recurso_equipe
```sql
CREATE TABLE recurso_equipe (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    equipe_id BIGINT NOT NULL,
    tipo_recurso ENUM('VEICULO', 'EQUIPAMENTO', 'FERRAMENTA', 'SUPRIMENTO') NOT NULL,
    nome VARCHAR(100) NOT NULL,
    quantidade INT DEFAULT 1,
    status ENUM('DISPONIVEL', 'EM_USO', 'MANUTENCAO', 'INDISPONIVEL') DEFAULT 'DISPONIVEL',
    ultima_manutencao DATE,
    proxima_manutencao DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (equipe_id) REFERENCES equipe_combate(id) ON DELETE CASCADE
);
```

### 6.2 Integridade Referencial

**Chaves Primárias (PK):**
- ✅ cidade.id
- ✅ usuario.id  
- ✅ equipe_combate.id
- ✅ ocorrencia.id
- ✅ notificacao.id
- ✅ log_acao.id
- ✅ recurso_equipe.id

**Chaves Estrangeiras (FK):**
- ✅ usuario.cidade_id → cidade.id
- ✅ ocorrencia.cidade_id → cidade.id
- ✅ ocorrencia.equipe_id → equipe_combate.id
- ✅ ocorrencia.usuario_reporter_id → usuario.id
- ✅ notificacao.usuario_id → usuario.id
- ✅ notificacao.ocorrencia_id → ocorrencia.id
- ✅ log_acao.usuario_id → usuario.id
- ✅ recurso_equipe.equipe_id → equipe_combate.id

**Restrições de Integridade:**
- ✅ Constraints de domínio (CHECK, ENUM)
- ✅ Constraints de unicidade (UNIQUE)
- ✅ Políticas de deleção (CASCADE, SET NULL, RESTRICT)
- ✅ Valores padrão apropriados

---

## 7. Considerações Técnicas

### 7.1 Índices Otimizados
```sql
-- Índices para performance
CREATE INDEX idx_ocorrencia_severidade ON ocorrencia(severidade DESC);
CREATE INDEX idx_ocorrencia_status ON ocorrencia(status);
CREATE INDEX idx_ocorrencia_coordenadas ON ocorrencia(latitude, longitude);
CREATE INDEX idx_notificacao_timestamp ON notificacao(timestamp DESC);
CREATE INDEX idx_usuario_tipo ON usuario(tipo_usuario);
```

### 7.2 Views para Relatórios
```sql
-- View para ocorrências ativas
CREATE OR REPLACE VIEW vw_ocorrencias_ativas AS
SELECT o.*, c.nome as cidade_nome, e.nome as equipe_nome
FROM ocorrencia o
JOIN cidade c ON o.cidade_id = c.id
LEFT JOIN equipe_combate e ON o.equipe_id = e.id
WHERE o.status IN ('ABERTA', 'EM_ATENDIMENTO');
```

### 7.3 Triggers de Auditoria
```sql
-- Trigger para log automático
CREATE TRIGGER tr_ocorrencia_status_update
AFTER UPDATE ON ocorrencia
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO log_acao (acao, tabela_afetada, registro_id, dados_anteriores, dados_novos)
        VALUES ('STATUS_CHANGE', 'ocorrencia', NEW.id,
                JSON_OBJECT('status', OLD.status),
                JSON_OBJECT('status', NEW.status));
    END IF;
END;
```

---

## 8. Conclusão

O modelo de dados do FireWatch foi projetado para:

1. **Escalabilidade**: Suportar grandes volumes de ocorrências e usuários
2. **Integridade**: Garantir consistência através de constraints apropriadas  
3. **Performance**: Índices otimizados para consultas frequentes
4. **Auditoria**: Rastreamento completo de ações através de logs
5. **Flexibilidade**: Estrutura extensível para futuras funcionalidades

O sistema atende completamente aos requisitos de monitoramento e combate às queimadas, proporcionando uma base sólida para operações críticas de emergência ambiental.

---

**Documento preparado para elaboração dos Diagramas Entidade-Relacionamento no Data Modeler**

*Todas as especificações técnicas estão alinhadas com as melhores práticas de Database Design para sistemas de missão crítica.*