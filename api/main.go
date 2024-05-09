package main

import (
	"log"
	"os"

	"github.com/expense-tracker/configs"
	"github.com/expense-tracker/internal/databases"
	"github.com/expense-tracker/internal/server"
)

func main() {
	cfg := configs.LoadConfigs(func() string {
		if len(os.Args) < 2 {
			log.Fatal("Please provide a path to the .env file") // go run main.go .env
		}
		return os.Args[1]
	}())

	db := databases.Connect(cfg.Db())

	server.Run(db)
}
