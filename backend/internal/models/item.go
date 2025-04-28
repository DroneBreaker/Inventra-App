package models

import (
	"time"

	"gorm.io/gorm"
)

// type Item struct {
// 	ID               uint           `gorm:"primaryKey;autoIncrement" json:"id" xml:"id"`
// 	ItemCode         int            `gorm:"not null;index" json:"itemCode" xml:"itemCode"`
// 	ItemName         string         `gorm:"size:100;not null" json:"itemName" xml:"itemName"`
// 	Price            int            `gorm:"type:decimal(20,2)" json:"price" xml:"price"`
// 	IsTaxInclusive   bool           `gorm:"default:false" json:"isTaxInclusive" xml:"isTaxInclusive"`
// 	ItemDescription  string         `gorm:"type:text" json:"itemDescription" xml:"itemDescription"`
// 	IsTaxable        bool           `gorm:"default:true" json:"isTaxable" xml:"isTaxable"`
// 	TourismCstOption string         `gorm:"size:50" json:"tourismCSTOption" xml:"tourismCSTOption"`
// 	ItemCategory     string         `gorm:"size:50;index" json:"itemCategory" xml:"itemCategory"`
// 	IsDiscountable   bool           `gorm:"default:true" json:"isDiscountable" xml:"isDiscountable"`
// 	CompanyID        string         `gorm:"type:char(6);not null" json:"companyID" xml:"companyID"`
// 	Company          Company        `gorm:"foreignKey:CompanyID;references:CompanyID;constraint:OnUpdate:CASCADE,OnDelete:RESTRICT"`
// 	InvoiceID        uint           `gorm:"index" json:"invoiceID" xml:"invoiceID"`
// 	CreatedAt        time.Time      `gorm:"autoCreateTime" json:"createdAt" xml:"createdAt"`
// 	DeletedAt        gorm.DeletedAt `gorm:"index" json:"-" xml:"-"`
// 	UpdatedAt        time.Time      `gorm:"autoUpdateTime" json:"updatedAt" xml:"updatedAt"`
// }

type Item struct {
	ID               uint    `gorm:"primaryKey"`
	ItemCode         int     `gorm:"not null;index" json:"itemCode" xml:"itemCode"`
	ItemName         string  `gorm:"size:100;not null" json:"itemName" xml:"itemName"`
	UnitPrice        float64 `gorm:"type:decimal(20,2)" json:"price" xml:"price"`
	IsTaxInclusive   bool    `gorm:"default:false" json:"isTaxInclusive" xml:"isTaxInclusive"`
	ItemDescription  string  `gorm:"type:text" json:"itemDescription" xml:"itemDescription"`
	IsTaxable        bool    `gorm:"default:true" json:"isTaxable" xml:"isTaxable"`
	TourismCstOption string  `gorm:"size:50" json:"tourismCSTOption" xml:"tourismCSTOption"` // None, Tourism, CST
	ItemCategory     string  `gorm:"size:50;index" json:"itemCategory" xml:"itemCategory"`   // Standard, CST, TRSM, Exempt
	IsDiscountable   bool    `gorm:"default:true" json:"isDiscountable" xml:"isDiscountable"`
	// InvoiceID  uint
	// Invoice    Invoice   `gorm:"foreignKey:InvoiceID"`
	CompanyTIN string  `gorm:"type:char(20);not null" json:"companyTIN" xml:"companyTIN"`
	Company    Company `gorm:"foreignKey:CompanyTIN;references:TIN"`
	CreatedAt  time.Time
	UpdatedAt  time.Time
	DeletedAt  gorm.DeletedAt `gorm:"index" json:"-" xml:"-"`
}
