FROM mysql:latest
WORKDIR /docker-entrypoint-initdb.d

COPY db/schema.sql .