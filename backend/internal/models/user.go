package models

import (
	"time"

	"gorm.io/gorm"
)

// type User struct {
// 	FirstName          string         `gorm:"size:100;not null" json:"firstName" xml:"firstName"`
// 	LastName           string         `gorm:"size:100;not null" json:"lastName" xml:"lastName"`
// 	Username           string         `gorm:"size:100;unique" json:"username" xml:"username"`
// 	Email              string         `gorm:"unique;not null;index" json:"email" xml:"email"`
// 	BusinessPartnerTIN string         `gorm:"unique;not null;size:20" json:"businessPartnerTIN" xml:"businessPartnerTIN"`
// 	Password           string         `gorm:"not null" json:"-" xml:"-"` // Excluded from JSON/XML for security
// 	Role               string         `gorm:"size:50;default:'user'" json:"role" xml:"role"`
// 	CompanyID          string         `gorm:"type:char(6);primaryKey" json:"companyID" xml:"companyID"`
// 	Company            Company        `gorm:"foreignKey:CompanyID;references:CompanyID;constraint:OnUpdate:CASCADE,OnDelete:RESTRICT"`
// 	CreatedAt          time.Time      `gorm:"autoCreateTime" json:"createdAt" xml:"createdAt"`
// 	UpdatedAt          time.Time      `gorm:"autoUpdateTime" json:"updatedAt" xml:"updatedAt"`
// 	DeletedAt          gorm.DeletedAt `gorm:"index" json:"-" xml:"-"` // Soft delete
// }

type User struct {
	ID        uint           `gorm:"primaryKey;autoIncrement" json:"id" xml:"id"`
	FirstName string         `gorm:"size:100;not null"`
	LastName  string         `gorm:"size:100;not null" json:"lastName" xml:"lastName"`
	Email     string         `gorm:"unique;not null;index" json:"email" xml:"email"`
	Username  string         `gorm:"size:100;unique" json:"username" xml:"username"`
	Password  string         `gorm:"not null" json:"-" xml:"-"`
	Role      string         `gorm:"size:50;default:'user'" json:"role" xml:"role"`
	CompanyID string         `gorm:"type:char(6);not null" json:"companyID" xml:"companyID"`
	Company   Company        `gorm:"foreignKey:CompanyID;references:ID"`
	CreatedAt time.Time      `gorm:"autoCreateTime" json:"createdAt" xml:"createdAt"`
	UpdatedAt time.Time      `gorm:"autoUpdateTime" json:"updatedAt" xml:"updatedAt"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-" xml:"-"`
}
