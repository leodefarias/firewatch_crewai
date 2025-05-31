import heapq
from datetime import datetime
import bisect

class Ocorrencia:
    def __init__(self, id, cidade, severidade, descricao):
        self.id = id
        self.cidade = cidade
        self.severidade = severidade
        self.descricao = descricao
        self.timestamp = datetime.now()

    def __lt__(self, other): return self.severidade > other.severidade
    def __str__(self): return f"[{self.id}] {self.cidade} | S:{self.severidade} | {self.descricao}"
    def __repr__(self): return f"Ocorrencia({self.id})"

class Central:
    def __init__(self):
        self.fila_prioridade = []
        self.ordenadas_por_id = []
        self.index_ids = []

    def inserir(self, o):
        heapq.heappush(self.fila_prioridade, o)  # O(log n)
        idx = bisect.bisect_left(self.index_ids, o.id)  # O(log n)
        self.index_ids.insert(idx, o.id)
        self.ordenadas_por_id.insert(idx, o)
        print(f"🔥 Adicionada: {o}")

    def atender(self):
        if not self.fila_prioridade:
            print("✅ Nenhuma ocorrência")
            return
        o = heapq.heappop(self.fila_prioridade)  # O(log n)
        print(f"🚒 Atendida: {o}")

    def listar(self):
        print("\n📋 Ocorrências Pendentes:")
        for o in sorted(self.fila_prioridade, reverse=True):  # O(n log n)
            print("  -", o)

    def buscar_por_id_linear(self, id_busca):  # O(n)
        for o in self.ordenadas_por_id:
            if o.id == id_busca:
                return o
        return None

    def buscar_por_id_binaria(self, id_busca):  # O(log n)
        idx = bisect.bisect_left(self.index_ids, id_busca)
        if idx < len(self.index_ids) and self.index_ids[idx] == id_busca:
            return self.ordenadas_por_id[idx]
        return None

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

# 🧪 Demonstração
if __name__ == "__main__":
    central = Central()

    ocorrencias = [
        Ocorrencia(10, "SP", 3, "Incêndio leve"),
        Ocorrencia(4, "RJ", 5, "Grave"),
        Ocorrencia(7, "MG", 4, "Fumaça"),
        Ocorrencia(2, "BA", 1, "Sinal fraco"),
    ]
    for o in ocorrencias:
        central.inserir(o)

    central.listar()
    central.atender()

    print("\n🔍 Busca binária ID 7:", central.buscar_por_id_binaria(7))
    print("🔎 Busca linear ID 7:", central.buscar_por_id_linear(7))

    print("\n🫧 Bubble Sort (Severidade):", [o.severidade for o in bubble_sort_ocorrencias(ocorrencias[:])])
    print("🔀 Merge Sort (Severidade):", [o.severidade for o in merge_sort_ocorrencias(ocorrencias[:])])

    grafo = {
        "SP": [("RJ", 6), ("MG", 2)],
        "RJ": [("BA", 4)],
        "MG": [("BA", 1)],
        "BA": []
    }
    print("\n📍 Dijkstra a partir de SP:", dijkstra(grafo, "SP"))

    print("\n🧠 Menor custo simulado:", menor_custo_ocorrencias(ocorrencias))
