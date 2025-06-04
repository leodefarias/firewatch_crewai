# Diagrama de Classes UML - Sistema FireWatch

## Diagrama de Classes Completo

```mermaid
classDiagram
    %% Domain Classes (Entidades)
    class Cidade {
        -Long id
        -String nome
        -Double latitude
        -Double longitude
        -String estado
        +Cidade()
        +Cidade(String nome, Double latitude, Double longitude, String estado)
        +Long getId()
        +void setId(Long id)
        +String getNome()
        +void setNome(String nome)
        +Double getLatitude()
        +void setLatitude(Double latitude)
        +Double getLongitude()
        +void setLongitude(Double longitude)
        +String getEstado()
        +void setEstado(String estado)
    }

    class Usuario {
        -Long id
        -String nome
        -String telefone
        -String email
        -String endereco
        -String tipoUsuario
        -Cidade cidade
        +Usuario()
        +Usuario(String nome, String telefone, String email, String endereco, String tipoUsuario, Cidade cidade)
        +Long getId()
        +void setId(Long id)
        +String getNome()
        +void setNome(String nome)
        +String getTelefone()
        +void setTelefone(String telefone)
        +String getEmail()
        +void setEmail(String email)
        +String getEndereco()
        +void setEndereco(String endereco)
        +String getTipoUsuario()
        +void setTipoUsuario(String tipoUsuario)
        +Cidade getCidade()
        +void setCidade(Cidade cidade)
    }

    class EquipeCombate {
        -Long id
        -String nome
        -String status
        -String regiao
        -int numeroMembros
        -String tipoEquipamento
        +EquipeCombate()
        +EquipeCombate(String nome, String status, String regiao, int numeroMembros, String tipoEquipamento)
        +Long getId()
        +void setId(Long id)
        +String getNome()
        +void setNome(String nome)
        +String getStatus()
        +void setStatus(String status)
        +String getRegiao()
        +void setRegiao(String regiao)
        +int getNumeroMembros()
        +void setNumeroMembros(int numeroMembros)
        +String getTipoEquipamento()
        +void setTipoEquipamento(String tipoEquipamento)
    }

    class Ocorrencia {
        -Long id
        -LocalDateTime dataHora
        -int severidade
        -String descricao
        -Double latitude
        -Double longitude
        -String status
        -Cidade cidade
        -EquipeCombate equipeResponsavel
        +Ocorrencia()
        +Ocorrencia(LocalDateTime dataHora, int severidade, String descricao, Double latitude, Double longitude, Cidade cidade)
        +Long getId()
        +void setId(Long id)
        +LocalDateTime getDataHora()
        +void setDataHora(LocalDateTime dataHora)
        +int getSeveridade()
        +void setSeveridade(int severidade)
        +String getDescricao()
        +void setDescricao(String descricao)
        +Double getLatitude()
        +void setLatitude(Double latitude)
        +Double getLongitude()
        +void setLongitude(Double longitude)
        +String getStatus()
        +void setStatus(String status)
        +Cidade getCidade()
        +void setCidade(Cidade cidade)
        +EquipeCombate getEquipeResponsavel()
        +void setEquipeResponsavel(EquipeCombate equipeResponsavel)
    }

    class Notificacao {
        -Long id
        -String mensagem
        -LocalDateTime timestamp
        -String status
        -String tipoNotificacao
        -Usuario usuario
        -Ocorrencia ocorrencia
        +Notificacao()
        +Notificacao(String mensagem, LocalDateTime timestamp, String tipoNotificacao, Usuario usuario, Ocorrencia ocorrencia)
        +Long getId()
        +void setId(Long id)
        +String getMensagem()
        +void setMensagem(String mensagem)
        +LocalDateTime getTimestamp()
        +void setTimestamp(LocalDateTime timestamp)
        +String getStatus()
        +void setStatus(String status)
        +String getTipoNotificacao()
        +void setTipoNotificacao(String tipoNotificacao)
        +Usuario getUsuario()
        +void setUsuario(Usuario usuario)
        +Ocorrencia getOcorrencia()
        +void setOcorrencia(Ocorrencia ocorrencia)
    }

    %% Service Classes (Camada de Serviço)
    class UsuarioService {
        -UsuarioRepository usuarioRepository
        +Usuario cadastrar(Usuario usuario)
        +List~Usuario~ listarTodos()
        +List~Usuario~ listarPorCidade(Long cidadeId)
        +Optional~Usuario~ buscarPorId(Long id)
        +Optional~Usuario~ buscarPorTelefone(String telefone)
        +Optional~Usuario~ buscarPorEmail(String email)
        +List~Usuario~ buscarPorTipo(String tipoUsuario)
        +Usuario atualizar(Long id, Usuario usuarioAtualizado)
        +void deletar(Long id)
    }

    class CidadeService {
        -CidadeRepository cidadeRepository
        +Cidade cadastrar(Cidade cidade)
        +List~Cidade~ listarTodas()
        +Optional~Cidade~ buscarPorId(Long id)
        +Optional~Cidade~ buscarPorNome(String nome)
        +List~Cidade~ buscarPorEstado(String estado)
        +Cidade atualizar(Long id, Cidade cidadeAtualizada)
        +void deletar(Long id)
    }

    class EquipeCombateService {
        -EquipeCombateRepository equipeCombateRepository
        +EquipeCombate cadastrar(EquipeCombate equipe)
        +List~EquipeCombate~ listarTodas()
        +Optional~EquipeCombate~ buscarPorId(Long id)
        +List~EquipeCombate~ buscarPorStatus(String status)
        +List~EquipeCombate~ buscarPorRegiao(String regiao)
        +List~EquipeCombate~ buscarDisponiveis()
        +List~EquipeCombate~ buscarDisponiveisPorRegiao(String regiao)
        +EquipeCombate atualizarStatus(Long id, String novoStatus)
        +EquipeCombate atualizar(Long id, EquipeCombate equipeAtualizada)
        +void deletar(Long id)
    }

    class OcorrenciaService {
        -OcorrenciaRepository ocorrenciaRepository
        -EquipeCombateRepository equipeRepository
        -NotificacaoService notificacaoService
        +Ocorrencia registrar(Ocorrencia ocorrencia)
        +List~Ocorrencia~ buscarRecentes(Long cidadeId)
        +List~Ocorrencia~ buscarPorPrioridade()
        +Ocorrencia atribuirEquipe(Long ocorrenciaId, Long equipeId)
        +Ocorrencia finalizarOcorrencia(Long ocorrenciaId)
        +List~Ocorrencia~ listarTodas()
        +Optional~Ocorrencia~ buscarPorId(Long id)
    }

    class NotificacaoService {
        -NotificacaoRepository notificacaoRepository
        -UsuarioRepository usuarioRepository
        -TwilioService twilioService
        +Notificacao registrarNotificacao(Usuario usuario, String mensagem, String tipo, Ocorrencia ocorrencia)
        +void enviarAlertas(Ocorrencia ocorrencia)
        +List~Notificacao~ buscarPorUsuario(Long usuarioId)
        +List~Notificacao~ buscarPorOcorrencia(Long ocorrenciaId)
        +List~Notificacao~ listarTodas()
    }

    class TwilioService {
        +void enviarWhatsApp(String telefone, String mensagem)
    }

    %% Controller Classes (Camada de Controle)
    class UsuarioController {
        -UsuarioService usuarioService
        +ResponseEntity~Usuario~ cadastrar(Usuario usuario)
        +List~Usuario~ listarTodos()
        +ResponseEntity~Usuario~ buscarPorId(Long id)
        +List~Usuario~ listarPorCidade(Long cidadeId)
        +ResponseEntity~Usuario~ buscarPorTelefone(String telefone)
        +ResponseEntity~Usuario~ buscarPorEmail(String email)
        +List~Usuario~ buscarPorTipo(String tipoUsuario)
        +ResponseEntity~Usuario~ atualizar(Long id, Usuario usuario)
        +ResponseEntity~Void~ deletar(Long id)
    }

    class CidadeController {
        -CidadeService cidadeService
        +ResponseEntity~Cidade~ cadastrar(Cidade cidade)
        +List~Cidade~ listarTodas()
        +ResponseEntity~Cidade~ buscarPorId(Long id)
        +ResponseEntity~Cidade~ buscarPorNome(String nome)
        +List~Cidade~ buscarPorEstado(String estado)
        +ResponseEntity~Cidade~ atualizar(Long id, Cidade cidade)
        +ResponseEntity~Void~ deletar(Long id)
    }

    class EquipeCombateController {
        -EquipeCombateService equipeCombateService
        +ResponseEntity~EquipeCombate~ cadastrar(EquipeCombate equipe)
        +List~EquipeCombate~ listarTodas()
        +ResponseEntity~EquipeCombate~ buscarPorId(Long id)
        +List~EquipeCombate~ buscarPorStatus(String status)
        +List~EquipeCombate~ buscarPorRegiao(String regiao)
        +List~EquipeCombate~ buscarDisponiveis()
        +List~EquipeCombate~ buscarDisponiveisPorRegiao(String regiao)
        +ResponseEntity~EquipeCombate~ atualizarStatus(Long id, String status)
        +ResponseEntity~EquipeCombate~ atualizar(Long id, EquipeCombate equipe)
        +ResponseEntity~Void~ deletar(Long id)
    }

    class OcorrenciaController {
        -OcorrenciaService ocorrenciaService
        +ResponseEntity~Ocorrencia~ registrar(Ocorrencia ocorrencia)
        +List~Ocorrencia~ listarTodas()
        +ResponseEntity~Ocorrencia~ buscarPorId(Long id)
        +List~Ocorrencia~ listarRecentesPorCidade(Long cidadeId)
        +List~Ocorrencia~ listarPorPrioridade()
        +ResponseEntity~Ocorrencia~ atribuirEquipe(Long id, Long equipeId)
        +ResponseEntity~Ocorrencia~ finalizar(Long id)
    }

    class NotificacaoController {
        -NotificacaoService notificacaoService
        +List~Notificacao~ listarTodas()
        +List~Notificacao~ buscarPorUsuario(Long usuarioId)
        +List~Notificacao~ buscarPorOcorrencia(Long ocorrenciaId)
    }

    class TwilioWebhookController {
        -UsuarioService usuarioService
        -OcorrenciaService ocorrenciaService
        -CidadeService cidadeService
        +ResponseEntity~String~ receberMensagemWhatsApp(String from, String body, String latitude, String longitude)
    }

    %% Repository Interfaces (Camada de Persistência)
    class UsuarioRepository {
        <<interface>>
        +List~Usuario~ findByCidadeId(Long cidadeId)
        +Optional~Usuario~ findByTelefone(String telefone)
        +Optional~Usuario~ findByEmail(String email)
        +List~Usuario~ findByTipoUsuario(String tipoUsuario)
    }

    class CidadeRepository {
        <<interface>>
        +Optional~Cidade~ findByNome(String nome)
        +List~Cidade~ findByEstado(String estado)
    }

    class EquipeCombateRepository {
        <<interface>>
        +List~EquipeCombate~ findByStatus(String status)
        +List~EquipeCombate~ findByRegiao(String regiao)
        +List~EquipeCombate~ findByStatusAndRegiao(String status, String regiao)
    }

    class OcorrenciaRepository {
        <<interface>>
        +List~Ocorrencia~ findByCidadeIdAndDataHoraAfter(Long cidadeId, LocalDateTime dataHora)
        +List~Ocorrencia~ findOcorrenciasAbertasPorPrioridade()
    }

    class NotificacaoRepository {
        <<interface>>
        +List~Notificacao~ findByUsuarioId(Long usuarioId)
        +List~Notificacao~ findByOcorrenciaId(Long ocorrenciaId)
    }

    %% Relacionamentos entre Entidades
    Usuario ||--o{ Notificacao : "1:N"
    Cidade ||--o{ Usuario : "1:N"
    Cidade ||--o{ Ocorrencia : "1:N"
    Ocorrencia ||--o{ Notificacao : "1:N"
    EquipeCombate ||--o{ Ocorrencia : "1:N"

    %% Relacionamentos entre Camadas (Dependências)
    UsuarioController --> UsuarioService : uses
    CidadeController --> CidadeService : uses
    EquipeCombateController --> EquipeCombateService : uses
    OcorrenciaController --> OcorrenciaService : uses
    NotificacaoController --> NotificacaoService : uses
    TwilioWebhookController --> UsuarioService : uses
    TwilioWebhookController --> OcorrenciaService : uses
    TwilioWebhookController --> CidadeService : uses

    UsuarioService --> UsuarioRepository : uses
    CidadeService --> CidadeRepository : uses
    EquipeCombateService --> EquipeCombateRepository : uses
    OcorrenciaService --> OcorrenciaRepository : uses
    OcorrenciaService --> EquipeCombateRepository : uses
    OcorrenciaService --> NotificacaoService : uses
    NotificacaoService --> NotificacaoRepository : uses
    NotificacaoService --> UsuarioRepository : uses
    NotificacaoService --> TwilioService : uses

    %% Operações nas Entidades
    UsuarioService --> Usuario : creates/manages
    CidadeService --> Cidade : creates/manages
    EquipeCombateService --> EquipeCombate : creates/manages
    OcorrenciaService --> Ocorrencia : creates/manages
    NotificacaoService --> Notificacao : creates/manages
```

