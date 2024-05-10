package routes

import (
	"strconv"

	"github.com/expense-tracker/internal/handlers"
	"github.com/expense-tracker/internal/models"
	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func ExpenseRoutes(r *fiber.App, db *gorm.DB) {
	r.Get("/api/expenses", func(c *fiber.Ctx) error {
		return c.JSON(handlers.GetExpenses(db))
	})

	r.Get("/api/expenses/:id", func(c *fiber.Ctx) error {
		id, err := strconv.Atoi(c.Params("id"))
		if err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}
		return c.JSON(handlers.GetExpense(db, id))
	})

	r.Post("/api/expenses", func(c *fiber.Ctx) error {
		expense := new(models.Expense)

		if err := c.BodyParser(expense); err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		err := handlers.CreateExpense(db, expense)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Error creating expense"})
		}

		return c.JSON(fiber.Map{"status": 200, "msg": "Expense created successfully"})
	})

	r.Put("/api/expenses/:id", func(c *fiber.Ctx) error {
		id, err := strconv.Atoi(c.Params("id"))
		if err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		expense := new(models.Expense)

		if err := c.BodyParser(expense); err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		err = handlers.UpdateExpense(db, id, expense)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Error updating expense"})
		}

		return c.JSON(fiber.Map{"status": 200, "msg": "Expense updated successfully"})
	})

	r.Delete("/api/expenses/:id", func(c *fiber.Ctx) error {
		id, err := strconv.Atoi(c.Params("id"))
		if err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		err = handlers.DeleteExpense(db, id)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Error deleting expense"})
		}

		return c.JSON(fiber.Map{"status": 200, "msg": "Expense deleted successfully"})
	})
}
