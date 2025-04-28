package services

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
)

type ItemService interface {
	GetAll(companyTIN string) ([]models.Item, error)
	Create(item *models.Item, companyTIN string) error
	GetByID(companyID string) (*models.Item, error)
	GetByItemName(iteName string, companyTIN string) (*models.Item, error)
	Update(item *models.Item, companyTIN string) error
	Delete(id int, companyTIN string) error
}

type itemService struct {
	repo repository.ItemRepository
}

func NewItemService(repo repository.ItemRepository) ItemService {
	return &itemService{repo: repo}
}

func (s *itemService) GetAll(companyTIN string) ([]models.Item, error) {
	return s.repo.GetAll(companyTIN)
}

func (s *itemService) Create(item *models.Item, companyTIN string) error {
	item.CompanyTIN = companyTIN
	return s.repo.Create(item, companyTIN)
}

func (s *itemService) GetByID(companyTIN string) (*models.Item, error) {
	return s.repo.GetByID(companyTIN)
}

func (s *itemService) GetByItemName(itemName string, companyTIN string) (*models.Item, error) {
	return s.repo.GetByItemName(itemName, companyTIN)
}

func (s *itemService) Update(item *models.Item, companyTIN string) error {
	// Make sure the item belongs to this business partner
	existingItem, err := s.repo.GetByID(item.CompanyTIN)
	if err != nil {
		return err
	}

	if existingItem.CompanyTIN != companyTIN {
		return errors.New("unauthorized: item does not belong to this business partner")
	}
	return s.repo.Update(item, companyTIN)
}

func (s *itemService) Delete(id int, companyID string) error {
	return s.repo.Delete(id, companyID)
}
