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

func (s *itemService) GetAll(businessPartnerTIN string) ([]models.Item, error) {
	return s.repo.GetAll(businessPartnerTIN)
}

func (s *itemService) Create(item *models.Item, businessPartnerTIN string) error {
	return s.repo.Create(item, businessPartnerTIN)
}

func (s *itemService) GetByID(id int, businessPartnerTIN string) (*models.Item, error) {
	return s.repo.GetByID(id, businessPartnerTIN)
}

func (s *itemService) GetByItemName(itemName string, businessPartnerTIN string) (*models.Item, error) {
	return s.repo.GetByItemName(itemName, businessPartnerTIN)
}

func (s *itemService) Update(item *models.Item, businessPartnerTIN string) error {
	return s.repo.Update(item, businessPartnerTIN)
}

func (s *itemService) Delete(id int, businessPartnerTIN string) error {
	return s.repo.Delete(id, businessPartnerTIN)
}
