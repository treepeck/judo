FROM node:25-alpine

WORKDIR /app

# Install webpack.
COPY ./package.json ./webpack.config.mjs ./
RUN npm install
