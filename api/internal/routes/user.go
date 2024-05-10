package routes

import (
	"strconv"

	"github.com/expense-tracker/internal/handlers"
	"github.com/expense-tracker/internal/models"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"gorm.io/gorm"
)

func UserRoutes(r *fiber.App, db *gorm.DB) {
	r.Get("/api/auth/:token", func(c *fiber.Ctx) error {
		jwtToken := c.Params("token")

		token, err := handlers.Authen(db, jwtToken)

		if err != nil || !token.Valid {
			return c.SendStatus(fiber.StatusUnauthorized)
		}

		claim := token.Claims.(jwt.MapClaims)

		return c.JSON(fiber.Map{"status": 200, "data": claim})
	})

	r.Get("/api/users", func(c *fiber.Ctx) error {
		return c.JSON(handlers.GetUsers(db))
	})

	r.Get("/api/users/:username", func(c *fiber.Ctx) error {
		username := c.Params("username")

		return c.JSON(handlers.GetUser(db, username))
	})

	r.Post("/api/users/signup", func(c *fiber.Ctx) error {
		user := new(models.User)

		err := handlers.SignUpUser(db, user)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Username already exists"})
		}

		return c.JSON(fiber.Map{"status": 200, "msg": "User created successfully"})
	})

	r.Post("/api/users/signin", func(c *fiber.Ctx) error {
		user := new(models.User)

		token, err := handlers.SignInUser(db, user)

		if err != nil {
			return c.JSON(fiber.Map{"status": 400, "msg": "Invalid username or password"})
		}

		c.Cookie(&fiber.Cookie{
			Name:  "token",
			Value: token,
		})

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
