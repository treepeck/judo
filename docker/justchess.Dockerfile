FROM golang:1.24.4-alpine
WORKDIR /app/src

# Install dependencies.
COPY repo/justchess/go.mod repo/justchess/go.sum ./
RUN go mod download

# Install the Delve debugger.
RUN go install github.com/go-delve/delve/cmd/dlv@latest