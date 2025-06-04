# Dockerfile para Backend Spring Boot
FROM openjdk:17-jdk-slim as builder

WORKDIR /app

# Copia arquivos de configuração do Maven
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

# Baixa dependências
RUN ./mvnw dependency:go-offline -B

# Copia código fonte
COPY src src

# Compila a aplicação
RUN ./mvnw clean package -DskipTests

# Imagem final
FROM openjdk:17-jre-slim

# Instala curl para health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Cria usuário não-root
RUN groupadd -r firewatch && useradd -r -g firewatch firewatch

# Copia JAR da etapa de build
COPY --from=builder /app/target/*.jar app.jar

# Cria diretórios para logs
RUN mkdir -p /app/logs && chown -R firewatch:firewatch /app

# Muda para usuário não-root
USER firewatch

# Expõe porta
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Comando para iniciar aplicação
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]