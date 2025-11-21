# ==========================
# Builder stage
# ==========================
FROM node:20-alpine3.20 AS builder

# Set working directory
WORKDIR /opt/server

# Copy only package.json first for caching
COPY package.json ./

# Install dependencies with registry to avoid DNS issues
RUN npm install --registry=https://registry.npmjs.org/

# Copy all source files
COPY *.js ./

# ==========================
# Final runtime stage
# ==========================
FROM node:20-alpine3.20

# Create non-root user
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop

# Install runtime dependencies
RUN apk update && apk add --no-cache musl openssl

# Set environment variables
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"

# Set working directory
WORKDIR /opt/server

# Switch to non-root user
USER roboshop

# Copy built app and dependencies from builder stage
COPY --from=builder /opt/server /opt/server

# Expose app port
EXPOSE 8080

# Start the application
CMD ["node", "server.js"]
