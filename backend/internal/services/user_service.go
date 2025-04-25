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
	// Check if username already exists
	existingUser, err := s.repo.GetByID(user.CompanyID)
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
	// fmt.Printf("Hashed password is: %s", hashedPassword)
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

func (s *userService) Delete(id int) error {
	return s.repo.Delete(id)
}
