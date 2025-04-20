package services

import (
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
)

type ItemService interface {
	GetAll(businessTIN string) ([]models.Item, error)
	Create(item *models.Item, businessTIN string) error
	GetByID(id int, businessTIN string) (*models.Item, error)
	GetByItemName(iteName string, businessTIN string) (*models.Item, error)
	Update(item *models.Item, businessTIN string) error
	Delete(id int, businessTIN string) error
}

type itemService struct {
	repo repository.ItemRepository
}

func NewItemService(repo repository.ItemRepository) itemService {
	return itemService{repo: repo}
}

func (s *itemService) GetAll(businessTIN string) ([]models.Item, error) {
	return s.repo.GetAll(businessTIN)
}

func (s *itemService) Create(item *models.Item, businessTIN string) error {
	return s.repo.Create(item, businessTIN)
}

func (s *itemService) GetByID(id int, businessTIN string) (*models.Item, error) {
	return s.repo.GetByID(id, businessTIN)
}

func (s *itemService) GetByItemName(itemName string, businessTIN string) (*models.Item, error) {
	return s.repo.GetByItemName(itemName, businessTIN)
}

func (s *itemService) Update(item *models.Item, businessTIN string) error {
	return s.repo.Update(item, businessTIN)
}

func (s *itemService) Delete(id int, businessTIN string) error {
	return s.repo.Delete(id, businessTIN)
}
