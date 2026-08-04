package models

import "time"

type Item struct {
	ID          string  `gorm:"primaryKey;type:char(36)" json:"id"`
	Code        string  `gorm:"column:item_code;not null" json:"item_code"`
	Name        string  `gorm:"column:item_name;not null" json:"item_name"`
	CompanyTIN  string  `gorm:"not null" json:"company_tin"`
	Company     Company `gorm:"foreignKey:CompanyTIN;references:TIN" json:"-"`
	Description string  `gorm:"column:item_description;" json:"item_description"`
	Price       float64 `gorm:"column:price" json:"price"`
	// Amount           float64   `gorm:"column:amount" json:"amount"`
	// Quantity         int       `gorm:"column:quantity" json:"quantity"`
	ItemCategory     string    `gorm:"column:item_category" json:"item_category"`
	IsTaxable        bool      `gorm:"column:is_taxable" json:"is_taxable"`
	IsTaxInclusive   bool      `gorm:"column:is_tax_inclusive" json:"is_tax_inclusive"`
	TourismCSTOption string    `gorm:"column:tourism_cst_option" json:"tourism_cst_option"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}
