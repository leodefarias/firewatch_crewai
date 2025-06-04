# Database Design - Sistema FireWatch
## Projeto de Monitoramento e Combate a Queimadas

---

## 1. Descritivo do Projeto (10 pontos)

### Justificativa e Objetivos

O **Sistema FireWatch** é uma solução tecnológica desenvolvida para o monitoramento, detecção e combate eficiente a incêndios e queimadas. O projeto surge da necessidade crítica de reduzir o tempo de resposta entre a detecção de um foco de incêndio e o início das ações de combate, maximizando assim a eficácia das operações de contenção e minimizando os danos ambientais, econômicos e sociais.

### Contexto e Relevância

O Brasil enfrenta anualmente milhares de focos de incêndio, especialmente durante os períodos secos, causando:
- **Perda de biodiversidade** e destruição de ecossistemas
- **Prejuízos econômicos** à agricultura, pecuária e turismo  
- **Riscos à saúde pública** devido à poluição atmosférica
- **Deslocamento de comunidades** e perda de propriedades

### Objetivos Específicos

1. **Detecção Rápida**: Permitir que cidadãos reportem focos de incêndio via WhatsApp com localização automática
2. **Gestão Centralizada**: Centralizar informações de ocorrências, equipes e recursos em tempo real
3. **Resposta Coordenada**: Facilitar a mobilização e coordenação de equipes de combate
4. **Comunicação Eficiente**: Implementar sistema automatizado de alertas para comunidades em risco
5. **Análise Histórica**: Armazenar dados para análise de padrões e prevenção
6. **Transparência**: Disponibilizar informações para órgãos fiscalizadores e sociedade civil

### Benefícios Esperados

- **Redução do tempo de resposta** de horas para minutos
- **Melhoria na coordenação** entre diferentes equipes e órgãos
- **Maior participação cidadã** no monitoramento ambiental
- **Otimização de recursos** através de dados históricos e análises preditivas
- **Transparência nas operações** de combate a incêndios

---

## 2. Identificação das Entidades (10 pontos)

O modelo de dados do FireWatch contempla **7 entidades principais**, cada uma representando elementos fundamentais do domínio de combate a incêndios:

### 2.1 **CIDADE**
**Significado no mundo real**: Representa as unidades territoriais administrativas (municípios) que são monitoradas pelo sistema. Cada cidade possui características geográficas específicas (coordenadas) e está localizada em um estado. É a unidade básica de organização territorial para o planejamento de ações de combate e prevenção.

### 2.2 **USUARIO**
**Significado no mundo real**: Representa todas as pessoas que interagem com o sistema, sejam elas cidadãos que reportam incêndios, bombeiros que atuam no combate, ou administradores que gerenciam o sistema. Cada usuário possui informações de contato essenciais para comunicação durante emergências e está vinculado a uma cidade específica.

### 2.3 **EQUIPE_COMBATE**
**Significado no mundo real**: Representa as unidades operacionais especializadas no combate a incêndios, como brigadas de bombeiros, equipes do IBAMA, defesa civil, ou grupos voluntários. Cada equipe possui capacidades específicas (equipamentos, número de membros) e atua em regiões determinadas, sendo o recurso humano principal para resposta às ocorrências.

### 2.4 **OCORRENCIA**
**Significado no mundo real**: Representa cada evento de incêndio ou queimada detectado no sistema, desde o momento do primeiro relato até sua completa resolução. Inclui informações cruciais como localização precisa, nível de severidade, status atual e histórico de ações realizadas. É a entidade central que conecta todos os demais elementos do sistema.

### 2.5 **NOTIFICACAO**
**Significado no mundo real**: Representa cada comunicação enviada pelo sistema aos usuários, seja para alertar sobre novos incêndios na região, informar sobre mudanças de status de ocorrências, ou comunicar instruções específicas. É fundamental para manter a população e equipes informadas em tempo real.

### 2.6 **RECURSO_EQUIPE**
**Significado no mundo real**: Representa os equipamentos, veículos, ferramentas e suprimentos disponíveis para cada equipe de combate. Inclui desde caminhões-pipa e helicópteros até equipamentos de proteção individual e ferramentas especializadas. O controle desses recursos é essencial para planejamento operacional.

