package models

import (
	"time"
)

type Company struct {
	ID          string `gorm:"primaryKey;type:char(36)"`
	CompanyID   string `gorm:"unique;size:50"`
	CompanyName string `gorm:"not null;size:255"`
	TIN         string `gorm:"unique;not null;size:20"`
	Address     string
	Phone       string
	Users       []User   `gorm:"foreignKey:CompanyTIN;references:TIN"`
	Clients     []Client `gorm:"foreignKey:CompanyTIN;references:TIN"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	// DeletedAt   gorm.DeletedAt `gorm:"index"`
}
