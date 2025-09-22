[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)

Judo [Justchess-Docker] provides the easy way to set up a local development<br/>
environment using Docker.

## Quick start

First install the Docker Engine or Desktop (see https://docs.docker.com/engine/install).

Secondly make sure that [docker compose](https://docs.docker.com/reference/cli/docker/compose/)
CLI tool is installed.

Once everyting is ready, clone this repository:

```
git clone https://github.com/treepeck/judo
cd judo
```

Finally, execute bootstrap.sh (works via WSL on Windows) script that will download<br/>
source code from GitHub repos and run docker compose up -d --build.

Changes to Go files require rebuilding the images, while changes to frontend<br/>
files are displayed automatically.

## Services

Justchess project contains the following services:

- `rabbitmq` - exchanges events between the Gatekeeper and Justchess servers.<br/>
  The image provides a Web UI management tool, available on the port 15672.
- `mysql` - a database that stores player's credentials, active sessions and <br/>
  completed games.
- `gatekeeper` - a WebSocker server that accepts and forwards events to the Justchess.
- `justchess` - handles HTTP requests, Gatekeeper's events, and manages game states.
- `frontend` - web ui.

See `docker-compose.yaml` for details about the network ports used by these services.

## Configuration files

`docker-compose.yaml` expects the following configuration files to be located in<br/>
the `config` folder:

- `definitions.json` - defines the RabbitMQ user credentials and the custom<br/>
   virtual host name.
- `rabbitmq.env` - tells the RabbitMQ Docker image to load and use data from `definitions.json`.
- `mysql.env` - defines the MySQL user credentials and database name.
- `gatekeeper.env` - defines the AMQP URL for connecting to RabbitMQ and the URL<br/>
  to which the Gatekeeper sends authorization verification requests.
- `justchess.env` - defines the AMQP URL for connecting to RabbitMQ and the MySQL<br/>
  URL for connecting to the database.
- `frontend` - defines the NODE_ENV.

## Run services

To manually run all services, execute this command in the `judo` folder:  

```
docker compose up -d
```

You might need to prefix the previous command with sudo if you haven’t configured<br/>
the system permissions for the Docker.

## License

Copyright (c) 2025 Artem Bielikov

This project is available under the Mozilla Public License, v. 2.0.<br/>
See the [LICENSE](LICENSE) file for details.