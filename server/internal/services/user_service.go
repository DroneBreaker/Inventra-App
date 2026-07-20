package services

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserService struct {
	DB *gorm.DB
}

func NewUserService(db *gorm.DB) *UserService {
	return &UserService{DB: db}
}

// Get All users
func (s *UserService) GetAll(companyTIN string) ([]models.User, error) {
	var user []models.User

	if err := s.DB.Where("company_tin = ?", companyTIN).Find(&user).Error; err != nil {
		return nil, err
	}

	return user, nil
}

// CREATE USERS
func (s *UserService) CreateUser(user *models.User) error {
	// Hash password
	hashed, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashed)

	// UUID
	user.ID = uuid.New().String()

	// Check company exists; if not, create it (self-service signup)
	var company models.Company
	err = s.DB.Where("tin = ?", user.CompanyTIN).First(&company).Error

	if err == gorm.ErrRecordNotFound {
		// No company with this TIN yet — create one from the registration payload
		company = models.Company{
			ID:          uuid.New().String(),
			CompanyID:   user.CompanyID,
			CompanyName: user.CompanyName,
			TIN:         user.CompanyTIN,
		}

		if err := s.DB.Create(&company).Error; err != nil {
			return errors.New("failed to create company: " + err.Error())
		}
	} else if err != nil {
		// Some other DB error occurred during the lookup
		return err
	}

	user.CompanyName = company.CompanyName

	return s.DB.Create(user).Error
}

// GET USER
func (s *UserService) GetUserByID(id string, companyTIN string) (*models.User, error) {
	var user models.User
	err := s.DB.Where("id = ? AND company_tin = ?", id, companyTIN).First(&user).Error
	return &user, err
}

// UPDATE USERS
func (s *UserService) UpdateUser(id string, companyTIN string, updates map[string]interface{}) error {
	return s.DB.Model(&models.User{}).
		Where("id = ? AND company_tin = ?", id, companyTIN).
		Updates(updates).Error
}

// DELETE USERS
func (s *UserService) DeleteUser(id string, companyTIN string) error {
	return s.DB.Where("id = ? AND company_tin = ?", id, companyTIN).
		Delete(&models.User{}).Error
}
