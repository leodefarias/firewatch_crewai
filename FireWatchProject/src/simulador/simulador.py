import heapq
import json
import requests
from datetime import datetime, timedelta
import bisect
import random
import time
from typing import List, Dict, Optional

class Ocorrencia:
    def __init__(self, id, cidade, severidade, descricao, latitude=None, longitude=None, status="ABERTA"):
        self.id = id
        self.cidade = cidade
        self.severidade = severidade
        self.descricao = descricao
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.timestamp = datetime.now()
        self.tempo_estimado_resolucao = self._calcular_tempo_resolucao()

    def _calcular_tempo_resolucao(self):
        """Calcula tempo estimado de resolução baseado na severidade"""
        base_minutos = 30
        multiplicador = self.severidade * 10
        return base_minutos + multiplicador

    def __lt__(self, other): 
        # Prioridade: severidade maior primeiro, depois mais antigo
        if self.severidade != other.severidade:
            return self.severidade > other.severidade
        return self.timestamp < other.timestamp
    
    def __str__(self): 
        return f"[{self.id}] {self.cidade} | S:{self.severidade}/10 | {self.descricao} | {self.status}"
    
    def __repr__(self): 
        return f"Ocorrencia({self.id}, {self.severidade})"
    
    def to_dict(self):
        return {
            'id': self.id,
            'cidade': self.cidade,
            'severidade': self.severidade,
            'descricao': self.descricao,
            'latitude': self.latitude,
            'longitude': self.longitude,
            'status': self.status,
            'timestamp': self.timestamp.isoformat(),
            'tempo_estimado': self.tempo_estimado_resolucao
        }

class EquipeCombate:
    def __init__(self, id, nome, regiao, status="DISPONIVEL", capacidade=1):
        self.id = id
        self.nome = nome
        self.regiao = regiao
        self.status = status
        self.capacidade = capacidade
        self.ocorrencias_atribuidas = []
        
    def atribuir_ocorrencia(self, ocorrencia):
        if len(self.ocorrencias_atribuidas) < self.capacidade:
            self.ocorrencias_atribuidas.append(ocorrencia)
            self.status = "EM_ACAO"
            return True
        return False
        
    def finalizar_ocorrencia(self, ocorrencia_id):
        self.ocorrencias_atribuidas = [o for o in self.ocorrencias_atribuidas if o.id != ocorrencia_id]
        if not self.ocorrencias_atribuidas:
            self.status = "DISPONIVEL"

