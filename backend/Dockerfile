# ----------------------------------------------------
# STAGE 1: BUILD (Instalación de dependencias y pruebas)
# ----------------------------------------------------
FROM node:20-slim AS builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de definición de dependencias
COPY package*.json ./

# Instala dependencias de producción. 
RUN npm install

# Copia el código fuente (después de instalar las dependencias para aprovechar el caché)
COPY . .

# Si tienes un paso de compilación (ej. TypeScript/Babel), ejecutarlo aquí:
# RUN npm run build

# ----------------------------------------------------
# STAGE 2: PRODUCTION (Imagen final ligera)
# ----------------------------------------------------
# Usamos una imagen base aún más pequeña y segura (node:20-alpine)
FROM node:20-alpine

# Define un usuario no root para seguridad (UID 1001)
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
USER appuser

# Establece el directorio de trabajo
WORKDIR /app

# Copia sólo las dependencias y el código necesario desde el stage 'builder'
# 1. Copia el package.json y package-lock.json (si aplica)
COPY --from=builder /app/package*.json ./
# 2. Copia node_modules (dependencias)
COPY --from=builder /app/node_modules ./node_modules
# 3. Copia el código fuente de la aplicación
COPY --from=builder /app ./

# Expone el puerto que la API usa (ej. 5000)
EXPOSE 5000

# Línea CRÍTICA corregida: Usar index.js como punto de entrada
CMD ["node", "src/index.js"]
