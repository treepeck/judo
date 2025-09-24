FROM golang:1.24.4-alpine
WORKDIR /app

# Install the Delve debugger.
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Install dependencies.
COPY repo/justchess/go.mod repo/justchess/go.sum ./
RUN go mod download

# Copy the source code files.
COPY repo/justchess/ .
ENV CGO_ENABLED=0
# Build the source code.  gcflags disables optimization to improve the debugging
# experience.
RUN go build -gcflags="all=-N -l" -o justchess ./cmd/justchess/main.go

# Run the debugger
CMD ["dlv", "exec", "justchess", "--headless", "--listen=:2345", "--api-version=2", "--accept-multiclient"]