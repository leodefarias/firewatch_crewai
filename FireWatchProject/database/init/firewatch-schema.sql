-- Schema para MySQL/PostgreSQL em produção
-- Este arquivo é carregado automaticamente quando o container é iniciado

-- Criação do banco de dados (se não existir)
CREATE DATABASE IF NOT EXISTS firewatch;
USE firewatch;

-- Tabela de Cidades
CREATE TABLE IF NOT EXISTS cidade (
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

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150) NOT NULL,
    tipo_usuario ENUM('CIDADAO', 'BOMBEIRO', 'ADMINISTRADOR') NOT NULL DEFAULT 'CIDADAO',
    cidade_id BIGINT,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id) ON DELETE SET NULL,
    UNIQUE KEY unique_telefone (telefone),
    UNIQUE KEY unique_email (email),
    INDEX idx_usuario_cidade (cidade_id),
    INDEX idx_usuario_tipo (tipo_usuario),
    INDEX idx_usuario_ativo (ativo)
);

-- Tabela de Equipes de Combate
CREATE TABLE IF NOT EXISTS equipe_combate (
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
    INDEX idx_equipe_regiao (regiao),
    INDEX idx_equipe_capacidade (capacidade_maxima)
);

-- Tabela de Ocorrências
CREATE TABLE IF NOT EXISTS ocorrencia (
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
    tempo_estimado_resolucao INT, -- em minutos
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
    INDEX idx_ocorrencia_data (data_hora DESC),
    INDEX idx_ocorrencia_cidade (cidade_id),
    INDEX idx_ocorrencia_equipe (equipe_id),
    INDEX idx_ocorrencia_prioridade (prioridade),
    INDEX idx_ocorrencia_coordenadas (latitude, longitude)
);

-- Tabela de Notificações
CREATE TABLE IF NOT EXISTS notificacao (
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
    FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id) ON DELETE CASCADE,
    INDEX idx_notificacao_usuario (usuario_id),
    INDEX idx_notificacao_ocorrencia (ocorrencia_id),
    INDEX idx_notificacao_tipo (tipo_notificacao),
    INDEX idx_notificacao_status (status),
    INDEX idx_notificacao_timestamp (timestamp DESC),
    INDEX idx_notificacao_prioridade (prioridade)
);

-- Tabela de Log de Ações
CREATE TABLE IF NOT EXISTS log_acao (
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
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL,
    INDEX idx_log_usuario (usuario_id),
    INDEX idx_log_acao (acao),
    INDEX idx_log_tabela (tabela_afetada),
    INDEX idx_log_timestamp (timestamp DESC)
);

-- Tabela de Recursos das Equipes
CREATE TABLE IF NOT EXISTS recurso_equipe (
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
    FOREIGN KEY (equipe_id) REFERENCES equipe_combate(id) ON DELETE CASCADE,
    INDEX idx_recurso_equipe (equipe_id),
    INDEX idx_recurso_tipo (tipo_recurso),
    INDEX idx_recurso_status (status)
);

-- Views para relatórios e consultas frequentes
CREATE OR REPLACE VIEW vw_ocorrencias_ativas AS
SELECT 
    o.id,
    o.data_hora,
    o.severidade,
    o.prioridade,
    o.descricao,
    o.latitude,
    o.longitude,
    o.status,
    o.area_afetada_km2,
    o.custo_estimado,
    c.nome as cidade_nome,
    c.estado,
    e.nome as equipe_nome,
    e.status as equipe_status,
    e.numero_membros,
    u.nome as reporter_nome,
    u.telefone as reporter_telefone,
    TIMESTAMPDIFF(MINUTE, o.data_hora, NOW()) as minutos_desde_abertura
FROM ocorrencia o
JOIN cidade c ON o.cidade_id = c.id
LEFT JOIN equipe_combate e ON o.equipe_id = e.id
LEFT JOIN usuario u ON o.usuario_reporter_id = u.id
WHERE o.status IN ('ABERTA', 'EM_ATENDIMENTO')
ORDER BY o.severidade DESC, o.data_hora ASC;

