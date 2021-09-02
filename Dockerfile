# Stage 1: Build the REST API
FROM golang:alpine3.13 AS build

# Add Golang specific environment variables
ENV GOOS=linux GOARCH=amd64

# Enter /api as current working directory
WORKDIR /api

# Install dependencies via Go Modules
COPY go.mod ./
RUN go mod download && go mod verify

# Compile the application to a single binary 'api'
COPY . .
RUN go build -ldflags="-w -s" -o api main.go

# Stage 2: Run the REST API
FROM alpine:3.13 AS runtime

WORKDIR /api

# Define a new user and ID for it
ENV USER=apiuser UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

# Copy the compiled binary from 'build' stage
COPY --from=build --chown=${USER}:${USER} /api/ .

# Switch to our non-privileged user
USER ${USER}:${USER}

# Define a Healthcheck
HEALTHCHECK --interval=5s --timeout=5s \
    CMD wget -nv -t1 --spider 'http://localhost:3000' || exit 1

# Expose the given port
EXPOSE 3000

# Launch the application
CMD ./api