## Padrões de Design Utilizados

### 1. **Model-View-Controller (MVC)**
- **Controller**: Classes que terminam com `Controller` - responsáveis por receber requisições HTTP
- **Model**: Classes de domínio (`Usuario`, `Cidade`, `Ocorrencia`, etc.)
- **Service**: Camada intermediária que contém a lógica de negócio

### 2. **Repository Pattern**
- Interfaces de repositório que abstraem o acesso aos dados
- Utilizam Spring Data JPA para operações de persistência

### 3. **Dependency Injection**
- Todas as dependências são injetadas via `@Autowired`
- Garante baixo acoplamento entre as camadas

### 4. **Data Transfer Object (DTO) Implícito**
- As entidades JPA servem como DTOs nas APIs REST

## Princípios de Encapsulamento

### **Atributos Privados**
- Todos os atributos das entidades são `private`
- Acesso controlado através de métodos `get` e `set` públicos

### **Métodos Públicos de Acesso**
- Getters e setters para todos os atributos
- Construtores parametrizados e sem parâmetros

### **Separação de Responsabilidades**
- **Entidades**: Representam os dados e regras de domínio
- **Services**: Contêm a lógica de negócio
- **Controllers**: Gerenciam requisições HTTP
- **Repositories**: Abstraem o acesso aos dados

