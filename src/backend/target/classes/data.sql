-- Dados básicos para o FireWatch System

-- Inserir cidades
INSERT INTO cidade (nome, latitude, longitude, estado) VALUES
('São Paulo', -23.5505, -46.6333, 'SP'),
('Rio de Janeiro', -22.9068, -43.1729, 'RJ'),
('Belo Horizonte', -19.9191, -43.9378, 'MG'),
('Salvador', -12.9714, -38.5014, 'BA'),
('Brasília', -15.7801, -47.9292, 'DF');

-- Inserir usuários
INSERT INTO usuario (nome, telefone, email, tipo_usuario, cidade_id) VALUES
('João Silva', '+5511999999999', 'joao.silva@email.com', 'CIDADAO', 1),
('Maria Santos', '+5511888888888', 'maria.santos@email.com', 'BOMBEIRO', 1),
('Pedro Oliveira', '+5521777777777', 'pedro.oliveira@email.com', 'ADMINISTRADOR', 2),
('Ana Costa', '+5531666666666', 'ana.costa@email.com', 'CIDADAO', 3);

-- Inserir equipes de combate
INSERT INTO equipe_combate (nome, status, regiao, numero_membros, tipo_equipamento) VALUES
('Bombeiros SP - Zona Norte', 'DISPONIVEL', 'São Paulo', 5, 'Caminhão-pipa, equipamento básico'),
('Bombeiros RJ - Centro', 'DISPONIVEL', 'Rio de Janeiro', 4, 'Caminhão auto-bomba, escada'),
('Defesa Civil MG', 'DISPONIVEL', 'Belo Horizonte', 6, 'Caminhão-pipa, equipamento florestal');