### 2.7 **LOG_ACAO**
**Significado no mundo real**: Representa o registro histórico de todas as ações realizadas no sistema, funcionando como uma auditoria completa das operações. Permite rastrear quem fez o quê, quando e como, sendo fundamental para análises post-incidente, melhorias de processo e prestação de contas.

---

## 3. Identificação dos Atributos (20 pontos)

### 3.1 Entidade CIDADE

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Código único numérico para identificação da cidade no sistema | ✅ **Chave Primária** |
| nome | VARCHAR(100) | Nome oficial do município conforme registro no IBGE |  |
| latitude | DOUBLE | Coordenada geográfica para localização precisa da cidade |  |
| longitude | DOUBLE | Coordenada geográfica para localização precisa da cidade |  |
| estado | VARCHAR(2) | Sigla da unidade federativa (ex: SP, RJ, MG) |  |
| created_at | TIMESTAMP | Data e hora de cadastro da cidade no sistema |  |
| updated_at | TIMESTAMP | Data e hora da última atualização dos dados |  |

**Justificativa do Identificador**: O `id` é escolhido como chave primária por ser único, imutável e eficiente para relacionamentos com outras tabelas.

### 3.2 Entidade USUARIO

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Código único numérico para identificação do usuário | ✅ **Chave Primária** |
| nome | VARCHAR(150) | Nome completo da pessoa para identificação |  |
| telefone | VARCHAR(20) | Número de telefone/WhatsApp para comunicação emergencial | 🔑 **Identificador Alternativo** |
| email | VARCHAR(150) | Endereço de email para comunicações não-urgentes |  |
| endereco | VARCHAR(250) | Endereço residencial para localização em emergências |  |
| tipo_usuario | ENUM | Perfil de acesso: CIDADAO, BOMBEIRO, ADMINISTRADOR |  |
| cidade_id | BIGINT | Referência à cidade de residência/atuação | 🔗 **Chave Estrangeira** |
| ativo | BOOLEAN | Indica se o usuário está ativo no sistema |  |
| created_at | TIMESTAMP | Data e hora de cadastro no sistema |  |
| updated_at | TIMESTAMP | Data e hora da última atualização |  |

**Justificativa dos Identificadores**: 
- `id`: Chave primária técnica única
- `telefone`: Identificador alternativo único, usado para integração WhatsApp

### 3.3 Entidade EQUIPE_COMBATE

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Código único da equipe no sistema | ✅ **Chave Primária** |
| nome | VARCHAR(100) | Nome/identificação da equipe (ex: "1º Batalhão CBMSP") |  |
| status | ENUM | Status operacional: DISPONIVEL, EM_ACAO, INDISPONIVEL, MANUTENCAO |  |
| regiao | VARCHAR(100) | Área geográfica de atuação da equipe |  |
| numero_membros | INT | Quantidade atual de integrantes da equipe |  |
| tipo_equipamento | TEXT | Descrição dos equipamentos disponíveis |  |
| capacidade_maxima | INT | Número máximo de ocorrências simultâneas que pode atender |  |
| custo_hora | DECIMAL(10,2) | Custo operacional por hora da equipe |  |
| telefone_contato | VARCHAR(20) | Telefone direto para comunicação com a equipe |  |
| created_at | TIMESTAMP | Data e hora de cadastro da equipe |  |
| updated_at | TIMESTAMP | Data e hora da última atualização |  |

**Justificativa do Identificador**: O `id` permite identificação única mesmo quando equipes mudam de nome ou reorganizam-se administrativamente.

### 3.4 Entidade OCORRENCIA

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Número único da ocorrência para rastreamento | ✅ **Chave Primária** |
| data_hora | TIMESTAMP | Momento exato da detecção/reporte do incêndio |  |
| severidade | INT(1-10) | Nível de gravidade: 1=pequeno, 10=catastrófico |  |
| descricao | TEXT | Relato detalhado do que foi observado |  |
| latitude | DOUBLE | Coordenada exata do foco do incêndio |  |
| longitude | DOUBLE | Coordenada exata do foco do incêndio |  |
| status | ENUM | Situação atual: ABERTA, EM_ATENDIMENTO, FINALIZADA, CANCELADA |  |
| prioridade | ENUM | Prioridade calculada: BAIXA, MEDIA, ALTA, CRITICA |  |
| cidade_id | BIGINT | Cidade onde ocorreu o incêndio | 🔗 **Chave Estrangeira** |
| equipe_id | BIGINT | Equipe responsável pelo atendimento | 🔗 **Chave Estrangeira** |
| usuario_reporter_id | BIGINT | Usuário que reportou a ocorrência | 🔗 **Chave Estrangeira** |
| tempo_estimado_resolucao | INT | Previsão de tempo para controle (em minutos) |  |
| area_afetada_km2 | DECIMAL(10,4) | Área estimada ou real atingida pelo fogo |  |
| custo_estimado | DECIMAL(12,2) | Custo previsto ou real da operação |  |
| observacoes | TEXT | Informações adicionais relevantes |  |
| finalizada_em | TIMESTAMP | Data e hora da resolução da ocorrência |  |
| created_at | TIMESTAMP | Data e hora de registro no sistema |  |
| updated_at | TIMESTAMP | Data e hora da última atualização |  |

