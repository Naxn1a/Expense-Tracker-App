package models

import (
	"time"

	"gorm.io/gorm"
)

type Expense struct {
	gorm.Model
	Title  string    `json:"title"`
	Amount float64   `json:"amount"`
	Type   string    `json:"type"`
	Date   time.Time `json:"date"`
	UserID uint      `json:"user_id"`
}
