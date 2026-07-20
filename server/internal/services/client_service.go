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

func (s *ClientService) GetAllClients() ([]models.Client, error) {
	var clients []models.Client
	return clients, s.DB.Find(&clients).Error
}

// client_service.go
// services/client_service.go
func (s *ClientService) SearchClients(query string, companyTIN string) ([]models.Client, error) {
	var clients []models.Client
	db := s.DB.Where("company_tin = ?", companyTIN)

	if query != "" {
		db = db.Where("client_name LIKE ?", "%"+query+"%")
	}

	err := db.Limit(20).Find(&clients).Error
	return clients, err
}
