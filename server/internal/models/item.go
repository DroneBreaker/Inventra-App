package models

import "time"

type Item struct {
	ID               string    `gorm:"primaryKey;type:char(36)" json:"id"`
	Code             string    `gorm:"not null" json:"item_code"`
	Name             string    `gorm:"not null" json:"item_name"`
	CompanyTIN       string    `gorm:"not null" json:"company_tin"`
	Company          Company   `gorm:"foreignKey:CompanyTIN;references:TIN" json:"-"`
	Description      string    `json:"item_description"`
	Price            float64   `json:"price"`
	Amount           float64   `json:"amount"`
	Quantity         int       `json:"quantity"`
	ItemCategory     string    `json:"item_category"`
	IsTaxable        bool      `json:"is_taxable"`
	IsTaxInclusive   bool      `json:"is_tax_inclusive"`
	TourismCSTOption string    `json:"tourism_cst_option"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

