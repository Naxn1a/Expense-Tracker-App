package server

import (
	"github.com/expense-tracker/internal/routes"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"gorm.io/gorm"
)

func Run(db *gorm.DB) {
	app := fiber.New()

	app.Use(cors.New())

	routes.SetupRoutes(app, db)

	app.Listen(":8080")
}
