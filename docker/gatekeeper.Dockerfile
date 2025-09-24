FROM golang:1.24.4-alpine
WORKDIR /app

# Install the Delve debugger.
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Install dependencies.
COPY repo/gatekeeper/go.mod repo/gatekeeper/go.sum ./
RUN go mod download

# Copy the source code files.
COPY repo/gatekeeper/ .
ENV CGO_ENABLED=0
# Build the source code.  gcflags disables optimization to improve the debugging
# experience.
RUN go build -gcflags="all=-N -l" -o gatekeeper ./cmd/gatekeeper/main.go

# Run the debugger
CMD ["dlv", "exec", "gatekeeper", "--headless", "--listen=:2346", "--api-version=2", "--accept-multiclient"]