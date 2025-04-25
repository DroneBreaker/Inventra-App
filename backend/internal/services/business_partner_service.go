package services

import (
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
)

type BusinessPartnerService interface {
	GetAll(businessPartnerTIN string) ([]models.Client, error)
	Create(businessPartner *models.Client, companyID string) error
	GetByID(id int, companyID string) (*models.Client, error)
	GetByName(name string, companyID string) (*models.Client, error)
	Update(client *models.Client, companyID string) error
	Delete(id int, companyID string) error
}

type businessPartnerService struct {
	repo repository.BusinessPartnerRepository
}

func NewBusinessPartnerService(repo repository.BusinessPartnerRepository) BusinessPartnerService {
	return &businessPartnerService{repo: repo}
}

func (s *businessPartnerService) GetAll(companyID string) ([]models.Client, error) {
	return s.repo.GetAll(companyID)
}

func (s *businessPartnerService) Create(businessPartner *models.Client, companyID string) error {
	return s.repo.Create(businessPartner, companyID)
}

func (s *businessPartnerService) GetByID(id int, companyID string) (*models.Client, error) {
	return s.repo.GetByID(id, companyID)
}

func (s *businessPartnerService) GetByName(name string, companyID string) (*models.Client, error) {
	return s.repo.GetByName(name, companyID)
}

func (s *businessPartnerService) Update(client *models.Client, companyID string) error {
	return s.repo.Update(client, companyID)
}

func (s *businessPartnerService) Delete(id int, companyID string) error {
	return s.repo.Delete(id, companyID)
}
