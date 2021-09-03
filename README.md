# Golang REST API + Docker Example 🐭🐳📦

This is a brief example project showing how to package a REST API application as a Docker image running a static binary.

## Usage

Build the image and launch a container.

```sh
docker-compose up --build -d
docker-compose logs -f
```

Then hit it with requests using your favourite tool and follow the log output.

```sh
http :3000 | jq
```
