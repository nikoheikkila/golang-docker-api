package routes

import (
	"fmt"
	"log"
	"net/http"

	"github.com/nikoheikkila/golang-docker-api/app"
)

type Handler = func(writer http.ResponseWriter, request *http.Request)

func Register() {
	log.Print("Initiating request handlers")

	routes := map[string]Handler{
		"/":      home,
		"/users": users,
	}

	for route, handler := range routes {
		http.HandleFunc(route, handler)
	}
}

func home(writer http.ResponseWriter, request *http.Request) {
	fmt.Fprint(writer, "{\"status\": \"OK\" }")
}

func users(writer http.ResponseWriter, request *http.Request) {
	log.Printf("Request from %s querying for users", request.RemoteAddr)

	users, fetchError := app.GetUsers()
	if fetchError != nil {
		log.Fatalf("Error fetching users. Reason: %s", fetchError.Error())
	}

	log.Printf("Sending a response of length %d bytes", len(users))
	fmt.Fprint(writer, users)
}