**Justificativa do Identificador**: O `id` serve como número de protocolo único para rastreamento administrativo e operacional.

### 3.5 Entidade NOTIFICACAO

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Código único da notificação | ✅ **Chave Primária** |
| mensagem | TEXT | Conteúdo da mensagem enviada ao usuário |  |
| timestamp | TIMESTAMP | Momento exato do envio da notificação |  |
| status | ENUM | Status de entrega: PENDENTE, ENVIADA, FALHADA, LIDA |  |
| tipo_notificacao | ENUM | Canal utilizado: WHATSAPP_ALERTA, SMS_ALERTA, EMAIL_ALERTA |  |
| prioridade | ENUM | Urgência da mensagem: BAIXA, MEDIA, ALTA, URGENTE |  |
| usuario_id | BIGINT | Destinatário da notificação | 🔗 **Chave Estrangeira** |
| ocorrencia_id | BIGINT | Ocorrência que originou a notificação | 🔗 **Chave Estrangeira** |
| tentativas_envio | INT | Número de tentativas de entrega realizadas |  |
| erro_envio | TEXT | Descrição de erros ocorridos no envio |  |
| enviada_em | TIMESTAMP | Data e hora de envio bem-sucedido |  |
| lida_em | TIMESTAMP | Data e hora de confirmação de leitura |  |
| created_at | TIMESTAMP | Data e hora de criação da notificação |  |

### 3.6 Entidade RECURSO_EQUIPE

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Código único do recurso | ✅ **Chave Primária** |
| equipe_id | BIGINT | Equipe proprietária do recurso | 🔗 **Chave Estrangeira** |
| tipo_recurso | ENUM | Categoria: VEICULO, EQUIPAMENTO, FERRAMENTA, SUPRIMENTO |  |
| nome | VARCHAR(100) | Identificação específica do recurso |  |
| quantidade | INT | Número de unidades disponíveis |  |
| status | ENUM | Condição atual: DISPONIVEL, EM_USO, MANUTENCAO, INDISPONIVEL |  |
| ultima_manutencao | DATE | Data da última manutenção realizada |  |
| proxima_manutencao | DATE | Data programada para próxima manutenção |  |
| created_at | TIMESTAMP | Data de cadastro do recurso |  |
| updated_at | TIMESTAMP | Data da última atualização |  |

### 3.7 Entidade LOG_ACAO

| Atributo | Tipo | Significado no Mundo Real | Identificador |
|----------|------|---------------------------|---------------|
| **id** | BIGINT | Código único do registro de log | ✅ **Chave Primária** |
| usuario_id | BIGINT | Usuário que executou a ação | 🔗 **Chave Estrangeira** |
| acao | VARCHAR(100) | Tipo de operação realizada (INSERT, UPDATE, DELETE) |  |
| tabela_afetada | VARCHAR(50) | Nome da tabela que sofreu alteração |  |
| registro_id | BIGINT | ID do registro afetado |  |
| dados_anteriores | JSON | Estado dos dados antes da alteração |  |
| dados_novos | JSON | Estado dos dados após a alteração |  |
| ip_address | VARCHAR(45) | Endereço IP de origem da ação |  |
| user_agent | TEXT | Informações do navegador/aplicativo utilizado |  |
| timestamp | TIMESTAMP | Data e hora exata da execução da ação |  |

---

## 4. Identificação dos Relacionamentos (20 pontos)

### 4.1 CIDADE ↔ USUARIO (1:N)

