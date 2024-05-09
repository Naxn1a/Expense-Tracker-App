package routes

import (
	"strconv"

	"github.com/expense-tracker/internal/handlers"
	"github.com/expense-tracker/internal/models"
	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func SetupRoutes(r *fiber.App, db *gorm.DB) {
	r.Get("/api/users", func(c *fiber.Ctx) error {
		return c.JSON(handlers.GetUsers(db))
	})

	r.Get("/api/users/:id", func(c *fiber.Ctx) error {
		id, err := strconv.Atoi(c.Params("id"))
		if err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}
		return c.JSON(handlers.GetUser(db, id))
	})

	r.Post("/api/users/signup", func(c *fiber.Ctx) error {
		user := new(models.User)

		if err := c.BodyParser(user); err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		err := handlers.SignUpUser(db, user)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Username already exists"})
		}

		return c.JSON(fiber.Map{"status": 200})
	})

	r.Post("/api/users/signin", func(c *fiber.Ctx) error {
		user := new(models.User)

		if err := c.BodyParser(user); err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		token, err := handlers.SignInUser(db, user)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Invalid username or password"})
		}

		return c.JSON(fiber.Map{"status": 200, "token": token})
	})

	r.Put("/api/users/:id", func(c *fiber.Ctx) error {
		id, err := strconv.Atoi(c.Params("id"))
		if err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		user := new(models.User)

		if err := c.BodyParser(user); err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		err = handlers.UpdateUser(db, id, user)

		if err != nil {
			return c.SendStatus(fiber.StatusInternalServerError)
		}

		return c.SendStatus(fiber.StatusOK)
	})

	r.Delete("/api/users/:id", func(c *fiber.Ctx) error {
		id, err := strconv.Atoi(c.Params("id"))
		if err != nil {
			return c.SendStatus(fiber.StatusBadRequest)
		}

		err = handlers.DeleteUser(db, id)

		if err != nil {
			return c.SendStatus(fiber.StatusInternalServerError)
		}

		return c.SendStatus(fiber.StatusOK)
	})
}
