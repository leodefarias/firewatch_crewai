# 🔥 FireWatch - Plataforma de Monitoramento e Alerta de Queimadas

**FireWatch** é um sistema completo para:
- Detectar e registrar ocorrências de queimadas
- Enviar alertas via WhatsApp usando a **API do Twilio**
- Simular atendimentos com inteligência baseada em severidade
- Permitir cadastro de cidades, usuários, equipes e ocorrências
- Visualizar dados em frontend com mapa interativo

---

## 🧱 Tecnologias utilizadas

| Camada       | Tecnologia            |
|--------------|------------------------|
| Backend      | Java, Spring Boot, JPA |
| Frontend     | React, Leaflet         |
| Integração   | Twilio API (WhatsApp)  |
| Simulação    | Python (heap, fila)    |
| Orquestração | CrewAI (para gerar)    |

---

## 🚀 Como rodar o projeto

### 🔧 Pré-requisitos
- Java 17+
- Python 3.8+
- Node.js 16+
- Twilio Account (número verificado)

---

### 🖥️ Backend (Spring Boot)

```bash
cd backend
./mvnw spring-boot:run
