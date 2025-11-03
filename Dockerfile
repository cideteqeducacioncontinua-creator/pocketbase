# Usa una imagen base pequeña de Linux
FROM debian:bookworm-slim

# Instalar herramientas necesarias (ca-certificates para HTTPS, curl para descargar, unzip)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Descargar la última versión de PocketBase
# **Asegúrate de que la URL de descarga sea la última versión para Linux (amd64)**
RUN curl -L -o /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v0.31.0/pocketbase_0.31.0_linux_amd64.zip

# Descomprimir el binario y moverlo a /usr/bin
RUN unzip /tmp/pb.zip -d /usr/bin/
RUN chmod +x /usr/bin/pocketbase

# Establecer la carpeta de trabajo
WORKDIR /pb

# Exponer el puerto
EXPOSE 8080

# Definir el comando de inicio (el mismo que en fly.toml, apuntando al volumen)
CMD ["/usr/bin/pocketbase", "serve", "--http", "0.0.0.0:8080", "--dir", "/pb/pb_data"]
