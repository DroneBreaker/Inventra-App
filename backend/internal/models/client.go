package models

import "time"

// type BusinessPartner struct {
// 	ID                  int       `json:"id" xml:"id"`
// 	Name                string    `json:"name" xml:"name"`
// 	BusinessPartnerTIN  string    `json:"businessPartnerTIN" xml:"businessPartnerTIN"`
// 	Email               string    `json:"email" xml:"email"`
// 	BusinessPartnerType string    `json:"businessPartnerType" xml:"businessPartnerType"`
// 	Contact             int       `json:"contact" xml:"contact"`
// 	CreatedAt           time.Time `json:"createdAt" xml:"createdAt"`
// }

type Client struct {
	ID         uint   `gorm:"primaryKey"`
	Name       string `gorm:"not null; unique" json:"clientName" xml:"clientName"`
	ClienTIN   string `gorm:"not null; unique" json:"clientTIN" xml:"clientTIN"`
	Email      string
	Phone      string
	CompanyID  string    `gorm:"type:char(6);not null" json:"companyID" xml:"companyID"`
	Company    Company   `gorm:"foreignKey:CompanyID;references:ID"`
	ClientType string    `json:"clientType" xml:"clientType"` // customer, supllier, export
	Invoices   []Invoice `gorm:"foreignKey:ClientID;references:ID" json:"invoices"`
	CreatedAt  time.Time `json:"createdAt" xml:"createdAt"`
	UpdatedAt  time.Time `json:"updatedAt" xml:"updatedAt"`
}
