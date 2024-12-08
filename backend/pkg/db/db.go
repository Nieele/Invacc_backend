package db

import (
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var conn *gorm.DB

func ConnectDB() error {
	connStr := os.Getenv("POSTGRES_CON_STR")
	var err error
	conn, err = gorm.Open(postgres.Open(connStr), &gorm.Config{})

	if err != nil || conn == nil {
		log.Fatalf("Unable to connect to database: %v", err)
		panic("Unable to connect to database") // TODO: replace to error
		// return err
	}

	return nil
}

func GetDBConnection() (*gorm.DB, error) {
	if conn == nil {
		ConnectDB()
	}
	return conn, nil
}
