package models

import "time"

type Company struct {
	ID          string `gorm:"primaryKey"`
	CompanyName string `gorm:"unique;not null"`
	TIN         string `gorm:"unique;not null"`
	Address     string
	Phone       string // Phone numbers better as String
	Users       []User `gorm:"foreignKey:CompanyID"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	DeletedAt   time.Time
}
