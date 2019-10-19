package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/ping", func(responseWriter http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(responseWriter, "Welcome to ping service but not is a ping pong")
	})

	fmt.Println("Starting....")
	_ = http.ListenAndServe(":80", nil)
}