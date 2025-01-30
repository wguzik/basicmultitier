# Stage 1: Build stage
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies including dev dependencies
RUN npm install

# Install dependencies including Prisma
RUN npm install @prisma/client
RUN npm install prisma --save-dev

# Generate Prisma Client
RUN npx prisma generate

# Copy source code
COPY . .

# Stage 2: Production stage
FROM node:20-alpine AS production

RUN apk update \
	&& apk add --no-cache openssl\
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/apk/*

# Add node user for security
RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY prisma ./prisma/
COPY entrypoint.sh ./

# Install only production dependencies
RUN npm install --only=production

# Generate Prisma Client
RUN npx prisma generate

# Copy application from builder
COPY --from=builder /app/src ./src

# Change ownership of the app directory
RUN chown -R nodeuser:nodegroup /app

# Switch to non-root user
USER nodeuser

# Set Node.js to production mode
ENV NODE_ENV=production

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s \
    CMD node -e "require('http').get('http://localhost:3001/health', (r) => r.statusCode === 200 ? process.exit(0) : process.exit(1))"

RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]