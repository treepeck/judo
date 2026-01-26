FROM node:25-alpine

WORKDIR /app

# Install webpack.
COPY ./package.json ./config/webpack.config.mjs ./
RUN npm install
