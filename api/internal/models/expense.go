package models

import (
	"time"

	"gorm.io/gorm"
)

type Expense struct {
	gorm.Model
	List   string    `json:"name"`
	Amount float64   `json:"amount"`
	Date   time.Time `json:"date"`
	UserId uint      `json:"user_id"`
}