class CentralEmergencia:
    def __init__(self, api_url="http://localhost:8080/api"):
        self.fila_prioridade = []  # Heap para priorização
        self.ocorrencias_ativas = {}  # Dict para busca rápida por ID
        self.equipes = []  # Lista de equipes disponíveis
        self.historico_atendimentos = []
        self.api_url = api_url
        self.stats = {
            'total_ocorrencias': 0,
            'total_atendidas': 0,
            'tempo_medio_resposta': 0,
            'eficiencia_equipes': {}
        }

    def inserir_ocorrencia(self, ocorrencia):
        """Insere nova ocorrência na fila de prioridade - O(log n)"""
        heapq.heappush(self.fila_prioridade, ocorrencia)
        self.ocorrencias_ativas[ocorrencia.id] = ocorrencia
        self.stats['total_ocorrencias'] += 1
        
        print(f"🔥 Nova ocorrência adicionada: {ocorrencia}")
        self._tentar_atribuir_equipe_automatica(ocorrencia)
        
        # Enviar para API se disponível
        self._enviar_para_api(ocorrencia)

    def _enviar_para_api(self, ocorrencia):
        """Envia ocorrência para a API do backend"""
        try:
            data = {
                'descricao': ocorrencia.descricao,
                'severidade': ocorrencia.severidade,
                'latitude': ocorrencia.latitude or -14.235,
                'longitude': ocorrencia.longitude or -51.925,
                'cidade': {
                    'id': 1,  # ID padrão para simulação
                    'nome': ocorrencia.cidade
                }
            }
            response = requests.post(f"{self.api_url}/ocorrencias", json=data, timeout=5)
            if response.status_code == 200:
                print(f"✅ Ocorrência {ocorrencia.id} enviada para API")
            else:
                print(f"⚠️ Erro ao enviar para API: {response.status_code}")
        except Exception as e:
            print(f"⚠️ API indisponível: {e}")

    def _tentar_atribuir_equipe_automatica(self, ocorrencia):
        """Tenta atribuir automaticamente uma equipe baseada na prioridade"""
        equipes_disponiveis = [e for e in self.equipes if e.status == "DISPONIVEL"]
        
        if equipes_disponiveis:
            # Escolhe equipe por região ou proximidade
            equipe_escolhida = self._escolher_melhor_equipe(ocorrencia, equipes_disponiveis)
            if equipe_escolhida:
                self.atribuir_equipe(ocorrencia.id, equipe_escolhida.id)

    def _escolher_melhor_equipe(self, ocorrencia, equipes_disponiveis):
        """Algoritmo para escolher a melhor equipe para uma ocorrência"""
        # Prioridade 1: Equipe da mesma região
        for equipe in equipes_disponiveis:
            if equipe.regiao.lower() == ocorrencia.cidade.lower():
                return equipe
        
        # Prioridade 2: Primeira equipe disponível
        return equipes_disponiveis[0] if equipes_disponiveis else None

    def atender_proxima(self):
        """Atende a próxima ocorrência de maior prioridade - O(log n)"""
        if not self.fila_prioridade:
            print("✅ Nenhuma ocorrência pendente")
            return None
            
        ocorrencia = heapq.heappop(self.fila_prioridade)
        ocorrencia.status = "FINALIZADA"
        
        # Remove do dict de ativas
        if ocorrencia.id in self.ocorrencias_ativas:
            del self.ocorrencias_ativas[ocorrencia.id]
        
        # Adiciona ao histórico
        tempo_resposta = (datetime.now() - ocorrencia.timestamp).total_seconds() / 60
        self.historico_atendimentos.append({
            'ocorrencia': ocorrencia,
            'tempo_resposta_minutos': tempo_resposta,
            'finalizada_em': datetime.now()
        })
        
        self.stats['total_atendidas'] += 1
        self._atualizar_stats()
        
        print(f"🚒 Ocorrência atendida: {ocorrencia} | Tempo: {tempo_resposta:.1f}min")
        return ocorrencia

    def atribuir_equipe(self, ocorrencia_id, equipe_id):
        """Atribui uma equipe específica a uma ocorrência"""
        ocorrencia = self.ocorrencias_ativas.get(ocorrencia_id)
        equipe = next((e for e in self.equipes if e.id == equipe_id), None)
        
        if not ocorrencia or not equipe:
            print(f"❌ Ocorrência {ocorrencia_id} ou equipe {equipe_id} não encontrada")
            return False
            
        if equipe.atribuir_ocorrencia(ocorrencia):
            ocorrencia.status = "EM_ATENDIMENTO"
            print(f"👥 Equipe '{equipe.nome}' atribuída à ocorrência {ocorrencia_id}")
            return True
        else:
            print(f"❌ Equipe '{equipe.nome}' não disponível")
            return False

    def listar_ocorrencias_ativas(self):
        """Lista todas as ocorrências por ordem de prioridade"""
        print("\n📋 Ocorrências Ativas (por prioridade):")
        if not self.fila_prioridade:
            print("  Nenhuma ocorrência ativa")
            return
            
        # Cria uma cópia ordenada sem alterar o heap
        ocorrencias_ordenadas = sorted(self.fila_prioridade, key=lambda x: (-x.severidade, x.timestamp))
        
        for i, ocorrencia in enumerate(ocorrencias_ordenadas, 1):
            tempo_espera = (datetime.now() - ocorrencia.timestamp).total_seconds() / 60
            print(f"  {i}. {ocorrencia} | Espera: {tempo_espera:.1f}min")

    def buscar_ocorrencia(self, ocorrencia_id):
        """Busca ocorrência por ID - O(1)"""
        return self.ocorrencias_ativas.get(ocorrencia_id)

    def adicionar_equipe(self, equipe):
        """Adiciona nova equipe ao sistema"""
        self.equipes.append(equipe)
        self.stats['eficiencia_equipes'][equipe.id] = {'atendimentos': 0, 'tempo_total': 0}
        print(f"👥 Equipe adicionada: {equipe.nome} - {equipe.regiao}")

    def listar_equipes(self):
        """Lista todas as equipes e seus status"""
        print("\n👥 Equipes de Combate:")
        for equipe in self.equipes:
            ocorrencias_str = f"({len(equipe.ocorrencias_atribuidas)} ativas)" if equipe.ocorrencias_atribuidas else ""
            print(f"  {equipe.id}. {equipe.nome} - {equipe.regiao} | {equipe.status} {ocorrencias_str}")

    def _atualizar_stats(self):
        """Atualiza estatísticas do sistema"""
        if self.historico_atendimentos:
            tempos = [h['tempo_resposta_minutos'] for h in self.historico_atendimentos]
            self.stats['tempo_medio_resposta'] = sum(tempos) / len(tempos)

    def gerar_relatorio(self):
        """Gera relatório completo do sistema"""
        print("\n📊 RELATÓRIO DO SISTEMA FIREWATCH")
        print("=" * 50)
        print(f"Total de ocorrências: {self.stats['total_ocorrencias']}")
        print(f"Total atendidas: {self.stats['total_atendidas']}")
        print(f"Pendentes: {len(self.fila_prioridade)}")
        print(f"Tempo médio de resposta: {self.stats['tempo_medio_resposta']:.1f} minutos")
        print(f"Equipes ativas: {len([e for e in self.equipes if e.status == 'EM_ACAO'])}")
        print(f"Equipes disponíveis: {len([e for e in self.equipes if e.status == 'DISPONIVEL'])}")
        
        if self.fila_prioridade:
            severidades = [o.severidade for o in self.fila_prioridade]
            print(f"Severidade média pendente: {sum(severidades)/len(severidades):.1f}")
            print(f"Ocorrência mais crítica: {max(severidades)}/10")
        
        return self.stats
        
    def simular_atendimento_continuo(self, duracao_minutos=60):
        """Simula atendimento contínuo por um período"""
        print(f"\n🚀 Iniciando simulação de {duracao_minutos} minutos...")
        inicio = datetime.now()
        
        while (datetime.now() - inicio).total_seconds() < duracao_minutos * 60:
            # Processa ocorrências pendentes
            if self.fila_prioridade:
                # Simula tempo de processamento
                time.sleep(1)
                
                # Chance de finalizar ocorrência em atendimento
                if random.random() < 0.3:  # 30% chance a cada ciclo
                    self.atender_proxima()
            
            # Pausa entre ciclos
            time.sleep(5)
        
        print(f"✅ Simulação finalizada. Duração: {duracao_minutos} minutos")
        self.gerar_relatorio()

