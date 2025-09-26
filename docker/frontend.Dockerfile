FROM node:lts-alpine

WORKDIR /app
COPY ./repo/frontend/package.json ./repo/frontend/pnpm-lock.yaml ./
RUN corepack enable pnpm && pnpm i --frozen-lockfile