package services

import (
	"errors"
	"time"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
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
	var company models.Company

	err := s.DB.Where("tin = ?", data.CompanyTIN).First(&company).Error

	if err == gorm.ErrRecordNotFound {
		company = models.Company{
			ID:          uuid.New().String(),
			CompanyID:   data.CompanyID,
			CompanyName: data.CompanyName,
			TIN:         data.CompanyTIN,
		}

		if err := s.DB.Create(&company).Error; err != nil {
			return errors.New("failed to create company: " + err.Error())
		}
	} else if err != nil {
		return err
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(data.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	user := models.User{
		ID:          uuid.New().String(),
		FirstName:   data.FirstName,
		LastName:    data.LastName,
		Email:       data.Email,
		Username:    data.Username,
		Password:    string(hashed),
		Role:        models.Role(data.Role),
		CompanyName: company.CompanyName,
		CompanyID:   data.CompanyID,
		CompanyTIN:  company.TIN,
	}

	return s.DB.Create(&user).Error
}

func (s *AuthService) Login(data models.LoginDTO) (*models.User, string, error) {
	var user models.User

	if err := s.DB.Where("username = ? AND company_tin = ?", data.Username, data.CompanyTIN).
		First(&user).Error; err != nil {
		return nil, "", errors.New("invalid username or company TIN")
	}

	// if err != nil {
	// 	return "", errors.New("invalid login credentials")
	// }

	if bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(data.Password)) != nil {
		return nil, "", errors.New("incorrect password")
	}

	claims := jwt.MapClaims{
		"user_id":     user.ID,
		"company_id":  user.CompanyID,
		"company_tin": user.CompanyTIN,
		// "role": user.Role
		"exp": time.Now().Add(12 * time.Hour).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signedToken, err := token.SignedString(jwtSecret)
	return &user, signedToken, err
}
