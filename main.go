package main

import (
	"log"
	"net/http"

	"github.com/harrydrippin/brusta-go-ainize/server"
)

func main() {
	server := server.NewRouter(routes)
	log.Print("Server is starting on port 80")
	if err := http.ListenAndServe(":80", server); err != nil {
		log.Fatal(err)
	}
}
