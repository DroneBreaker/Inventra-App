package services

import (
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"gorm.io/gorm"
)

type UserService struct {
	DB *gorm.DB
}

func NewUserService(db *gorm.DB) *UserService {
	return &UserService{DB: db}
}

// Get All users
func (s *UserService) GetAll(companyID string) ([]models.User, error) {
	var user []models.User

	if err := s.DB.Where("company_id = ?", companyID).Find(&user).Error; err != nil {
		return nil, err
	}

	return user, nil
}

// Create users
// func (s *UserService) Create(user *models.User) error {
// 	if user.ID == "" {
// 		// user.ID = uuid.New().String()
// 	}
// }

// Get users by ID
func (s *UserService) GetByID(id string) (*models.User, error) {
	var user models.User
	err := s.DB.Preload("Company").First(&user, id).Error

	return &user, err
}
