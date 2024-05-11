package routes

import (
	"github.com/expense-tracker/internal/handlers"
	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func UserRoutes(r *fiber.App, db *gorm.DB) {
	r.Get("/api/auth", func(c *fiber.Ctx) error {
		return handlers.Authen(db, c)
	})

	r.Get("/api/users", func(c *fiber.Ctx) error {
		return handlers.GetUsers(db, c)
	})

	r.Get("/api/users/:id", func(c *fiber.Ctx) error {
		return handlers.GetUser(db, c)
	})

	r.Post("/api/users/signup", func(c *fiber.Ctx) error {
		return handlers.SignUpUser(db, c)
	})

	r.Post("/api/users/signin", func(c *fiber.Ctx) error {
		return handlers.SignInUser(db, c)
	})

	r.Put("/api/users/:id", func(c *fiber.Ctx) error {
		return handlers.UpdateUser(db, c)
	})

	r.Delete("/api/users/:id", func(c *fiber.Ctx) error {
		return handlers.DeleteUser(db, c)
	})
}