# 🫧 Bubble Sort – O(n²)
def bubble_sort_ocorrencias(ocorrencias):
    n = len(ocorrencias)
    for i in range(n):
        for j in range(0, n - i - 1):
            if ocorrencias[j].severidade < ocorrencias[j + 1].severidade:
                ocorrencias[j], ocorrencias[j + 1] = ocorrencias[j + 1], ocorrencias[j]
    return ocorrencias

# 🔀 Merge Sort – O(n log n)
def merge_sort_ocorrencias(ocorrencias):
    if len(ocorrencias) <= 1:
        return ocorrencias
    meio = len(ocorrencias) // 2
    esq = merge_sort_ocorrencias(ocorrencias[:meio])
    dir = merge_sort_ocorrencias(ocorrencias[meio:])
    return merge(esq, dir)

def merge(esq, dir):
    resultado = []
    i = j = 0
    while i < len(esq) and j < len(dir):
        if esq[i].severidade > dir[j].severidade:
            resultado.append(esq[i])
            i += 1
        else:
            resultado.append(dir[j])
            j += 1
    resultado.extend(esq[i:])
    resultado.extend(dir[j:])
    return resultado

# 📍 Dijkstra – O(E log V)
def dijkstra(grafo, origem):
    dist = {cidade: float('inf') for cidade in grafo}
    dist[origem] = 0
    fila = [(0, origem)]
    while fila:
        atual_dist, atual = heapq.heappop(fila)
        if atual_dist > dist[atual]:
            continue
        for vizinho, peso in grafo[atual]:
            nova_dist = atual_dist + peso
            if nova_dist < dist[vizinho]:
                dist[vizinho] = nova_dist
                heapq.heappush(fila, (nova_dist, vizinho))
    return dist

# 🧠 Programação Dinâmica – O(n)
def menor_custo_ocorrencias(ocorrencias, i=0, memo={}):
    if i >= len(ocorrencias):
        return 0
    if i in memo:
        return memo[i]
    atual = ocorrencias[i].severidade
    pular = menor_custo_ocorrencias(ocorrencias, i + 2, memo)
    seguir = menor_custo_ocorrencias(ocorrencias, i + 1, memo)
    memo[i] = min(atual + pular, seguir)
    return memo[i]

