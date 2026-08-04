package services

import (
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ItemService struct {
	DB *gorm.DB
}

func NewItemService(db *gorm.DB) *ItemService {
	return &ItemService{DB: db}
}

func (s *ItemService) GetItems(companyTIN string) ([]models.Item, error) {
	var items []models.Item

	if err := s.DB.Where("company_tin = ?", companyTIN).Find(&items).Error; err != nil {
		return nil, err
	}

	return items, nil
}

func (s *ItemService) CreateItem(item *models.Item) error {
	item.ID = uuid.New().String()
	return s.DB.Create(item).Error
}
