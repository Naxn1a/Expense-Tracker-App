package handlers

import (
	"strconv"

	"github.com/expense-tracker/internal/models"
	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func GetExpenses(db *gorm.DB, c *fiber.Ctx) error {
	var expenses []models.Expense

	result := db.Find(&expenses)

	if result.Error != nil {
		return c.SendStatus(fiber.StatusInternalServerError)
	}

	return c.JSON(expenses)
}

func GetExpense(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	var expense models.Expense

	result := db.First(&expense, id)

	if result.Error != nil {
		return c.SendStatus(fiber.StatusNotFound)
	}

	return c.JSON(expense)
}

func CreateExpense(db *gorm.DB, c *fiber.Ctx) error {
	expense := new(models.Expense)

	if err := c.BodyParser(expense); err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	result := db.Create(expense)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Error creating expense"})
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "Expense created successfully"})
}

func UpdateExpense(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	expense := new(models.Expense)

	if err := c.BodyParser(expense); err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	result := db.Model(&models.Expense{}).Where("id = ?", id).Updates(expense)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Error updating expense"})
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "Expense updated successfully"})
}

func DeleteExpense(db *gorm.DB, c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))

	if err != nil {
		return c.SendStatus(fiber.StatusBadRequest)
	}

	result := db.Delete(&models.Expense{}, id)

	if result.Error != nil {
		return c.JSON(fiber.Map{"status": 400, "msg": "Error deleting expense"})
	}

	return c.JSON(fiber.Map{"status": 200, "msg": "Expense deleted successfully"})
}
