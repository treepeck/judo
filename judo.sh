#!/usr/bin/env bash

set -euo pipefail

# Declaration of help messages.
actionHelp="Usage: $0 <action>
Available actions:
    start                            Start services
    stop                             Stop services
    remove                           Remove services and delete their data
    test                             Run tests and benchmarks. Note that justchess service must be up and running
    download                         Pull latest changes from the source code repositories
    rebuild   <service>              Rebuild and restart the specified service
    migration <option>  <filename>   Manage db migrations"
serviceHelp="Available services:
    justchess                        HTTP and WebSocker server
	db                               Primary MySQL database
	testdb                           Disposable MySQL database to run tests
	webpack                          JS and CSS bundler"
optionHelp="Available options:
	create                           Create a new SQL migration file
	up                               Apply all up migrations
	down                             Applies the last down migration"


# start runs the local development services.
start() {
    echo "Starting services..."
	docker compose up -d db webpack justchess
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
    echo "Removing containers..."
    docker rm -fv justchess
	docker rm webpack
    docker rm db
	docker rm testdb && true # This container may not be present, so skip errors.

	echo "Removing images..."
    docker rmi judo-justchess
	docker rmi judo-webpack
    docker rmi mysql:latest

    echo "Removing database volume..."
    docker volume rm judo_db_data

	echo "Removing judo network..."
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
        "https://github.com/treepeck/justchess justchess"
		"https://github.com/treepeck/chego chego"
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
                git pull origin
            )
        else
            mkdir $repopath
            git clone ${split[0]} $repopath
        fi
    done

    echo "Source code downloaded successfully"
}

# rebuild rebuilds the image of the specified service and starts it.
rebuild() {
	echo "Rebuilding service $1..."
	docker compose up --build --force-recreate --no-deps -d $1
	echo "Rebuilding process finished"
}

# migration manages database migrations.
migration() {
	case "$1" in
		create)
			docker exec justchess migrate create -ext sql -dir /app/migrations "$2"
			# Set file owner to host OS user since user in docker is root and
		    # that makes migration file impossible to modify outside the justchess
			# container.
			docker exec justchess chown -R "$(id -u)":"$(id -g)" /app/migrations
			;;
		up)
			docker exec justchess sh -c 'migrate -database "mysql://${DB_DSN}" -path /app/migrations up'
			;;
		down)
			docker exec justchess sh -c 'migrate -database "mysql://${DB_DSN}" -path /app/migrations down 1'
			;;
		*) echo "$optionHelp" ;;
	esac
}

# Parse arguments.
action="${1:-}"
service="${2:-}"
option="${2:-}"
filename="${3:-}"

case "$action" in
    start) start ;;
    stop) stop ;;
    remove) remove ;;
	test) test ;;
    download) download ;;
	rebuild)
		rebuild "$service" ;;
	migration)
		migration "$option" "$filename" ;;
    *) echo "$actionHelp" ;;
esac