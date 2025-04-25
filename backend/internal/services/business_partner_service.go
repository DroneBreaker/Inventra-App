package services

import (
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
)

type BusinessPartnerService interface {
	GetAll(businessPartnerTIN string) ([]models.BusinessPartner, error)
	Create(businessPartner *models.BusinessPartner, businessPartnerTIN string) error
	GetByID(id int, sompanyID string, businessPartnerTIN string) (*models.BusinessPartner, error)
	GetByName(name string, companyID string, businessPartnerTIN string) (*models.BusinessPartner, error)
	Update(businessPartner *models.BusinessPartner, businessPartnerTIN string) error
	Delete(id int, businessPartnerTIN string) error
}

type businessPartnerService struct {
	repo repository.BusinessPartnerRepository
}

func NewBusinessPartnerService(repo repository.BusinessPartnerRepository) BusinessPartnerService {
	return &businessPartnerService{repo: repo}
}

func (s *businessPartnerService) GetAll(businessPartnerTIN string) ([]models.BusinessPartner, error) {
	return s.repo.GetAll(businessPartnerTIN)
}

func (s *businessPartnerService) Create(businessPartner *models.BusinessPartner, businessPartnerTIN string) error {
	return s.repo.Create(businessPartner, businessPartnerTIN)
}

func (s *businessPartnerService) GetByID(id int, companyID string, businessPartnerTIN string) (*models.BusinessPartner, error) {
	return s.repo.GetByID(id, companyID, businessPartnerTIN)
}

func (s *businessPartnerService) GetByName(name string, companyID string, businessPartnerTIN string) (*models.BusinessPartner, error) {
	return s.repo.GetByName(name, companyID, businessPartnerTIN)
}

func (s *businessPartnerService) Update(businessPartner *models.BusinessPartner, businessPartnerTIN string) error {
	return s.repo.Update(businessPartner, businessPartnerTIN)
}

func (s *businessPartnerService) Delete(id int, businessPartnerTIN string) error {
	return s.repo.Delete(id, businessPartnerTIN)
}
