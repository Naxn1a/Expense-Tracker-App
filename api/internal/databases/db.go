package databases

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/expense-tracker/configs"
	"github.com/expense-tracker/internal/models"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func Connect(cfg configs.IDbConfig) *gorm.DB {
	logger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags),
		logger.Config{
			SlowThreshold: time.Second,
			LogLevel:      logger.Info,
			Colorful:      true,
		},
	)

	db, err := gorm.Open(postgres.Open(cfg.Url()), &gorm.Config{
		Logger: logger,
	})

	if err != nil {
		panic("Connect to database failed!")
	}

	db.AutoMigrate(&models.User{}, &models.Expense{})
	fmt.Println("Migrated successfully!")
	return db
}
