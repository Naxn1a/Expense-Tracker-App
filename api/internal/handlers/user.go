package handlers

import (
	"log"
	"os"

	"github.com/expense-tracker/internal/models"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func Authen(db *gorm.DB, t string) (*jwt.Token, error) {
	secretKey := os.Getenv("JWT_SECRET_KEY")

	token, err := jwt.ParseWithClaims(t, jwt.MapClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(secretKey), nil
	})

	return token, err
}

func GetUsers(db *gorm.DB) []models.User {
	var users []models.User

	err := db.Model(&models.User{}).Preload("Expense").Find(&users).Error

	if err != nil {
		log.Fatalf("Error fetching user: %v", err)
	}

	return users
}

// make getuser by username
func GetUser(db *gorm.DB, username string) models.User {
	var user models.User

	result := db.Where("username = ?", username).First(&user)

	if result.Error != nil {
		log.Fatalf("Error fetching user: %v", result.Error)
	}

	return user

}

// func GetUser(db *gorm.DB, id int) models.User {
// 	var user models.User

// 	result := db.First(&user, id)

// 	if result.Error != nil {
// 		log.Fatalf("Error fetching user: %v", result.Error)
// 	}

// 	return user
// }

func SignUpUser(db *gorm.DB, user *models.User) error {
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)

	if err != nil {
		return err
	}

	user.Password = string(hashPassword)

	result := db.Create(user)

	if result.Error != nil {
		return result.Error
	}

	return nil
}

func SignInUser(db *gorm.DB, user *models.User) (string, error) {
	selectedUser := new(models.User)

	result := db.Where("username = ?", user.Username).First(selectedUser)

	if result.Error != nil {
		return "", result.Error
	}

	err := bcrypt.CompareHashAndPassword([]byte(selectedUser.Password), []byte(user.Password))

	if err != nil {
		return "", err
	}

	secretKey := os.Getenv("JWT_SECRET_KEY")
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id"] = selectedUser.ID
	claims["username"] = selectedUser.Username

	t, err := token.SignedString([]byte(secretKey))

	if err != nil {
		return "", err
	}

	return t, nil
}

func UpdateUser(db *gorm.DB, id int, user *models.User) error {
	result := db.Model(&models.User{}).Where("id = ?", id).Updates(user)

	if result.Error != nil {
		return result.Error
	}

	return nil
}

func DeleteUser(db *gorm.DB, id int) error {
	result := db.Delete(&models.User{}, id)

	if result.Error != nil {
		return result.Error
	}

	return nil
}
