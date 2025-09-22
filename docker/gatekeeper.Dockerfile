# This is a multi-stage build of the Gatekeeper server.  In the first stage,
# we use the Golang Alpine image to compile the Go application.  Then, in the
# second stage, we copy only the final binary into a lightweight base image.

# First stage.
FROM golang:1.24.4-alpine AS builder
WORKDIR /app

# Install dependencies.
COPY repo/gatekeeper/go.mod repo/gatekeeper/go.sum ./
RUN go mod download

# Copy the source code files.
COPY repo/gatekeeper/ .
# Ebables running the binary in the scratch image.
ENV CGO_ENABLED=0
# Build the source code.  ldflags is an optimization to reduce the binary size.
RUN go build -ldflags="-s -w" -o gatekeeper ./cmd/gatekeeper/main.go

# Second stage.
FROM scratch
WORKDIR /app
# Copy the binary.
COPY --from=builder /app/gatekeeper .
# Run the program.
CMD ["./gatekeeper"]