package models

import "time"

type Item struct {
	ID          string  `gorm:"primaryKey;type:char(36)"`
	Name        string  `json:"name"`
	CompanyTIN  string  `gorm:"not null"`
	Company     Company `gorm:"foreignKey:CompanyTIN;references:TIN" json:"-"`
	Description string  `json:"description"`
	Cost        float64 `json:"cost"`
	Amount      float64 `json:"amount"`
	Quantity    int     `json:"quantity"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}