def gerar_ocorrencias_aleatorias(quantidade=10):
    """Gera ocorrências aleatórias para simulação"""
    cidades = ["São Paulo", "Rio de Janeiro", "Belo Horizonte", "Salvador", "Brasília", "Curitiba", "Recife", "Manaus"]
    descricoes = [
        "Incêndio em vegetação", "Queimada em plantação", "Fogo em área urbana",
        "Incêndio florestal", "Queima de lixo", "Incêndio industrial",
        "Fogo em residência", "Queimada controlada", "Incêndio em shopping"
    ]
    
    ocorrencias = []
    for i in range(quantidade):
        ocorrencia = Ocorrencia(
            id=i + 1,
            cidade=random.choice(cidades),
            severidade=random.randint(1, 10),
            descricao=random.choice(descricoes),
            latitude=random.uniform(-33.75, 5.25),  # Brasil approx
            longitude=random.uniform(-73.99, -28.84)
        )
        ocorrencias.append(ocorrencia)
    
    return ocorrencias

def demonstracao_algoritmos():
    """Demonstra diferentes algoritmos de ordenação e busca"""
    print("\n🧪 DEMONSTRAÇÃO DE ALGORITMOS")
    print("=" * 50)
    
    # Gera dados de teste
    ocorrencias = gerar_ocorrencias_aleatorias(8)
    
    # Bubble Sort
    print("\n🫧 Bubble Sort por severidade:")
    bubble_sorted = bubble_sort_ocorrencias(ocorrencias[:])
    print([f"{o.severidade}" for o in bubble_sorted])
    
    # Merge Sort
    print("\n🔀 Merge Sort por severidade:")
    merge_sorted = merge_sort_ocorrencias(ocorrencias[:])
    print([f"{o.severidade}" for o in merge_sorted])
    
    # Dijkstra para roteamento de equipes
    grafo_cidades = {
        "São Paulo": [("Rio de Janeiro", 6), ("Belo Horizonte", 2)],
        "Rio de Janeiro": [("Salvador", 4), ("Belo Horizonte", 3)],
        "Belo Horizonte": [("Salvador", 1), ("Brasília", 2)],
        "Salvador": [("Recife", 3)],
        "Brasília": [("Curitiba", 4)],
        "Curitiba": [],
        "Recife": [],
        "Manaus": []
    }
    
    print("\n📍 Dijkstra - Menor distância de São Paulo:")
    distancias = dijkstra(grafo_cidades, "São Paulo")
    for cidade, dist in sorted(distancias.items()):
        print(f"  {cidade}: {dist if dist != float('inf') else '∞'}")
    
    # Programação dinâmica
    print("\n🧠 Programação Dinâmica - Otimização de recursos:")
    custo_otimo = menor_custo_ocorrencias(ocorrencias)
    print(f"  Custo mínimo calculado: {custo_otimo}")

def main():
    """Função principal do simulador"""
    print("🔥 FIREWATCH SIMULATION SYSTEM")
    print("=" * 50)
    
    # Inicializa central de emergência
    central = CentralEmergencia()
    
    # Adiciona equipes de combate
    equipes = [
        EquipeCombate(1, "Bombeiros SP - Zona Norte", "São Paulo", capacidade=2),
        EquipeCombate(2, "Bombeiros RJ - Centro", "Rio de Janeiro"),
        EquipeCombate(3, "Defesa Civil MG", "Belo Horizonte"),
        EquipeCombate(4, "Corpo de Bombeiros BA", "Salvador"),
        EquipeCombate(5, "Bombeiros DF", "Brasília")
    ]
    
    for equipe in equipes:
        central.adicionar_equipe(equipe)
    
    # Gera ocorrências iniciais
    print("\n🎲 Gerando ocorrências aleatórias...")
    ocorrencias_iniciais = gerar_ocorrencias_aleatorias(12)
    
    for ocorrencia in ocorrencias_iniciais:
        central.inserir_ocorrencia(ocorrencia)
        time.sleep(0.5)  # Simula chegada gradual
    
    # Exibe status inicial
    central.listar_ocorrencias_ativas()
    central.listar_equipes()
    
    # Simula processamento de algumas ocorrências
    print("\n🚒 Processando ocorrências...")
    for _ in range(5):
        central.atender_proxima()
        time.sleep(1)
    
    # Adiciona mais ocorrências durante operação
    print("\n🔥 Novas ocorrências chegando...")
    novas_ocorrencias = gerar_ocorrencias_aleatorias(5)
    for ocorrencia in novas_ocorrencias:
        ocorrencia.id += 100  # Evita conflito de IDs
        central.inserir_ocorrencia(ocorrencia)
    
    # Status final
    central.listar_ocorrencias_ativas()
    central.gerar_relatorio()
    
    # Demonstração de algoritmos
    demonstracao_algoritmos()
    
    print("\n✅ Simulação concluída com sucesso!")

if __name__ == "__main__":
    main()
