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

# Build the application
RUN npm run build

# Stage 2: Production stage
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install serve package globally
RUN npm install -g serve

# Copy built assets from builder
COPY --from=builder /app/build ./build

# Create and use non-root user
RUN addgroup -S nodegroup && \
    adduser -S nodeuser -G nodegroup && \
    chown -R nodeuser:nodegroup /app

USER nodeuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s \
    CMD wget --quiet --tries=1 --spider http://localhost:3000 || exit 1

# Start the application
CMD ["serve", "-s", "build", "-l", "3000"]