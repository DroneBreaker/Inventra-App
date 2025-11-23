package services

import (
	"errors"
	"time"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

var jwtSecret = []byte("SUPER_SECRET_KEY")

type AuthService struct {
	DB *gorm.DB
}

func NewAuthService(db *gorm.DB) *AuthService {
	return &AuthService{DB: db}
}

func (s *AuthService) Register(data models.RegisterDTO) error {
	// var company models.Company
	// if err := s.DB.Where("tin = ?", data.CompanyTIN).First(&company).Error; err != nil {
	// 	return errors.New("company not found")
	// }

	hashed, _ := bcrypt.GenerateFromPassword([]byte(data.Password), bcrypt.DefaultCost)

	user := models.User{
		// ID:          uuid.New().String(),
		FirstName:   data.FirstName,
		LastName:    data.LastName,
		Email:       data.Email,
		Username:    data.Username,
		Password:    string(hashed),
		Role:        models.Role(data.Role),
		CompanyName: data.CompanyName,
		CompanyID:   data.CompanyID,
		CompanyTIN:  data.CompanyTIN,
		// Company:     company,
		DeletedAt: time.Now(),
	}

	return s.DB.Create(&user).Error
}

func (s *AuthService) Login(data models.LoginDTO) (string, error) {
	var user models.User

	if err := s.DB.Where("username = ? AND company_tin = ?", data.Username, data.CompanyTIN).
		First(&user).Error; err != nil {
		return "", errors.New("invalid username or company TIN")
	}

	// if err != nil {
	// 	return "", errors.New("invalid login credentials")
	// }

	if bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(data.Password)) != nil {
		return "", errors.New("incorrect password")
	}

	claims := jwt.MapClaims{
		"user_id":     user.ID,
		"company_id":  user.CompanyID,
		"company_tin": user.Company.TIN,
		// "role": user.Role
		"exp": time.Now().Add(12 * time.Hour).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}
