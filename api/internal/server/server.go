package server

import (
	"github.com/expense-tracker/internal/routes"
	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func Run(db *gorm.DB) {
	app := fiber.New()

	routes.SetupRoutes(app, db)

	app.Listen(":8080")
}