**Significado do Relacionamento**: "Uma cidade **possui** muitos usuários, mas cada usuário **reside/atua** em apenas uma cidade."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (CIDADE)**: Uma cidade pode ter centenas ou milhares de usuários cadastrados (cidadãos, bombeiros, administradores)
- **Lado "N" (USUARIO)**: Cada usuário tem uma cidade principal de residência ou atuação
- **Razão**: Necessário para segmentação geográfica de alertas e organização territorial das operações

### 4.2 CIDADE ↔ OCORRENCIA (1:N)

**Significado do Relacionamento**: "Uma cidade **registra** muitas ocorrências, mas cada ocorrência **acontece** em apenas uma cidade."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (CIDADE)**: Uma cidade pode ter múltiplas ocorrências de incêndio ao longo do tempo
- **Lado "N" (OCORRENCIA)**: Cada ocorrência tem localização específica dentro dos limites de uma cidade
- **Razão**: Essencial para estatísticas municipais e acionamento de recursos locais

### 4.3 EQUIPE_COMBATE ↔ OCORRENCIA (1:N)

**Significado do Relacionamento**: "Uma equipe **atende** muitas ocorrências, mas cada ocorrência é **atendida** por apenas uma equipe principal."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (EQUIPE_COMBATE)**: Uma equipe pode atender múltiplas ocorrências ao longo do tempo
- **Lado "N" (OCORRENCIA)**: Cada ocorrência tem uma equipe principal responsável (embora possa ter apoio de outras)
- **Razão**: Definir responsabilidade clara e controlar capacidade operacional das equipes

### 4.4 USUARIO ↔ NOTIFICACAO (1:N)

**Significado do Relacionamento**: "Um usuário **recebe** muitas notificações, mas cada notificação é **enviada** para apenas um usuário."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (USUARIO)**: Um usuário pode receber centenas de notificações ao longo do tempo
- **Lado "N" (NOTIFICACAO)**: Cada notificação tem um destinatário específico
- **Razão**: Controle individual de comunicações e histórico personalizado

### 4.5 OCORRENCIA ↔ NOTIFICACAO (1:N)

**Significado do Relacionamento**: "Uma ocorrência **gera** muitas notificações, mas cada notificação **refere-se** a apenas uma ocorrência."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (OCORRENCIA)**: Uma ocorrência pode gerar notificações para múltiplos usuários e em diferentes momentos
- **Lado "N" (NOTIFICACAO)**: Cada notificação está relacionada a uma ocorrência específica
- **Razão**: Rastreabilidade das comunicações relacionadas a cada incidente

### 4.6 USUARIO ↔ OCORRENCIA (1:N) [Reporter]

**Significado do Relacionamento**: "Um usuário **reporta** muitas ocorrências, mas cada ocorrência é **reportada** por apenas um usuário."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (USUARIO)**: Um usuário pode reportar múltiplas ocorrências ao longo do tempo
- **Lado "N" (OCORRENCIA)**: Cada ocorrência tem um usuário específico que a reportou inicialmente
- **Razão**: Identificar fonte da informação e permitir contato para esclarecimentos

### 4.7 EQUIPE_COMBATE ↔ RECURSO_EQUIPE (1:N)

**Significado do Relacionamento**: "Uma equipe **possui** muitos recursos, mas cada recurso **pertence** a apenas uma equipe."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (EQUIPE_COMBATE)**: Uma equipe possui múltiplos equipamentos, veículos e suprimentos
- **Lado "N" (RECURSO_EQUIPE)**: Cada recurso está alocado a uma equipe específica
- **Razão**: Controle patrimonial e planejamento operacional

### 4.8 USUARIO ↔ LOG_ACAO (1:N)

**Significado do Relacionamento**: "Um usuário **executa** muitas ações, mas cada ação é **executada** por apenas um usuário."

**Cardinalidade**: 1:N (Um para Muitos)

**Justificativa da Cardinalidade**:
- **Lado "1" (USUARIO)**: Um usuário pode realizar centenas de ações no sistema
- **Lado "N" (LOG_ACAO)**: Cada ação registrada tem um usuário responsável
- **Razão**: Auditoria e rastreabilidade das operações do sistema

---

## 5. Diagrama Entidade-Relacionamento (Modelo Conceitual) (20 pontos)

### Instruções para Elaboração no Data Modeler

O Diagrama Entidade-Relacionamento deve representar **todas** as entidades, relacionamentos, atributos e identificadores descritos anteriormente. Para a elaboração no Data Modeler, utilize as seguintes diretrizes:

