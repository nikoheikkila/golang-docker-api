# Golang REST API + Docker Example 🐭🐳📦

This is a brief example project showing how to package a REST API application as a Docker image running a static binary.

## Usage

### Docker Compose

Build the image and launch a container.

```sh
docker-compose up --build -d
docker-compose logs -f
```

Then hit it with requests using your favourite tool and follow the log output.

```sh
curl -x GET http://localhost:3000/users | jq
```

### GitHub Codespaces

1. Open this repository in [github.com](https://github.com/nikoheikkila/golang-docker-api)
2. Press <kbd>.</kbd> to launch the GitHub web editor
3. From the bottom-left corner, choose _Continue working on_ and choose _Create New Codespace_
4. Wait for the build to finish, and run `go run main.go` to start the server inside the running container

### VS Code Dev Container

1. Open the repository in VS Code
2. From the remote containers menu in the bottom-left corner, choose _Reopen in container_
3. Repeat step #4 from above