## Relacionamentos e Cardinalidades

### **Relacionamentos One-to-Many (1:N)**
- `Cidade` → `Usuario` (Uma cidade pode ter vários usuários)
- `Cidade` → `Ocorrencia` (Uma cidade pode ter várias ocorrências)
- `Usuario` → `Notificacao` (Um usuário pode receber várias notificações)
- `Ocorrencia` → `Notificacao` (Uma ocorrência pode gerar várias notificações)
- `EquipeCombate` → `Ocorrencia` (Uma equipe pode atender várias ocorrências)

### **Relacionamentos Many-to-One (N:1)**
- `Usuario` → `Cidade` (Vários usuários pertencem a uma cidade)
- `Ocorrencia` → `Cidade` (Várias ocorrências podem acontecer em uma cidade)
- `Notificacao` → `Usuario` (Várias notificações podem ser enviadas para um usuário)
- `Notificacao` → `Ocorrencia` (Várias notificações podem se referir a uma ocorrência)
- `Ocorrencia` → `EquipeCombate` (Várias ocorrências podem ser atendidas por uma equipe)

## Funcionalidades Principais

### **Gestão de Usuários**
- Cadastro de cidadãos, bombeiros e administradores
- Busca por telefone, email, cidade e tipo de usuário

### **Gestão de Ocorrências**
- Registro automático via WhatsApp com coordenadas
- Atribuição de equipes de combate
- Controle de status das ocorrências

### **Sistema de Notificações**
- Envio automático de alertas via WhatsApp
- Notificações baseadas na localização dos usuários

### **Gestão de Equipes**
- Controle de disponibilidade das equipes
- Atribuição automática baseada na região

### **Integração WhatsApp**
- Webhook do Twilio para recebimento de mensagens
- Cadastro automático de usuários
- Extração de coordenadas das mensagens