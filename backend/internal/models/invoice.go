package models

import (
	"time"
)

// type Invoice struct {
// 	gorm.Model
// 	BusinessPartnerTIN BusinessPartner `gorm:"foreignKey:BusinessPartnerTIN" json:"businessPartnerTIN" xml:"businessPartnerTIN"`
// 	InvoiceNumber      string          `gorm:"unigue;not null" json:"invoiceNumber" xml:"invoiceNumber"`
// 	InvoiceDate        time.Time       `gorm:"not null" json:"invoiceDate" xml:"invoiceDate"`
// 	DueDate            time.Time       `json:"dueDate" xml:"dueDate"`
// 	Currency           string          `gorm:"not null" json:"currency" xml:"currency"`
// 	Status             string          `json:"status" xml:"status"`
// 	TotalAmount        float64         `json:"totalAmount" xml:"totalAmount"`
// 	Remarks            string          `json:"remarks" xml:"remarks"`
// 	Items              []Item          `json:"items" gorm:"foreignKey:InvoiceID"`
// 	CompanyID          string          `gorm:"type:char(6);primaryKey" json:"companyID" xml:"companyID"`
// 	Company            Company         `gorm:"foreignKey:CompanyID"`
// }

type Invoice struct {
	ID            uint   `gorm:"primaryKey"`
	InvoiceNumber string `gorm:"unigue;not null" json:"invoiceNumber" xml:"invoiceNumber"`
	ClientID      string `gorm:"type:char(6);not null" json:"clientID" xml:"clientID"`
	Client        Client `gorm:"foreignKey:ClientID;references:ID"`
	// ClientName  string
	// ClientEmail string
	Status      string  // pending, paid, cancelled, etc.
	TotalAmount float64 `json:"totalAmount" xml:"totalAmount"`
	InvoiceDate time.Time
	DueDate     time.Time
	Remarks     string `json:"remarks" xml:"remarks"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}
