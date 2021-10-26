### STAGE 1 ###

# Build the REST API using the official Golang base image
FROM golang:alpine3.13 AS build

# Add Golang specific environment variables for compiling
ENV GOOS=linux GOARCH=amd64

# Enter /api as current working directory
# The commands below will respect this
WORKDIR /api

# Copy the go.mod dependency file to working directory
COPY go.mod ./

# Install and verify the dependencies via Go Modules
RUN go mod download && go mod verify

# Copy rest of the files to working directory
# This is done separately so Docker can use its cache effectively
COPY . .

# Compile the application to a single binary called 'server'
RUN go build -ldflags="-w -s" -o server main.go

### STAGE 2 ###

# Run the REST API using the official Alpine Linux base image
FROM alpine:3.13 AS runtime

WORKDIR /api

# We don't want to run our container as the root user for security reasons
# Therefore, we define a new non-root user and UID for it
# We disable login via password and omit creating a home directory
# to protect us against malicious SSH login attempts
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
# Binary permissions are given to our custom user to make the app runnable
COPY --from=build --chown=${USER}:${USER} /api/server .

# Switch to our new user
USER ${USER}:${USER}

# Define a Healthcheck
# In the application code we have defined a `/` route for checking the container health
# Alpine, by default, does not include `curl` so we use `wget` with
HEALTHCHECK --interval=5s --timeout=5s \
    CMD wget -nv -t1 --spider 'http://localhost:3000' || exit 1

# Expose the given port to outer world
EXPOSE 3000

# Launch the application
# This sets the PID=1 for our application, which means that the container dies in case this application crashes
# Restart policies will help us to keep the container running
CMD ./server