#### 5.1 Representação das Entidades
```
┌─────────────────┐
│     CIDADE      │
├─────────────────┤
│ PK id           │
│    nome         │
│    latitude     │
│    longitude    │
│    estado       │
│    created_at   │
│    updated_at   │
└─────────────────┘

┌─────────────────────┐
│      USUARIO        │
├─────────────────────┤
│ PK id               │
│ UK telefone         │
│    nome             │
│    email            │
│    endereco         │
│    tipo_usuario     │
│ FK cidade_id        │
│    ativo            │
│    created_at       │
│    updated_at       │
└─────────────────────┘

┌─────────────────────┐
│   EQUIPE_COMBATE    │
├─────────────────────┤
│ PK id               │
│    nome             │
│    status           │
│    regiao           │
│    numero_membros   │
│    tipo_equipamento │
│    capacidade_maxima│
│    custo_hora       │
│    telefone_contato │
│    created_at       │
│    updated_at       │
└─────────────────────┘

┌─────────────────────────┐
│      OCORRENCIA         │
├─────────────────────────┤
│ PK id                   │
│    data_hora            │
│    severidade           │
│    descricao            │
│    latitude             │
│    longitude            │
│    status               │
│    prioridade           │
│ FK cidade_id            │
│ FK equipe_id            │
│ FK usuario_reporter_id  │
│    tempo_estimado_res   │
│    area_afetada_km2     │
│    custo_estimado       │
│    observacoes          │
│    finalizada_em        │
│    created_at           │
│    updated_at           │
└─────────────────────────┘

┌─────────────────────┐
│    NOTIFICACAO      │
├─────────────────────┤
│ PK id               │
│    mensagem         │
│    timestamp        │
│    status           │
│    tipo_notificacao │
│    prioridade       │
│ FK usuario_id       │
│ FK ocorrencia_id    │
│    tentativas_envio │
│    erro_envio       │
│    enviada_em       │
│    lida_em          │
│    created_at       │
└─────────────────────┘

┌─────────────────────┐
│   RECURSO_EQUIPE    │
├─────────────────────┤
│ PK id               │
│ FK equipe_id        │
│    tipo_recurso     │
│    nome             │
│    quantidade       │
│    status           │
│    ultima_manutencao│
│    proxima_manutencao│
│    created_at       │
│    updated_at       │
└─────────────────────┘

┌─────────────────────┐
│     LOG_ACAO        │
├─────────────────────┤
│ PK id               │
│ FK usuario_id       │
│    acao             │
│    tabela_afetada   │
│    registro_id      │
│    dados_anteriores │
│    dados_novos      │
│    ip_address       │
│    user_agent       │
│    timestamp        │
└─────────────────────┘
```

#### 5.2 Relacionamentos e Cardinalidades

**Conectores no DER**:
- **CIDADE** (1) ──────── (N) **USUARIO**
  - Nome: "localiza"
  - Cardinalidade: 1:N

- **CIDADE** (1) ──────── (N) **OCORRENCIA**  
  - Nome: "registra"
  - Cardinalidade: 1:N

- **EQUIPE_COMBATE** (1) ──────── (N) **OCORRENCIA**
  - Nome: "atende"
  - Cardinalidade: 1:N

- **USUARIO** (1) ──────── (N) **NOTIFICACAO**
  - Nome: "recebe"
  - Cardinalidade: 1:N

- **OCORRENCIA** (1) ──────── (N) **NOTIFICACAO**
  - Nome: "gera"
  - Cardinalidade: 1:N

- **USUARIO** (1) ──────── (N) **OCORRENCIA**
  - Nome: "reporta"
  - Cardinalidade: 1:N

- **EQUIPE_COMBATE** (1) ──────── (N) **RECURSO_EQUIPE**
  - Nome: "possui"
  - Cardinalidade: 1:N

- **USUARIO** (1) ──────── (N) **LOG_ACAO**
  - Nome: "executa"
  - Cardinalidade: 1:N

#### 5.3 Configurações do Data Modeler

- **Tipo de Notação**: Crow's Foot (Pé de Galinha)
- **Exibir Tipos de Dados**: Sim
- **Exibir Chaves**: PK (Primary Key), FK (Foreign Key), UK (Unique Key)
- **Nomear Relacionamentos**: Sim, com verbos descritivos
- **Cores Sugeridas**:
  - Entidades Principais: Azul claro
  - Entidades de Apoio: Verde claro  
  - Entidade de Log: Amarelo claro