CREATE OR REPLACE VIEW vw_estatisticas_dashboard AS
SELECT 
    COUNT(CASE WHEN o.status = 'ABERTA' THEN 1 END) as ocorrencias_abertas,
    COUNT(CASE WHEN o.status = 'EM_ATENDIMENTO' THEN 1 END) as ocorrencias_em_atendimento,
    COUNT(CASE WHEN o.status = 'FINALIZADA' THEN 1 END) as ocorrencias_finalizadas_hoje,
    COUNT(CASE WHEN e.status = 'DISPONIVEL' THEN 1 END) as equipes_disponiveis,
    COUNT(CASE WHEN e.status = 'EM_ACAO' THEN 1 END) as equipes_em_acao,
    COUNT(CASE WHEN e.status = 'INDISPONIVEL' THEN 1 END) as equipes_indisponiveis,
    COUNT(DISTINCT u.id) as total_usuarios_ativos,
    ROUND(AVG(CASE WHEN o.status IN ('ABERTA', 'EM_ATENDIMENTO') THEN o.severidade END), 2) as severidade_media_ativa,
    COUNT(CASE WHEN o.data_hora >= CURDATE() THEN 1 END) as ocorrencias_hoje
FROM ocorrencia o
CROSS JOIN equipe_combate e
CROSS JOIN usuario u
WHERE u.ativo = TRUE;

CREATE OR REPLACE VIEW vw_performance_equipes AS
SELECT 
    e.id,
    e.nome,
    e.regiao,
    e.status,
    COUNT(o.id) as total_atendimentos,
    AVG(CASE WHEN o.finalizada_em IS NOT NULL 
             THEN TIMESTAMPDIFF(MINUTE, o.data_hora, o.finalizada_em) 
             END) as tempo_medio_resolucao_minutos,
    SUM(CASE WHEN o.status = 'FINALIZADA' THEN 1 ELSE 0 END) as atendimentos_finalizados,
    AVG(o.severidade) as severidade_media_atendida,
    SUM(COALESCE(o.custo_estimado, 0)) as custo_total_operacoes
FROM equipe_combate e
LEFT JOIN ocorrencia o ON e.id = o.equipe_id
GROUP BY e.id, e.nome, e.regiao, e.status;

-- Triggers para auditoria
DELIMITER //

CREATE TRIGGER tr_usuario_audit 
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
    INSERT INTO log_acao (usuario_id, acao, tabela_afetada, registro_id, dados_anteriores, dados_novos)
    VALUES (NEW.id, 'UPDATE', 'usuario', NEW.id, 
            JSON_OBJECT('nome', OLD.nome, 'email', OLD.email, 'tipo_usuario', OLD.tipo_usuario),
            JSON_OBJECT('nome', NEW.nome, 'email', NEW.email, 'tipo_usuario', NEW.tipo_usuario));
END//

CREATE TRIGGER tr_ocorrencia_status_update
AFTER UPDATE ON ocorrencia
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO log_acao (acao, tabela_afetada, registro_id, dados_anteriores, dados_novos)
        VALUES ('STATUS_CHANGE', 'ocorrencia', NEW.id,
                JSON_OBJECT('status', OLD.status),
                JSON_OBJECT('status', NEW.status));
        
        -- Atualiza timestamp de finalização
        IF NEW.status = 'FINALIZADA' AND OLD.status != 'FINALIZADA' THEN
            UPDATE ocorrencia SET finalizada_em = NOW() WHERE id = NEW.id;
        END IF;
    END IF;
END//

DELIMITER ;

-- Índices compostos para queries complexas
CREATE INDEX idx_ocorrencia_cidade_status ON ocorrencia(cidade_id, status);
CREATE INDEX idx_ocorrencia_equipe_status ON ocorrencia(equipe_id, status);
CREATE INDEX idx_notificacao_usuario_status ON notificacao(usuario_id, status);
CREATE INDEX idx_log_timestamp_acao ON log_acao(timestamp DESC, acao);

-- Comentários nas tabelas
ALTER TABLE cidade COMMENT = 'Cadastro de cidades monitoradas pelo sistema FireWatch';
ALTER TABLE usuario COMMENT = 'Usuários do sistema (cidadãos, bombeiros, administradores)';
ALTER TABLE equipe_combate COMMENT = 'Equipes disponíveis para combate a incêndios';
ALTER TABLE ocorrencia COMMENT = 'Registro de ocorrências de incêndio';
ALTER TABLE notificacao COMMENT = 'Histórico de notificações enviadas aos usuários';
ALTER TABLE log_acao COMMENT = 'Log de auditoria das ações realizadas no sistema';
ALTER TABLE recurso_equipe COMMENT = 'Recursos e equipamentos das equipes de combate';