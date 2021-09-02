package app

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

const BASE_URL string = "https://jsonplaceholder.typicode.com"

func GetUsers() (string, error) {
	response, httpError := http.Get(BASE_URL + "/users")
	if httpError != nil {
		return "", httpError
	}

	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		return "", fmt.Errorf("request to %s failed with status %d", BASE_URL, response.StatusCode)
	}

	body, readError := ioutil.ReadAll(response.Body)
	if readError != nil {
		return "", readError
	}

	return string(body[:]), nil
}
