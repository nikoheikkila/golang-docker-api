.PHONY: build

build:
	go build -o ./build/app main.go

start:
	go run main.go

format:
	go fmt ./...

test:
	go test -v ./...

docker-test:
	bash tests/test.sh
