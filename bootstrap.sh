#!/bin/bash

# This script will clone repositories into the repo folder, if they are missing.
# If they aren't, it will try to pull the latest changes from the GitHub.

set -euo pipefail

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

echo "Fetching source code from repositories..."

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

echo "Repositories fetched successfully."
echo "Starting all services..."
docker compose up -d --build
echo "Services started successfully."