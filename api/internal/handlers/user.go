package handlers

import (
	"os"
	"strconv"

	"github.com/expense-tracker/internal/models"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func Authen(db *gorm.DB, c *fiber.Ctx) error {
	jwtToken := c.Params("token")
	secretKey := os.Getenv("JWT_SECRET_KEY")

	token, err := jwt.ParseWithClaims(jwtToken, jwt.MapClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})

	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	claim := token.Claims.(jwt.MapClaims)

	return c.JSON(fiber.Map{"status": 200, "data": claim})
}

func GetUsers(db *gorm.DB, c *fiber.Ctx) error {
	var users []models.User

	err := db.Model(&models.User{}).Preload("Expense").Find(&users).Error

	if err != nil {
		return c.SendStatus(fiber.StatusInternalServerError)
	}

	return c.JSON(users)
}

func GetUser(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	var user models.User

	result := db.First(&user, id)

	if result.Error != nil {
		return c.SendStatus(fiber.StatusNotFound)
	}

	return c.JSON(user)
}

func SignUpUser(db *gorm.DB, c *fiber.Ctx) error {
	user := new(models.User)

	if err := c.BodyParser(user); err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	hashPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)

	if err != nil {
		return c.SendStatus(fiber.StatusInternalServerError)
	}

	user.Password = string(hashPassword)

	result := db.Create(user)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "User already exists"})
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "User created successfully"})
}

func SignInUser(db *gorm.DB, c *fiber.Ctx) error {
	user := new(models.User)
	newUser := new(models.User)

	if err := c.BodyParser(user); err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	result := db.Where("username = ?", user.Username).First(newUser)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "User not found"})
	}

	err := bcrypt.CompareHashAndPassword([]byte(newUser.Password), []byte(user.Password))

	if err != nil {
		return c.SendStatus(fiber.StatusUnauthorized)
	}

	secretKey := os.Getenv("JWT_SECRET_KEY")
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id"] = newUser.ID

	t, err := token.SignedString([]byte(secretKey))

	if err != nil {
		return c.SendStatus(fiber.StatusInternalServerError)
	}

	return c.JSON(fiber.Map{"status": 200, "token": t})
}

func UpdateUser(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	user := new(models.User)

	if err := c.BodyParser(user); err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	result := db.Model(&models.User{}).Where("id = ?", id).Updates(user)

	if result.Error != nil {
		return c.SendStatus(fiber.StatusInternalServerError)
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "User updated successfully"})
}

func DeleteUser(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	result := db.Delete(&models.User{}, id)

	if result.Error != nil {
		return c.SendStatus(fiber.StatusInternalServerError)
	}

	return c.SendStatus(fiber.StatusOK)
}
