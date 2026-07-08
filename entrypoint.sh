#!/usr/bin/env bash

migrate -database "${DB_DSN}" -path /app/migrations up
go run -race cmd/justchess/main.go