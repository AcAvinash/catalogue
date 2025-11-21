# Builder stage
FROM node:20-alpine3.20 AS builder
WORKDIR /opt/server
COPY package.json ./
RUN npm install --registry=https://registry.npmjs.org/
COPY *.js ./

# Final stage
FROM node:20-alpine3.20
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
RUN apk update && apk add --no-cache musl openssl
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
WORKDIR /opt/server
USER roboshop
COPY --from=builder /opt/server /opt/server
EXPOSE 8080
CMD ["node","server.js"]




