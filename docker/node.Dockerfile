FROM node:26-alpine3.23

WORKDIR /app

COPY ../prettier.config.js ../eslint.config.js ../package.json .

RUN npm install
