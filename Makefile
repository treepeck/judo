include ./config/justchess.env
include ./config/common.env
export

justchess:
	cd repo/justchess && go run -race cmd/justchess/main.go

coordinator:
	cd repo/coordinator && go run -race cmd/coordinator/main.go

justchess-dlv:
	cd repo/justchess && dlv --headless --listen localhost:40000 debug cmd/justchess/main.go

justchess-gdlv:
	gdlv connect localhost:40000

coordinator-dlv:
	cd repo/coordinator && dlv --headless --listen localhost:50000 debug cmd/coordinator/main.go

coordinator-gdlv:
	gdlv connect localhost:50000