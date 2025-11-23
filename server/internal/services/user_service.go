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

func (s *UserService) GetByID(id string) (*models.User, error) {
	var user models.User
	err := s.DB.Preload("Company").First(&user, id).Error

	return &user, err
}
