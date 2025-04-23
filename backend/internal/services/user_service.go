package services

import (
	"errors"
	"fmt"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
	"golang.org/x/crypto/bcrypt"
)

type UserService interface {
	GetAll() ([]models.User, error)
	Create(user *models.User) error
	Login(username, businessTIN, password string) (*models.User, error)
	Delete(id int) error
}

type userService struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) UserService {
	return &userService{repo: repo}
}

func (s *userService) GetAll() ([]models.User, error) {
	return s.repo.GetAll()
}

func (s *userService) Create(user *models.User) error {
	// // Check if user exists
	// existing, _ := s.repo.GetByEmail(user.Email)
	// if existing != nil {
	// 	return errors.New("email already exist")
	// }

	// hashed, err := utils.HashPassword(user.Password)
	// log.Printf("Successfully hashed password for user: %s", hashed)

	// if err != nil {
	// 	return err
	// }
	// user.Password = hashed

	// // TODO: hash password
	// return s.repo.Create(user)

	// Check if username already exists
	existingUser, err := s.repo.GetByID(uint(user.ID))
	if err == nil && existingUser != nil {
		return errors.New("username already exists")
	}

	// Check if BusinessTIN already exists
	existingUser, err = s.repo.GetByBusinessPartnerTIN(user.BusinessPartnerTIN)
	if err == nil && existingUser != nil {
		return errors.New("business TIN already exists")
	}

	// Set default role if not provided
	// if user.Role == "" {
	// 	user.Role = "user" // default role
	// }

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedPassword)
	return s.repo.Create(user)
}

func (s *userService) Login(username, businessPartnerTIN, password string) (*models.User, error) {
	// Input validation
	if username == "" && businessPartnerTIN == "" {
		return nil, errors.New("username or business TIN is required")
	}
	if password == "" {
		return nil, errors.New("password is required")
	}

	// Find user by username or business TIN
	var user *models.User
	var err error

	if username != "" {
		user, err = s.repo.GetByUsername(username)
	} else {
		user, err = s.repo.GetByBusinessPartnerTIN(businessPartnerTIN)
	}

	if err != nil {
		return nil, fmt.Errorf("failed to retrieve user: %w", err)
	}
	if user == nil {
		return nil, errors.New("user not found")
	}

	// Verify password
	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	if err != nil {
		return nil, errors.New("invalid credentials")
	}

	return user, nil
}

// func (s *userService) Login(username, businessPartnerTIN, password string) (*models.User, error) {
// 	// Input validation
// 	if strings.TrimSpace(username) == "" {
// 		return nil, errors.New("username cannot be empty")
// 	}
// 	if strings.TrimSpace(password) == "" {
// 		return nil, errors.New("password cannot be empty")
// 	}

// 	// Get user from repo
// 	user, err := s.repo.GetByUsername(username)
// 	if err != nil {
// 		log.Printf("Database error looking up user %s: %v", username, err)
// 		return nil, fmt.Errorf("authentication error")
// 	}

// 	if user == nil {
// 		log.Printf("Login attempt for non-existent user: %s", username)
// 		return nil, errors.New("invalid credentials")
// 	}

// 	// Verify business TIN if required (for taxpayers)
// 	if businessPartnerTIN != "" && user.BusinessPartnerTIN != businessPartnerTIN {
// 		log.Printf("Business TIN mismatch for user %s", username)
// 		return nil, errors.New("invalid credentials")
// 	}

// 	// Verify password
// 	if err := utils.CheckPasswordHash(password, user.Password); err != nil {
// 		log.Printf("Invalid password for user %s: %v", username, err)
// 		return nil, errors.New("invalid credentials")
// 	}

// 	// // TODO: check hashed password
// 	// if !utils.CheckPasswordHash(password, user.Password) {
// 	// 	return nil, errors.New("invalid credentials")
// 	// }
// 	return user, nil
// }

func (s *userService) Delete(id int) error {
	return s.repo.Delete(id)
}