---

## 6. Diagrama do Modelo Lógico (20 pontos)

### Instruções para o Modelo Lógico no Data Modeler

O Modelo Lógico deve transformar o modelo conceitual em estruturas relacionais, representando:

#### 6.1 Estrutura das Tabelas

**Tabela: CIDADE**
```sql
CREATE TABLE cidade (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    estado VARCHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_cidade_estado (nome, estado),
    INDEX idx_cidade_estado (estado),
    INDEX idx_cidade_coordenadas (latitude, longitude)
);
```

**Tabela: USUARIO**
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
    UNIQUE KEY unique_telefone (telefone),
    INDEX idx_usuario_cidade (cidade_id),
    INDEX idx_usuario_tipo (tipo_usuario)
);
```

**Tabela: EQUIPE_COMBATE**
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_equipe_status (status),
    INDEX idx_equipe_regiao (regiao)
);
```

**Tabela: OCORRENCIA**
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
    FOREIGN KEY (usuario_reporter_id) REFERENCES usuario(id) ON DELETE SET NULL,
    INDEX idx_ocorrencia_severidade (severidade DESC),
    INDEX idx_ocorrencia_status (status),
    INDEX idx_ocorrencia_data (data_hora DESC)
);
```

#### 6.2 Chaves e Relacionamentos

**Convenções de Nomenclatura**:
- **Chaves Primárias**: `id` (BIGINT AUTO_INCREMENT)
- **Chaves Estrangeiras**: `{tabela_referenciada}_id`
- **Índices**: `idx_{tabela}_{campo(s)}`
- **Constraints**: `unique_{campo}` ou `check_{campo}`

**Relacionamentos Implementados**:

1. **cidade.id** ← **usuario.cidade_id** (1:N)
   - `ON DELETE SET NULL`: Se cidade for removida, usuários permanecem sem cidade
   
2. **cidade.id** ← **ocorrencia.cidade_id** (1:N)
   - `ON DELETE RESTRICT`: Não permite remoção de cidade com ocorrências
   
3. **equipe_combate.id** ← **ocorrencia.equipe_id** (1:N)
   - `ON DELETE SET NULL`: Se equipe for removida, ocorrência fica sem equipe
   
4. **usuario.id** ← **notificacao.usuario_id** (1:N)
   - `ON DELETE CASCADE`: Remove notificações se usuário for removido
   
5. **ocorrencia.id** ← **notificacao.ocorrencia_id** (1:N)
   - `ON DELETE CASCADE`: Remove notificações se ocorrência for removida

#### 6.3 Elementos Obrigatórios no Diagrama Lógico

**✅ Checklist de Verificação**:
- [ ] Todas as 7 tabelas representadas
- [ ] Todas as chaves primárias (PK) identificadas
- [ ] Todas as chaves estrangeiras (FK) identificadas  
- [ ] Relacionamentos com cardinalidades (1:N) representados
- [ ] Índices principais marcados
- [ ] Constraints de integridade indicadas
- [ ] Tipos de dados especificados
- [ ] Regras de negócio (ENUM, CHECK) implementadas

#### 6.4 Configurações no Data Modeler para Modelo Lógico

- **Engine**: MySQL 8.0+ ou PostgreSQL 12+
- **Charset**: UTF8MB4 (suporte completo a Unicode)
- **Collation**: utf8mb4_unicode_ci
- **Storage Engine**: InnoDB (transações ACID)
- **Mostrar Tipos de Dados**: Sim, com precisão
- **Mostrar Índices**: Sim, principais
- **Mostrar Constraints**: Sim, FK e CHECK
- **Notação**: Relacional padrão

---

## Resumo da Documentação

Este documento fornece a base completa para desenvolvimento do modelo de dados do Sistema FireWatch, abrangendo desde a conceituação até a implementação física. O modelo suporta:

- **Detecção e registro** de ocorrências de incêndio
- **Gestão coordenada** de equipes e recursos
- **Comunicação automatizada** com usuários  
- **Auditoria completa** das operações
- **Análise histórica** para prevenção
- **Escalabilidade** para diferentes regiões

A estrutura proposta garante **integridade referencial**, **performance otimizada** e **flexibilidade** para evoluções futuras do sistema.