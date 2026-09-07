FROM golang:1.26.4-alpine

RUN apk add --no-cache gcc musl-dev bash

WORKDIR /app/src

# Install dependencies.
COPY repo/coordinator/go.mod repo/coordinator/go.sum ./
RUN go mod download
