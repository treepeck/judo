#!/usr/bin/env bash

set -euo pipefail

# start runs the local development services.
start() {
    echo "Starting services..."
	docker compose up -d rabbitmq mysql frontend

	echo "Restarting backend services in dev mode..."
	docker compose stop gatekeeper justchess
	PROFILE=dev docker compose up -d gatekeeper justchess

    echo "Services started successfully"
}

# stop stops the running services.
stop() {
    echo "Stopping services..."
    docker compose stop
    echo "Services stopped successfully"
}

# remove cleans all resources, allocated by the judo services.
remove() {
    echo "Removing services..."

    # Remove containers and mounted volumes.
    docker rm -fv gatekeeper
    docker rm -fv justchess
    docker rm -fv frontend
    docker rm mysql
    docker rm rabbitmq
	docker rm testdb && true # This service may not be present, so skip errors.
    # Remove images.
    docker rmi judo-gatekeeper
    docker rmi judo-justchess
    docker rmi judo-frontend
    docker rmi judo-mysql
    docker rmi rabbitmq:4.2-management-alpine
	docker rmi judo-testdb && true
    # Remove volume.
    docker volume rm judo_mysql_data
    # Remove network.
    docker network rm judo_default

    echo "Services removed successfully"
}

# test starts the testdb service and runs tests for the justchess backend
# service.
test() {
	echo "Creating a disposable database..."
	docker compose up -d --wait testdb

	echo "Running tests..."
	docker exec -it justchess sh -c "cd /app/src && go test ./... -v -cover -bench=. -benchmem" && true

	echo "Shutting down the database..."
	docker compose stop testdb
	docker rm -fv testdb

	echo "Testing process finished"
}

# download clones repositories to the repo folder if they are missing.  If they
# aren't, download will try to pull the latest changes from the GitHub.
download() {
    # Split strings by whitespace.
    IFS=' '

    REPOS=(
        "https://github.com/treepeck/gatekeeper gatekeeper"
        "https://github.com/treepeck/justchess justchess"
        "https://github.com/treepeck/justchess-frontend frontend"
    )

    if [ ! -d "./repo" ]; then
        mkdir repo
    fi

    echo "Downloading source code from repositories..."

    for repo in "${REPOS[@]}"; do
        # split[0] is the repo url, split[1] is the folder name.
        split=($repo)
        repopath="./repo/${split[1]}"

        if [ -d "$repopath" ]; then
            (
                cd $repopath
                git pull origin dev
            )
        else
            mkdir $repopath
            git clone -b dev ${split[0]} $repopath
        fi
    done

    echo "Source code downloaded successfully"
}

# restart stops the service with the specified name and starts it again.
restart() {
	echo "Restarting service $1..."

	docker compose stop $1
	docker compose up -d $1

	echo "Restarting process finished"
}

help() {
    echo "Usage: $0 <action>"

    echo "Available actions:"
    echo "    start              Start the local development services"
    echo "    stop               Stop all running services"
    echo "    remove             Remove all services and cleanup their data"
	echo "    test               Run tests for the backend services. Note that justchess service must be up and running"
    echo "    download           Download latest changes from the source code repositories"
	echo "    restart <service>  Stop the specified service and start it again"
    echo "    help               Print this message"
}

# Parse flag.
action="${1:-help}"
service="${2:-justchess}"

case "$action" in
    start) start ;;
    stop) stop ;;
    remove) remove ;;
	test) test ;;
    download) download ;;
	restart)
		restart "$service" ;;
    *) help ;;
esac