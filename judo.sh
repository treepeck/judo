#!/usr/bin/env bash

set -euo pipefail

# start runs the local development services.
start() {
    echo "Starting services..."
    docker compose up -d rabbitmq mysql gatekeeper justchess frontend
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
    docker rm -v gatekeeper
    docker rm -v justchess
    docker rm -v frontend
    docker rm mysql
    docker rm rabbitmq
    # Remove images.
    docker rmi judo-gatekeeper
    docker rmi judo-justchess
    docker rmi judo-frontend
    docker rmi judo-mysql
    docker rmi rabbitmq:4.1.4-management-alpine
    # Remove volume.
    docker volume rm judo_mysql_data
    # Remove network.
    docker network rm judo_default

    echo "Services removed successfully"
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
                cd ./repo/${split[1]}
                git pull origin dev
            )
        else
            mkdir repo/${split[1]}
            git clone ${split[0]} ./repo/${split[1]}
        fi
    done

    echo "Source code downloaded successfully"
}

help() {
    echo "Usage: $0 <action>"

    echo "Available actions:"
    echo "    start         Start services"
    echo "    stop          Stop services"
    echo "    remove        Stop services and delete all data"
    echo "    download      Download latests changes in the source code repositories"
    echo "    help          Print this message"
}

# Parse flag.
action="${1:-help}"

case "$action" in
    start) start ;;
    stop) stop ;;
    remove) remove ;;
    test) test ;;
    download) download ;;
    *) help ;;
esac