package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func (w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "Welcome to!")
	})

	fmt.Println("Starting....")
	_ = http.ListenAndServe(":80", nil)
}