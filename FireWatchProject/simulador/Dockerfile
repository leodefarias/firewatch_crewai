# Dockerfile para Simulador Python
FROM python:3.11-slim

WORKDIR /app

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copia requirements
COPY requirements.txt .

# Instala dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia código fonte
COPY . .

# Cria usuário não-root
RUN groupadd -r firewatch && useradd -r -g firewatch firewatch
RUN chown -R firewatch:firewatch /app

# Muda para usuário não-root
USER firewatch

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Comando padrão
CMD ["python", "simulador.py"]