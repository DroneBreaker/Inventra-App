package models

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	ID          string `gorm:"primaryKey;type:char(36)"`
	FirstName   string
	LastName    string
	Email       string
	Username    string `gorm:"unique;not null;size:100"`
	CompanyID   string
	CompanyTIN  string `gorm:"size:20"`
	CompanyName string
	Company     Company `gorm:"foreignKey:CompanyTIN;references:TIN" json:"-"`
	Password    string  `json:"-"`
	Role        Role
	CreatedAt   time.Time
	UpdatedAt   time.Time
	DeletedAt   gorm.DeletedAt `gorm:"index"`
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
