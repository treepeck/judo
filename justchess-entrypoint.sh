#!/usr/bin/env sh

# sh is used instead of bash since the Go-alpine image does not come with bash.

set -euo pipefail

dev() {
	cd /app/src
	sh -c 'go build -ldflags="-s -w" -o /app/bin/justchess /app/src/cmd/justchess/main.go && /app/bin/justchess'
}

debug() {
	cd /app/src
	sh -c 'go build -gcflags="all=-N -l" -o /app/bin/justchess /app/src/cmd/justchess/main.go && dlv exec /app/bin/justchess --headless --listen=:2345 --api-version=2 --accept-multiclient'
}

PROFILE="${PROFILE:-dev}"

case "$PROFILE" in
	dev) dev ;;
	debug) debug ;;
	*)
		echo "Unknown PROFILE: $PROFILE"
		exit 1
		;;
esac