-- Schema SQL para FireWatch System
-- Database: H2 (para desenvolvimento) / MySQL (para produção)

-- Tabela de Cidades
CREATE TABLE IF NOT EXISTS cidade (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    latitude DOUBLE,
    longitude DOUBLE,
    estado VARCHAR(2) NOT NULL,
    CONSTRAINT unique_cidade_estado UNIQUE (nome, estado)
);

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    endereco VARCHAR(250),
    tipo_usuario VARCHAR(20) NOT NULL DEFAULT 'CIDADAO',
    cidade_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id),
    CONSTRAINT unique_telefone UNIQUE (telefone)
);

-- Tabela de Equipes de Combate
CREATE TABLE IF NOT EXISTS equipe_combate (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL',
    regiao VARCHAR(100) NOT NULL,
    numero_membros INT NOT NULL DEFAULT 1,
    tipo_equipamento VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Ocorrências
CREATE TABLE IF NOT EXISTS ocorrencia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    severidade INT NOT NULL,
    descricao TEXT NOT NULL,
    latitude DOUBLE,
    longitude DOUBLE,
    status VARCHAR(20) NOT NULL DEFAULT 'ABERTA',
    cidade_id BIGINT NOT NULL,
    equipe_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id),
    FOREIGN KEY (equipe_id) REFERENCES equipe_combate(id)
);

-- Tabela de Notificações
CREATE TABLE IF NOT EXISTS notificacao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mensagem TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ENVIADA',
    tipo_notificacao VARCHAR(30) NOT NULL,
    usuario_id BIGINT NOT NULL,
    ocorrencia_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);




