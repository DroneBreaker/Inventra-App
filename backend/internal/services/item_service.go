package services

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
)

type ItemService interface {
	GetAll(companyID string) ([]models.Item, error)
	Create(item *models.Item, companyID string) error
	GetByID(companyID string) (*models.Item, error)
	GetByItemName(iteName string, companyID string) (*models.Item, error)
	Update(item *models.Item, companyID string) error
	Delete(id int, companyID string) error
}

type itemService struct {
	repo repository.ItemRepository
}

func NewItemService(repo repository.ItemRepository) ItemService {
	return &itemService{repo: repo}
}

func (s *itemService) GetAll(companyID string) ([]models.Item, error) {
	return s.repo.GetAll(companyID)
}

func (s *itemService) Create(item *models.Item, companyID string) error {
	item.CompanyID = companyID
	return s.repo.Create(item, companyID)
}

func (s *itemService) GetByID(companyID string) (*models.Item, error) {
	return s.repo.GetByID(companyID)
}

func (s *itemService) GetByItemName(itemName string, companyID string) (*models.Item, error) {
	return s.repo.GetByItemName(itemName, companyID)
}

func (s *itemService) Update(item *models.Item, companyID string) error {
	// Make sure the item belongs to this business partner
	existingItem, err := s.repo.GetByID(item.CompanyID)
	if err != nil {
		return err
	}

	if existingItem.CompanyID != companyID {
		return errors.New("unauthorized: item does not belong to this business partner")
	}
	return s.repo.Update(item, companyID)
}

func (s *itemService) Delete(id int, companyID string) error {
	return s.repo.Delete(id, companyID)
}
