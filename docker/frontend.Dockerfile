FROM node:lts-alpine

WORKDIR /frontend
COPY ./repo/frontend/package.json ./repo/frontend/pnpm-lock.yaml \
./repo/frontend/tsconfig.json ./repo/frontend/postcss.config.mjs \
./repo/frontend/prettier.config.mts ./repo/frontend/next.config.ts \
/repo/frontend/eslint.config.mjs ./
RUN corepack enable pnpm && pnpm i --frozen-lockfile