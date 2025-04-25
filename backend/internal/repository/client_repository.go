package repository

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"gorm.io/gorm"
)

type BusinessPartnerRepository interface {
	GetAll(companyID string) ([]models.Client, error)
	Create(client *models.Client, companyID string) error
	GetByID(id int, companyID string) (*models.Client, error)
	GetByName(name string, companyID string) (*models.Client, error)
	Update(client *models.Client, companyID string) error
	Delete(id int, companyID string) error
}

type clientRepo struct {
	db *gorm.DB
}

func NewBusinessPartnerRepository(db *gorm.DB) BusinessPartnerRepository {
	return &clientRepo{db: db}
}

func (r *clientRepo) GetAll(companyID string) ([]models.Client, error) {
	clients := []models.Client{}

	result := r.db.Select("id", "clientName", "clientTIN", "email", "clientType", "contact", "CompanyID", "createdAt").Find(&clients)
	return clients, result.Error
}

func (r *clientRepo) Create(client *models.Client, companyID string) error {
	result := r.db.Create(client)
	return result.Error
}

func (r *clientRepo) GetByID(id int, companyID string) (*models.Client, error) {
	var businessPartner models.Client
	result := r.db.Select("id", "name", "clientTIN", "email", "businessPartnerType").
		First(&businessPartner, companyID)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &businessPartner, result.Error
}

func (r *clientRepo) GetByName(name string, companyID string) (*models.Client, error) {
	var client models.Client
	result := r.db.Select("id", "name", "businessPartnerTIN", "email", "businessPartnerType").
		First(&client, companyID)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &client, result.Error
}

func (r *clientRepo) Update(client *models.Client, companyID string) error {
	result := r.db.Model(client).Updates(models.Client{
		Name:       client.Name,
		ClienTIN:   client.ClienTIN,
		Email:      client.Email,
		ClientType: client.ClientType,
	})
	return result.Error
}

func (r *clientRepo) Delete(id int, businessPartnerTIN string) error {
	result := r.db.Delete(&models.Client{}, id)
	return result.Error
}
