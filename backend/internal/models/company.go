package models

import "time"

// type Company struct {
// 	Name      string `gorm:"not null;unique" json:"companyName" xml:"companyName"`
// 	CompanyID string `gorm:"column:company_id;type:char(6);primaryKey;not null;unique" json:"companyID" xml:"companyID"`
// 	Address   string `gorm:"not null" json:"address" xml:"address"`
// 	TIN       string `gorm:"unique;not null" json:"companyTIN" xml:"companyTIN"`
// 	Phone     string `gorm:"not null" json:"phone" xml:"phone"`
// 	Email     string `gorm:"not null" json:"email" xml:"email"`
// Users     []User    `gorm:"foreignKey:CompanyID;references:CompanyID"`
// 	// Items     []Item    `gorm:"foreignKey:CompanyID;references:CompanyID"`
// 	// Invoices  []Invoice `gorm:"foreignKey:CompanyID;references:CompanyID"`
// 	// LogoURL     string // Optional
// 	// Website     string // Optional
// }

// // TableName overrides the table name
// func (Company) TableName() string {
// 	return "companies"
// }

type Company struct {
	ID        string `gorm:"primaryKey;type:char(6)" json:"id" xml:"id"`
	Name      string `gorm:"unique;not null" json:"companyName" xml:"companyName"`
	TIN       string `gorm:"unique;not null" json:"companyTIN" xml:"companyTIN"`
	Email     string
	Address   string
	Phone     string
	Users     []User   `gorm:"foreignKey:CompanyID;references:ID" json:"users" xml:"user"`
	Items     []Item   `gorm:"foreignKey:CompanyID;references:ID" json:"items" xml:"items"`
	Clients   []Client `gorm:"foreignKey:CompanyID;references:ID"`
	CreatedAt time.Time
	UpdatedAt time.Time
}
