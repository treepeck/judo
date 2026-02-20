[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)

Judo [JustChess-Docker] is a local development environment for [justchess.org](https://justchess.org)

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

- `db` - MySQL database that stores player's credentials, active sessions and<br/>
  completed games.
- `testdb` - disposable database that provides an isolated layer for running<br/>
  tests.
- `justchess` - HTTP and WebSocket server, written in Go.
- `webpack` - JS and CSS bundler.

See `docker-compose.yaml` for details about the network ports used by these services.

## Configuration files

`docker-compose.yaml` expects the following configuration files to be located in<br/>
the `config` folder:

- `db.env` - defines the MySQL user credentials and database name.
- `db.conf` - enables the MySQL event scheduler to clean up expired sessions.
- `testdb.env` - defines the MySQL user credentials and database name for testdb.
- `justchess.env` - defines the URL for connecting to the database.

## Run services

To run all services, execute this command in the `judo` folder:

```
./judo.sh start
```

You might need to prefix this command with sudo if you haven’t configured<br/>
the system permissions for the Docker engine.

## Display changes

Changes to Go files and templates requires rebuilding `justchess` service, while<br/>
changes to scripts and css are displayed automatically.

To restart the service, execute this command:

```
./judo.sh restart <service>
```

## Migrations

`justchess` container includes the `golang-migrate` CLI tool to perform <br/>
migration-based schema updates.  Once the `justchess` service is started<br/>
run `./judo.sh migration up` to apply all `*.up.sql` migrations files<br/>
under the `migrations` folder.

For more details see [judo.sh](./judo.sh).

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

Copyright (c) 2025 Artem Bielikov

This project is available under the Mozilla Public License, v. 2.0.<br/>
See the [LICENSE](LICENSE) file for details.
