FROM node:24-alpine
WORKDIR /app

# Install dependencies.
COPY repo/frontend/package*.json .
RUN npm install