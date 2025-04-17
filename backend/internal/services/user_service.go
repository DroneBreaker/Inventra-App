package services

import (
	"errors"
	"fmt"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
	"github.com/DroneBreaker/Inventra-App/utils"
)

type UserService interface {
	Register(user *models.User) error
	Login(username, email, businessTIN, password string) (*models.User, error)
	Delete(id int) error
}

type userService struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) UserService {
	return &userService{repo: repo}
}

func (s *userService) Register(user *models.User) error {
	// Check if user exists
	existing, _ := s.repo.GetByEmail(user.Email)
	if existing != nil {
		return errors.New("email already registered")
	}

	hashed, err := utils.HashPassword(user.Password)
	if err != nil {
		return err
	}
	user.Password = hashed

	// TODO: hash password
	return s.repo.Create(user)
}

func (s *userService) Login(username, email, businessTIN, password string) (*models.User, error) {
	user, err := s.repo.GetByEmail(email)
	if err != nil {
		return nil, fmt.Errorf("database error: %w", err)
	}

	if user == nil {
		return nil, errors.New("user not found")
	}

	// TODO: check hashed password
	if !utils.CheckPasswordHash(password, user.Password) {
		return nil, errors.New("invalid credentials")
	}

	// if user.Password != password {
	// 	return nil, errors.New("invalid credentials")
	// }

	return user, nil

	// // Debug values
	// fmt.Println("Stored password:", user.Password)
	// fmt.Println("Input password:", password)

	// // Check password
	// if user.Password != password {
	// 	return nil, errors.New("invalid credentials")
	// }

	// return user, nil
}

func (s *userService) Delete(id int) error {
	return s.repo.Delete(id)
}
