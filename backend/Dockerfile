# ----------------------------------------------------
# STAGE 1: BUILD (Instalación de dependencias)
# ----------------------------------------------------
FROM node:20-slim AS builder

# Establece el directorio de trabajo
WORKDIR /app

# 💡 Optimización de Caché:
COPY package*.json ./

# Instala dependencias de producción.
RUN npm install

# Copia el código fuente 
COPY . .

# ----------------------------------------------------
# STAGE 2: PRODUCTION (Imagen final ligera y segura)
# ----------------------------------------------------
FROM node:20-alpine

# Define un usuario no root para seguridad (UID 1001)
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser

# Establece el directorio de trabajo
WORKDIR /app

# 💡 Multistage Copy: Copia solo los archivos necesarios para la ejecución
# Copia el paquete de dependencias instalado (node_modules)
COPY --from=builder /app/node_modules ./node_modules
# Copia el código fuente (server.js, rutas, etc.)
COPY --from=builder /app/ ./

# Expone el puerto que la API usa (ej. 5000)
EXPOSE 5000

CMD [ "node", "server.js" ]
