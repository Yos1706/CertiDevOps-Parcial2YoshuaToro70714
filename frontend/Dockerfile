# Stage 1: Build the application
FROM node:20-alpine AS build

# Create app directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build the frontend (adjust this command based on your actual build process, e.g., vite/webpack)
RUN npm run build

# Stage 2: Serve the application with Nginx (Lightweight)
FROM nginx:alpine

# Create non-root user (UID 1001) for security, necessary for volume mounts in docker-compose
RUN addgroup -g 1001 node \
    && adduser -u 1001 -G node -s /bin/sh -D node

# Copy build output from the build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx configuration (assuming you have one, or use default)
COPY nginx.conf /etc/nginx/nginx.conf

# Switch to non-root user
# Note: Nginx usually runs as root, so we ensure the entrypoint is ready for the user change
RUN mkdir -p /var/cache/nginx/client_temp && chown -R 1001:1001 /var/cache/nginx
USER node

# Expose the application port
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
