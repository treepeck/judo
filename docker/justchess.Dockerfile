FROM golang:1.26.1-alpine

RUN apk add --no-cache gcc musl-dev

WORKDIR /app/src

# Install dependencies.
COPY repo/justchess/go.mod repo/justchess/go.sum ./
RUN go mod download

# Install migration tool.
RUN go install -tags 'mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest