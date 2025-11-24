package models

import "time"

type Company struct {
	ID          string `gorm:"primaryKey"`
	CompanyName string `gorm:"unique;not null"`
	TIN         string `gorm:"unique;not null"`
	Address     string
	Phone       string   // Phone numbers better as String
	Users       []User   `gorm:"foreignKey:CompanyTIN;references:TIN"`
	Clients     []Client `gorm:"foreignKey:CompanyTIN;references:TIN"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	DeletedAt   time.Time
}
