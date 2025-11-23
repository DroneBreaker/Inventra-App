package models

import "time"

type User struct {
	ID          string `gorm:"primaryKey;type:char(36)"`
	FirstName   string
	LastName    string
	Email       string
	Username    string `gorm:"unique;not null"`
	CompanyID   string
	CompanyTIN  string
	CompanyName string
	Company     Company
	Password    string
	Role        Role
	CreatedAt   time.Time
	UpdatedAt   time.Time
	DeletedAt   time.Time
}

type Role string

const (
	Staff Role = "Staff"
	Admin Role = "Admin"
)

type RegisterDTO struct {
	FirstName   string `json:"first_name"`
	LastName    string `json:"last_name"`
	Email       string `json:"email"`
	Username    string `json:"username"`
	CompanyID   string `json:"company_id"`
	CompanyName string `json:"company_name"`
	CompanyTIN  string `json:"company_tin"`
	Role        string `json:"role"`
	Password    string `json:"password"`
}

type LoginDTO struct {
	Username   string `json:"username"`
	CompanyTIN string `json:"company_tin"`
	Password   string `json:"password"`
}
