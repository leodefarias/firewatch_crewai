# Dockerfile para Frontend React
FROM node:18-alpine as builder

WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala dependências
RUN npm ci --only=production

# Copia código fonte
COPY . .

# Build da aplicação
RUN npm run build

# Imagem final com Nginx
FROM nginx:alpine

# Remove configuração padrão do Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia build da aplicação
COPY --from=builder /app/build /usr/share/nginx/html

# Copia configuração customizada do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe porta 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80 || exit 1

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]