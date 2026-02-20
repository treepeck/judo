FROM golang:1.24.6-alpine
WORKDIR /app/src

# Install dependencies.
COPY repo/justchess/go.mod repo/justchess/go.sum ./
RUN go mod download

# Install migration tool.
RUN go install -tags 'mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest