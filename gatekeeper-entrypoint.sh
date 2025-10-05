#!/usr/bin/env sh

# sh is used instead of bash since the Go-alpine image does not come with bash.

set -euo pipefail

dev() {
	cd /app/src
	sh -c 'go build -ldflags="-s -w" -o /app/bin/gatekeeper /app/src/cmd/gatekeeper/main.go && /app/bin/gatekeeper'
}

debug() {
	cd /app/src
	sh -c 'go build -gcflags="all=-N -l" -o /app/bin/gatekeeper /app/src/cmd/gatekeeper/main.go && dlv exec /app/bin/gatekeeper --headless --listen=:2346 --api-version=2 --accept-multiclient'
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