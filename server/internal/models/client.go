package models

import "time"

type Client struct {
	ID          string     `gorm:"primaryKey;type:char(36)"`
	ClientName  string     `gorm:"unique;not null" json:"client_name"`
	ClientTIN   string     `gorm:"unique;not null" json:"client_tin"`
	ClientEmail string     `json:"client_email"`
	CompanyTIN  string     `json:"company_tin"`
	ClientType  ClientType `json:"client_type"`
	ClientPhone string     `json:"client_phone"`
	Company     Company    `gorm:"foreignKey:CompanyTIN;references:TIN" json:"-"`
	CreatedAt   time.Time  `json:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at"`
}

type ClientType string

const (
	Customer ClientType = "Customer"
	Supplier ClientType = "Supplier"
	Export   ClientType = "Export"
)
