package repository

import (
	"database/sql"

	"github.com/DroneBreaker/Inventra-App/internal/models"
)

type BusinessPartnerRepository interface {
	GetAll(businessPartnerTIN string) ([]models.BusinessPartner, error)
	Create(businessPartner *models.BusinessPartner, businessPartnerTIN string) error
	GetByID(id int, businessPartnerTIN string) (*models.BusinessPartner, error)
	GetByName(name string, businessPartnerTIN string) (*models.BusinessPartner, error)
	Update(businessPartner *models.BusinessPartner, businessPartnerTIN string) error
	Delete(id int, businessPartnerTIN string) error
}

type businessPartnerRepo struct {
	db *sql.DB
}

func NewBusinessPartnerRepository(db *sql.DB) BusinessPartnerRepository {
	return &businessPartnerRepo{db: db}
}

func (r *businessPartnerRepo) GetAll(businessPartnerTIN string) ([]models.BusinessPartner, error) {
	businessPartners := []models.BusinessPartner{}
	query := `SELECT id, name, businessPartnerTIN, email, businessPartnerType, contact, createdAt FROM business_partners`
	rows, err := r.db.Query(query, businessPartnerTIN)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var businessPartner models.BusinessPartner
		err := rows.Scan(&businessPartner.ID, &businessPartner.Name, &businessPartner.BusinessPartnerTIN,
			&businessPartner.Email, &businessPartner.BusinessPartnerType, &businessPartner.Contact, &businessPartner.CreatedAt)
		if err != nil {
			return nil, err
		}
		businessPartners = append(businessPartners, businessPartner)
	}

	return businessPartners, nil
}

func (r *businessPartnerRepo) Create(businessPartner *models.BusinessPartner, businessPartnerTIN string) error {
	query := `INSERT INTO business_partners (id, name, businessPartnerTIN, email, businessPartnerType, contact) VALUES(?,?,?,?,?,?)`
	result, err := r.db.Exec(query, businessPartner.ID, businessPartner.Name, businessPartner.BusinessPartnerTIN, businessPartner.Email,
		businessPartner.BusinessPartnerType, &businessPartner.Contact)

	if err != nil {
		return err
	}

	// Retrieve the last inserted ID
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	businessPartner.ID = int(id) // Set the ID in the businessPartner object
	businessPartner.BusinessPartnerTIN = businessPartnerTIN
	return nil
}

func (r *businessPartnerRepo) GetByID(id int, businessPartnerTIN string) (*models.BusinessPartner, error) {
	businessPartner := &models.BusinessPartner{}
	query := `SELECT id, name, businessPartnerTIN, email, businessPartnerType, contact WHERE id = ? and businessPartnerTIN = ?`

	err := r.db.QueryRow(query, id, businessPartnerTIN).Scan(&businessPartner.ID, &businessPartner.Name, &businessPartner.BusinessPartnerTIN,
		&businessPartner.Email, &businessPartner.Contact)
	// if err != nil {
	// 	if err == sql.ErrNoRows {
	// 		return nil, errors.New("item not found in database")
	// 	}
	// 	return nil, err
	// }
	return businessPartner, err
}

func (r *businessPartnerRepo) GetByName(name string, businessPartnerTIN string) (*models.BusinessPartner, error) {
	businessPartner := &models.BusinessPartner{}
	query := `SELECT ID, businessPartnerName, businessPartnerTIN, email, businessPartnerType, contact WHERE id = ? 
		and businessPartnerTIN = ?`
	err := r.db.QueryRow(query, name, businessPartnerTIN).Scan(&businessPartner.ID, &businessPartner.Name, &businessPartner.BusinessPartnerTIN,
		&businessPartner.Email, &businessPartner.BusinessPartnerType, &businessPartner.Contact)
	return businessPartner, err
}

func (r *businessPartnerRepo) Update(businessPartner *models.BusinessPartner, businessPartnerTIN string) error {
	query := `UPDATE business_partners set name = ?, businessPartnerTIN = ?, email = ?, businessPartnerType = ?, contact = ?, 
		WHERE id = ? AND businessPartnerTIN = ?`
	_, err := r.db.Exec(query, businessPartner.Name, businessPartner.BusinessPartnerTIN, businessPartner.Email,
		businessPartner.BusinessPartnerType, businessPartner.Contact)
	return err
}

func (r *businessPartnerRepo) Delete(id int, businessPartnerTIN string) error {
	query := `DELETE FROM business_partners WHERE id = ? and businessPartnerTIN = ?`
	_, err := r.db.Exec(query, id, businessPartnerTIN)
	return err
}
