package models

import "time"

type Invoice struct {
	ID                  string `gorm:"primaryKey;type:char(36)"`
	InvoiceNumber       string `json:"invoiceNumber"`
	Username            string `json:"username"`
	BusinessPartnerName string
	BusinessPartnerTIN  string          `json:"businessPartnerTIN"`
	BusinessPartner     Client          `gorm:"foreignKey:BusinessPartnerTIN;references:ClientTIN" json:"-"`
	InvoiceType         InvoiceType     `json:"flag"`
	CalculationType     CalculationType `json:"calculationType"`
	InvoiceDate         time.Time       `json:"invoiceDate"`
	InvoiceTime         time.Time
	DueDate             time.Time
	TotalVAT            float64 `json:"totalVAT"`
	TotalAmount         float64 `json:"totalAmount"`
	CompanyTIN          string
	Company             Company       `gorm:"foreignKey:CompanyTIN;references:TIN" json:"-"`
	InvoiceItems        []InvoiceItem `gorm:"foreignKey:InvoiceID;references:ID"`
}

type InvoiceItem struct {
	ID          string `gorm:"primaryKey;type:char(36)"`
	InvoiceID   string `gorm:"type:char(36)"`
	ItemID      string `gorm:"type:char(36)"`
	Description string
	Quantity    float64
	UnitPrice   float64
	Total       float64
}

type InvoiceType string

const (
	SalesInvoice InvoiceType = "Invoice"
	Purchase     InvoiceType = "Purchase"
	Refund       InvoiceType = "Refund"
	CreditNote   InvoiceType = "Credit Note"
	DebitNote    InvoiceType = "Debit Note"
	// PurchaseReturn
)

type CalculationType string

const (
	Inclusive CalculationType = "INCLUSIVE"
	Exclusive CalculationType = "EXCLUSIVE"
)
