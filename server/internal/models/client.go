package models

type Clients struct {
	ID          string `gorm:"primaryKey;type:char(36)"`
	ClientName  string `gorm:"unigue;not null;json:client_name"`
	ClientTIN   string `gorm:"unique;not null"`
	clientEmail string
	CompanyTIN  string     `gorm:"foreignKey"`
	ClientType  ClientType `gorm:"json:client_type"`
	ClientPhone int16
}

type ClientType string

const (
	Customer ClientType = "Customer"
	Supplier ClientType = "Supplier"
	Export   ClientType = "Export"
)
