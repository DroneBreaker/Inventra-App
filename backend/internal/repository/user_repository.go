package repository

import (
	"database/sql"

	"github.com/DroneBreaker/Inventra-App/internal/models"
)

type UserRepository interface {
	GetAll() ([]models.User, error)
	Create(user *models.User) error
	GetByID(id int) (*models.User, error)
	GetByUsername(username string) (*models.User, error)
	GetByEmail(email string) (*models.User, error)
	GetByBusinessTIN(businessTIN string) (*models.User, error)
	Update(user *models.User) error
	Delete(id int) error
}

type userRepo struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) UserRepository {
	return &userRepo{db: db}
}

func (r *userRepo) GetAll() ([]models.User, error) {
	users := []models.User{}
	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN FROM users`
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var user models.User
		if err := rows.Scan(&user.ID, &user.FirstName, &user.LastName, &user.Username, &user.Email, &user.BusinessPartnerTIN); err != nil {
			return nil, err
		}
		users = append(users, user)
	}
	return users, nil
}

func (r *userRepo) Create(user *models.User) error {
	query := `INSERT INTO users(firstName, lastName, username, email, businessPartnerTIN) 
		VALUES (?, ?, ?, ?, ?)`
	result, err := r.db.Exec(query, user.FirstName, user.LastName, user.Username, user.Email, user.BusinessPartnerTIN)

	if err != nil {
		return err
	}

	// Retrieve the last inserted ID
	id, err := result.LastInsertId()
	if err != nil {
		return err
	}

	user.ID = uint(id) // Set the ID in the user object
	return nil
}

func (r *userRepo) GetByID(id int) (*models.User, error) {
	user := &models.User{}
	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, createdAt 
		FROM users WHERE email = ?`

	err := r.db.QueryRow(query, id).Scan(&user.ID, &user.FirstName, &user.LastName, &user.Username, &user.Email, &user.BusinessPartnerTIN, &user.CreatedAt)
	return user, err
}

func (r *userRepo) GetByUsername(username string) (*models.User, error) {
	user := &models.User{}
	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, createdAt 
		FROM users WHERE username = ?`
	err := r.db.QueryRow(query, username).Scan(&user.ID, &user.FirstName, &user.LastName, &user.Username, &user.Email, &user.BusinessPartnerTIN, &user.CreatedAt)
	return user, err
}

func (r *userRepo) GetByEmail(email string) (*models.User, error) {
	user := &models.User{}
	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, password, createdAt 
		FROM users WHERE email = ?`
	err := r.db.QueryRow(query, email).Scan(&user.ID, &user.FirstName, &user.LastName, &user.Username, &user.Email, &user.BusinessPartnerTIN, &user.Password, &user.CreatedAt)

	if err == sql.ErrNoRows {
		return nil, nil // Return nil user when no user is found
	}

	if err != nil {
		return nil, err // Return any other database errors
	}

	return user, err
}

func (r *userRepo) GetByBusinessTIN(businessPartnerTIN string) (*models.User, error) {
	user := &models.User{}
	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, createdAt 
		FROM users WHERE businessTIN = ?`
	err := r.db.QueryRow(query, businessPartnerTIN).Scan(&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.BusinessPartnerTIN, &user.CreatedAt)
	return user, err
}

func (r *userRepo) Update(user *models.User) error {
	query := `UPDATE users SET firstName = ?, lastName = ?, username = ?, email = ?, businessPartnerTIN = ? WHERE id = ?`
	_, err := r.db.Exec(query, user.FirstName, user.LastName, user.Username, user.Email, user.BusinessPartnerTIN, user.ID)
	return err
}

func (r *userRepo) Delete(id int) error {
	query := `DELETE FROM users WHERE id = ?`
	_, err := r.db.Exec(query, id)
	return err
}
