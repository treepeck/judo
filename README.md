[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)

Judo [Justchess-Docker] provides the easy way to set up a local development<br/>
environment using Docker.

## Local installation

First install the Docker Engine or Desktop (see https://docs.docker.com/engine/install).

Secondly make sure that [docker compose](https://docs.docker.com/reference/cli/docker/compose/)
CLI tool is installed.

Once everything is ready, clone this repository:

```
git clone https://github.com/treepeck/judo
cd judo
```

Finally, execute `./judo.sh download` (works via WSL on Windows) script that<br/>
will download the source code from GitHub repos.

## Services

The JustChess project consists of the following services:

- `rabbitmq` - exchanges events between the Gatekeeper and Justchess servers.<br/>
  The image provides a Web UI management tool, available on the port 15672.
- `mysql` - a database that stores player's credentials, active sessions and <br/>
  completed games.
- `testdb` - a disposable database that provides an isolated layer for running<br/>
  tests.
- `gatekeeper` - a WebSocket server that accepts and forwards events to the Justchess.
- `justchess` - handles HTTP requests, Gatekeeper's events, and manages game states.

See `docker-compose.yaml` for details about the network ports used by these services.

## Configuration files

`docker-compose.yaml` expects the following configuration files to be located in<br/>
the `config` folder:

- `definitions.json` - defines the RabbitMQ user credentials, custom virtual<br/>
  host, exchange, queues, and bindings.
- `rabbit_mq.conf` - defines the RabbitMQ user credentials and tells the docker<br/>
  image to load and use data from `definitions.json`.
- `mysql.env` - defines the MySQL user credentials and database name.
- `mysql.conf` - enables the MySQL event scheduler to clean up expired sessions.
- `testdb.env` - defines the MySQL user credentials and database name for testdb.
- `gatekeeper.env` - defines the AMQP URL for connecting to RabbitMQ and the URL<br/>
  to which the Gatekeeper sends authorization verification requests.
- `justchess.env` - defines the AMQP URL for connecting to RabbitMQ and the MySQL<br/>
  URL for connecting to the database.

## Run services

To run all services, execute this command in the `judo` folder:

```
./judo.sh start
```

You might need to prefix this command with sudo if you haven’t configured<br/>
the system permissions for the Docker.

## Display changes

Changes to Go files require service restart, while changes to frontend files are<br/>
displayed automatically.

To restart the service, execute this command:

```
./judo.sh restart <service>
```

## Run tests and benchmarks

To create a disposable MySQL database and run all tests, start the `justchess`<br/>
service and execute this command:

```
./judo.sh test
```

## Clean resources

The following commands will delete all resources, allocated by `judo` services:

```
./judo.sh stop
./juso.sh remove
```

You can also run `docker system prune` to clean the image build cache.

## License

Copyright (c) 2025 The JustChess Authors.

This project is available under the Mozilla Public License, v. 2.0.<br/>
See the [LICENSE](LICENSE) file for details.