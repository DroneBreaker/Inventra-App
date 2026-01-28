package services

import (
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ClientService struct {
	DB *gorm.DB
}

func NewClientService(db *gorm.DB) *ClientService {
	return &ClientService{DB: db}
}

func (s *ClientService) CreateClient(client *models.Client) error {
	client.ID = uuid.New().String()
	return s.DB.Create(client).Error
}
