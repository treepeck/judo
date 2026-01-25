FROM mysql:latest
WORKDIR /docker-entrypoint-initdb.d

COPY data/seed.sql .