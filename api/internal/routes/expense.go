package routes

import (
	"log"

	"github.com/expense-tracker/internal/models"
	"gorm.io/gorm"
)

func GetExpenses(db *gorm.DB) []models.Expense {
	var expenses []models.Expense
	result := db.Find(&expenses)

	if result.Error != nil {
		log.Fatalf("Error fetching expenses: %v", result.Error)
	}

	return expenses
}

func GetExpense(db *gorm.DB, id int) models.Expense {
	var expense models.Expense
	result := db.First(&expense, id)

	if result.Error != nil {
		log.Fatalf("Error fetching expense: %v", result.Error)
	}

	return expense
}

func CreateExpense(db *gorm.DB, expense *models.Expense) error {
	result := db.Create(expense)

	if result.Error != nil {
		return result.Error
	}

	return nil
}

func UpdateExpense(db *gorm.DB, id int, expense *models.Expense) error {
	result := db.Model(&models.Expense{}).Where("id = ?", id).Updates(expense)

	if result.Error != nil {
		return result.Error
	}

	return nil
}

func DeleteExpense(db *gorm.DB, id int) error {
	result := db.Delete(&models.Expense{}, id)

	if result.Error != nil {
		return result.Error
	}

	return nil
}
