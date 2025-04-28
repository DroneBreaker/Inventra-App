package services

import (
	"errors"
	"fmt"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserService interface {
	GetAll() ([]models.User, error)
	Create(user *models.User) error
	Login(username, companyID, companyTIN, password string) (*models.User, error)
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
	existingUser, err := s.repo.GetByUsername(user.Username)
	if err == nil && existingUser != nil {
		return errors.New("username already exists")
	}

	// // Check if CompanyID already exists
	// existingUser, err = s.repo.GetByID(fmt.Sprintf("%d", user.ID))
	// if err == nil && existingUser != nil {
	// 	return errors.New("company ID already exists")
	// }

	// Check if CompanyTIN already exists
	company, err := s.repo.GetByCompanyTIN(user.Company.TIN)
	if err != nil {
		return errors.New("company TIN already exists")
	}

	// && existingUser != nil

	user.CompanyID = fmt.Sprintf("%d", company.ID)

	// Set default role if not provided
	// if user.Role == "" {
	// 	user.Role = "user" // default role
	// }

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	fmt.Printf("Hashed password is: %s", hashedPassword)
	user.Password = string(hashedPassword)
	return s.repo.Create(user)
}

func (s *userService) Login(username, CompanyID, CompanyTIN, password string) (*models.User, error) {
	// Input validation
	if username == "" && CompanyTIN == "" {
		return nil, errors.New("username or company TIN is required")
	}
	if password == "" {
		return nil, errors.New("password is required")
	}

	// Find user by username or business TIN
	var user *models.User
	var err error

	if username != "" {
		user, err = s.repo.GetByUsername(username)
	}

	if CompanyID != "" {
		user, err = s.repo.GetByID(CompanyID)
	} else {
		user, err = s.repo.GetByCompanyTIN(CompanyTIN)
	}

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("User not found")
		}
	}

	// if err != nil {
	// 	return nil, fmt.Errorf("failed to retrieve user: %w", err)
	// }
	// if user == nil {
	// 	return nil, errors.New("user not found")
	// }

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
