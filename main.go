package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/nikoheikkila/golang-docker-api/routes"
)

func main() {
	port := env("PORT", "3000")
	handler(fmt.Sprintf(":%s", port))
}

func env(key string, fallback string) string {
	value := os.Getenv(key)

	if value != "" {
		return value
	}

	return fallback
}

func handler(address string) error {
	routes.Register()

	log.Printf("Server listening on http://localhost%s", address)
	err := http.ListenAndServe(address, nil)
	if err != nil {
		return err
	}

	return nil
}
