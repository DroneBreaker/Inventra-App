package repository

import (
	"errors"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"gorm.io/gorm"
)

type UserRepository interface {
	GetAll() ([]models.User, error)
	Create(user *models.User) error
	GetByID(companyID string) (*models.User, error)
	GetByUsername(username string) (*models.User, error)
	GetByEmail(email string) (*models.User, error)
	GetByCompanyTIN(companyTIN string) (*models.User, error)
	Update(user *models.User) error
	Delete(id int) error
}

type userRepo struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepo{db: db}
}

// func (r *userRepo) GetAll() ([]models.User, error) {
// 	users := []models.User{}
// 	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN FROM users`
// 	rows, err := r.db.Query(query)
// 	if err != nil {
// 		return nil, err
// 	}
// 	defer rows.Close()

// 	for rows.Next() {
// 		var user models.User
// 		if err := rows.Scan(&user.CompanyID, &user.FirstName, &user.LastName, &user.Username, &user.Email, &user.BusinessPartnerTIN); err != nil {
// 			return nil, err
// 		}
// 		users = append(users, user)
// 	}
// 	return users, nil
// }

// func (r *userRepo) Create(user *models.User) error {
// 	query := `INSERT INTO users(firstName, lastName, username, email, businessPartnerTIN, password)
// 		VALUES (?, ?, ?, ?, ?, ?)`
// 	result, err := r.db.Exec(query, user.FirstName, user.LastName, user.Username, user.Email, user.BusinessPartnerTIN,
// 		user.Password)

// 	if err != nil {
// 		return err
// 	}

// 	// Retrieve the last inserted ID
// 	id, err := result.LastInsertId()
// 	if err != nil {
// 		return err
// 	}

// 	user.CompanyID = string(id) // Set the ID in the user object
// 	return nil
// }

// func (r *userRepo) GetByID(id uint) (*models.User, error) {
// 	user := &models.User{}
// 	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, password, createdAt
// 		FROM users WHERE email = ?`

// 	err := r.db.QueryRow(query, id).Scan(&user.CompanyID, &user.FirstName, &user.LastName, &user.Username, &user.Email,
// 		&user.BusinessPartnerTIN, &user.Password, &user.CreatedAt)
// 	return user, err
// }

// func (r *userRepo) GetByUsername(username string) (*models.User, error) {
// 	user := &models.User{}
// 	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, password, createdAt
// 		FROM users WHERE username = ?`
// 	err := r.db.QueryRow(query, username).Scan(&user.CompanyID, &user.FirstName, &user.LastName, &user.Username, &user.Email,
// 		&user.BusinessPartnerTIN, &user.Password, &user.CreatedAt)
// 	return user, err
// }

// func (r *userRepo) GetByEmail(email string) (*models.User, error) {
// 	user := &models.User{}
// 	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, password, createdAt
// 		FROM users WHERE email = ?`
// 	err := r.db.QueryRow(query, email).Scan(&user.CompanyID, &user.FirstName, &user.LastName, &user.Username, &user.Email,
// 		&user.BusinessPartnerTIN, &user.Password, &user.CreatedAt)

// 	if err == sql.ErrNoRows {
// 		return nil, errors.New("user not found") // Return nil user when no user is found
// 	}

// 	// if err != nil {
// 	// 	return nil, err // Return any other database errors
// 	// }

// 	return user, err
// }

// func (r *userRepo) GetByBusinessPartnerTIN(businessPartnerTIN string) (*models.User, error) {
// 	user := &models.User{}
// 	query := `SELECT id, firstName, lastName, username, email, businessPartnerTIN, createdAt
// 		FROM users WHERE businessPartnerTIN = ?`
// 	err := r.db.QueryRow(query, businessPartnerTIN).Scan(&user.CompanyID, &user.FirstName, &user.LastName, &user.Email, &user.BusinessPartnerTIN, &user.CreatedAt)
// 	return user, err
// }

// func (r *userRepo) Update(user *models.User) error {
// 	query := `UPDATE users SET firstName = ?, lastName = ?, username = ?, email = ?, businessPartnerTIN = ? WHERE id = ?`
// 	_, err := r.db.Exec(query, user.FirstName, user.LastName, user.Username, user.Email, user.BusinessPartnerTIN, user.CompanyID)
// 	return err
// }

// func (r *userRepo) Delete(id int) error {
// 	query := `DELETE FROM users WHERE id = ?`
// 	_, err := r.db.Exec(query, id)
// 	return err
// }

func (r *userRepo) GetAll() ([]models.User, error) {
	var users []models.User
	result := r.db.Select("id", "first_name", "last_name", "username", "email", "password", "company_id", "company", "createdAt", "updatedAt").Find(&users)
	return users, result.Error
}

func (r *userRepo) Create(user *models.User) error {
	result := r.db.Create(user)
	return result.Error
}

func (r *userRepo) GetByID(companyID string) (*models.User, error) {
	var user models.User
	result := r.db.Select("id", "first_name", "last_name", "username", "email", "password", "company_id", "company", "created_at", "updated_at").
		First(&user, companyID)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &user, result.Error
}

func (r *userRepo) GetByUsername(username string) (*models.User, error) {
	var user models.User
	result := r.db.Where("username = ?", username).
		Select("id", "first_name", "last_name", "username", "email", "password", "company_id", "company", "created_at", "updated_at").
		First(&user)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &user, result.Error
}

func (r *userRepo) GetByEmail(email string) (*models.User, error) {
	var user models.User
	result := r.db.Where("email = ?", email).
		Select("id", "first_name", "last_name", "username", "email", "password", "company_id", "company", "created_at", "updated_at").
		First(&user)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &user, result.Error
}

func (r *userRepo) GetByCompanyTIN(companyTIN string) (*models.User, error) {
	var user models.User
	result := r.db.Where("companyTIN = ?", companyTIN).
		Select("id", "first_name", "last_name", "username", "email", "password", "company_id", "company", "created_at", "updated_at").
		First(&user)
	if errors.Is(result.Error, gorm.ErrRecordNotFound) {
		return nil, errors.New("user not found")
	}
	return &user, result.Error
}

func (r *userRepo) Update(user *models.User) error {
	result := r.db.Model(user).Updates(models.User{
		FirstName: user.FirstName,
		LastName:  user.LastName,
		Username:  user.Username,
		Email:     user.Email,
		// Company: user.Company.TIN,
		CompanyID: user.CompanyID,
		Company:   user.Company,
		UpdatedAt: user.UpdatedAt,
	})
	return result.Error
}

func (r *userRepo) Delete(id int) error {
	result := r.db.Delete(&models.User{}, id)
	return result.Error
}
