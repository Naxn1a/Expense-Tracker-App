package routes

import (
	"github.com/expense-tracker/internal/handlers"
	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func ExpenseRoutes(r *fiber.App, db *gorm.DB) {
	r.Get("/api/expenses", func(c *fiber.Ctx) error {
		return handlers.GetExpenses(db, c)
	})

	r.Get("/api/expenses/:id", func(c *fiber.Ctx) error {
		return handlers.GetExpense(db, c)
	})

	r.Post("/api/expenses", func(c *fiber.Ctx) error {
		return handlers.CreateExpense(db, c)
	})

	r.Put("/api/expenses/:id", func(c *fiber.Ctx) error {
		return handlers.UpdateExpense(db, c)
	})

	r.Delete("/api/expenses/:id", func(c *fiber.Ctx) error {
		return handlers.DeleteExpense(db, c)
	})
}
