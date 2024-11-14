# Stage 1: Build stage
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build with build-time variables
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL
RUN npm run build

# Stage 2: Production stage
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install serve
RUN npm install -g serve

# Copy built assets from builder
COPY --from=builder /app/build ./build

# Copy start script
COPY start.sh /app/start.sh

# Make script executable
RUN chmod +x /app/start.sh

# Inject the env-config.js script into index.html
RUN sed -i '/<head>/a \    <script src="%PUBLIC_URL%/env-config.js"></script>' ./build/index.html

# Create and use non-root user
RUN addgroup -S nodegroup && \
    adduser -S nodeuser -G nodegroup && \
    chown -R nodeuser:nodegroup /app

USER nodeuser


EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s \
    CMD wget --quiet --tries=1 --spider http://localhost:3000 || exit 1

# Use the start script
CMD ["/app/start.sh"]