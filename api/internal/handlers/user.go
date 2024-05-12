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

type Token struct {
	Token string `json:"token"`
}

func Authen(db *gorm.DB, c *fiber.Ctx) error {
	secretKey := os.Getenv("JWT_SECRET_KEY")
	req := new(Token)

	if err := c.BodyParser(req); err != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid request"})
	}

	token, err := jwt.ParseWithClaims(req.Token, jwt.MapClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})

	if err != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "Invalid token"})
	}

	claim := token.Claims.(jwt.MapClaims)

	return c.JSON(fiber.Map{"status": 200, "data": claim})
}

func GetUsers(db *gorm.DB, c *fiber.Ctx) error {
	var users []models.User

	err := db.Model(&models.User{}).Preload("Expense").Find(&users).Error

	if err != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "Failed to fetch users"})
	}

	return c.JSON(users)
}

func GetUser(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid user id"})
	}

	var user models.User

	err = db.Model(&models.User{}).Preload("Expense").First(&user, id).Error

	if err != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "User not found"})
	}

	var total = 0.0
	var income = 0.0
	var expense = 0.0

	err = db.Model(&models.Expense{}).Where("user_id = ?", id).Select("sum(amount)").Row().Scan(&total)

	if err != nil {
		total = 0.0
	}

	err = db.Model(&models.Expense{}).Where("user_id = ? AND type = ?", id, "income").Select("sum(amount)").Row().Scan(&income)

	if err != nil {
		income = 0.0
	}

	err = db.Model(&models.Expense{}).Where("user_id = ? AND type = ?", id, "expense").Select("sum(amount)").Row().Scan(&expense)

	if err != nil {
		expense = 0.0
	}

	return c.JSON(fiber.Map{"status": 200, "data": user, "total": total, "income": income, "expense": expense})
}

func SignUpUser(db *gorm.DB, c *fiber.Ctx) error {
	user := new(models.User)

	if err := c.BodyParser(user); err != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid request"})
	}

	hashPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)

	if err != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "Failed to hash password"})
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
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid request"})
	}

	result := db.Where("username = ?", user.Username).First(newUser)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "User not found"})
	}

	err := bcrypt.CompareHashAndPassword([]byte(newUser.Password), []byte(user.Password))

	if err != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "Invalid password"})
	}

	secretKey := os.Getenv("JWT_SECRET_KEY")
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id"] = newUser.ID

	t, err := token.SignedString([]byte(secretKey))

	if err != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "Failed to generate token"})
	}

	return c.JSON(fiber.Map{"status": 200, "token": t})
}

func UpdateUser(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid user id"})
	}

	user := new(models.User)

	if err := c.BodyParser(user); err != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid request"})
	}

	result := db.Model(&models.User{}).Where("id = ?", id).Updates(user)

	if result.Error != nil {
		// return c.JSON(fiber.Map{"status": 500, "msg": "Failed to update user"})
		return c.JSON(fiber.Map{"status": 500, "msg": "Username already exists"})
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "User updated successfully"})
}

func DeleteUser(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Invalid user id"})
	}

	result := db.Delete(&models.User{}, id)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 500, "msg": "Failed to delete user"})
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "User deleted successfully"})
}
