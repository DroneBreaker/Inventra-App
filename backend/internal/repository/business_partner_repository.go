package repository

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"gorm.io/gorm"
)

type BusinessPartnerRepository interface {
	GetAll(businessPartnerTIN string) ([]models.BusinessPartner, error)
	Create(businessPartner *models.BusinessPartner, businessPartnerTIN string) error
	GetByID(id int, companyID string, businessPartnerTIN string) (*models.BusinessPartner, error)
	GetByName(name string, companyID string, businessPartnerTIN string) (*models.BusinessPartner, error)
	Update(businessPartner *models.BusinessPartner, businessPartnerTIN string) error
	Delete(id int, businessPartnerTIN string) error
}

type businessPartnerRepo struct {
	db *gorm.DB
}

func NewBusinessPartnerRepository(db *gorm.DB) BusinessPartnerRepository {
	return &businessPartnerRepo{db: db}
}

func (r *businessPartnerRepo) GetAll(businessPartnerTIN string) ([]models.BusinessPartner, error) {
	businessPartners := []models.BusinessPartner{}

	result := r.db.Select("id", "name", "businessPartnerTIN", "email", "businessPartnerType", "contact", "CompanyID", "createdAt").Find(&businessPartners)
	return businessPartners, result.Error
}

func (r *businessPartnerRepo) Create(businessPartner *models.BusinessPartner, businessPartnerTIN string) error {
	result := r.db.Create(businessPartner)
	return result.Error
}

func (r *businessPartnerRepo) GetByID(id int, companyID, businessPartnerTIN string) (*models.BusinessPartner, error) {
	var businessPartner models.BusinessPartner
	result := r.db.Select("id", "name", "businessPartnerTIN", "email", "businessPartnerType").
		First(&businessPartner, companyID, businessPartnerTIN)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &businessPartner, result.Error
}

func (r *businessPartnerRepo) GetByName(name string, companyID, businessPartnerTIN string) (*models.BusinessPartner, error) {
	var businessPartner models.BusinessPartner
	result := r.db.Select("id", "name", "businessPartnerTIN", "email", "businessPartnerType").
		First(&businessPartner, companyID, businessPartnerTIN)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &businessPartner, result.Error
}

func (r *businessPartnerRepo) Update(businessPartner *models.BusinessPartner, businessPartnerTIN string) error {
	result := r.db.Model(businessPartner).Updates(models.BusinessPartner{
		Name:                businessPartner.Name,
		BusinessPartnerTIN:  businessPartner.BusinessPartnerTIN,
		Email:               businessPartner.Email,
		BusinessPartnerType: businessPartner.BusinessPartnerType,
	})
	return result.Error
}

func (r *businessPartnerRepo) Delete(id int, businessPartnerTIN string) error {
	result := r.db.Delete(&models.BusinessPartner{}, id)
	return result.Error
}
