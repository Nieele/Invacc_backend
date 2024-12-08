package main

import (
	"log"

	"github.com/joho/godotenv"
)

func main() {
	loadEnvFile()
}

func loadEnvFile() {
	if err := godotenv.Load(".env"); err != nil {
		log.Fatal("Error loading .env file")
		panic("Error loading .env file")
	}
}
