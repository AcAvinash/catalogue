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

# Copy built app from builder stage
COPY --from=builder /opt/server /opt/server

# Expose port
EXPOSE 8080

# Start application
CMD ["node", "server.js"]



