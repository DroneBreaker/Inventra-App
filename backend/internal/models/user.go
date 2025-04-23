package models

import (
	"database/sql"
	"time"
)

// type User struct {
// 	ID                 uint         `gorm:"primaryKey" json:"id" xml:"id"`
// 	FirstName          string       `gorm:"firstName" json:"firstName" xml:"firstName"`
// 	LastName           string       `gorm:"firstName" json:"LastName" xml:"LastName"`
// 	Username           string       `gorm:"unique;not null" json:"username" validate:"required,min=6" xml:"username"`
// 	Email              string       `json:"email" xml:"email"`
// 	BusinessPartnerTIN string       `gorm:"unique;not null" json:"businessTIN" validate:"required,businessTIN" xml:"businessTIN"`
// 	Password           string       `json:"-,omitempty" validate:"required,min=6" xml:"-"`
// 	Role               string       `json:"role" xml:"role"`
// 	CreatedAt          sql.NullTime `json:"created_at" xml:"created_at"`
// 	UpdatedAt          time.Time    `json:"updated_at" xml:"updated_at"`
// }

type User struct {
	ID                 uint         `gorm:"primaryKey" json:"id" xml:"id"`
	FirstName          string       `gorm:"not null;size:100" json:"firstName" xml:"firstName"`
	LastName           string       `gorm:"not null;size:100" json:"lastName" xml:"lastName"`
	Username           string       `json:"username" xml:"username"`
	Email              string       `gorm:"unique;not null;index" json:"email" xml:"email"`
	BusinessPartnerTIN string       `gorm:"unique;not null" json:"businessPartnerTIN" xml:"businessPartnerTIN"`
	Password           string       `json:"password" validate:"required,min=6,max=64" xml:"password"`
	Role               string       `json:"role" xml:"role"`
	CreatedAt          sql.NullTime `json:"createdAt" xml:"createdAt"`
	UpdatedAt          time.Time    `json:"updatedAt" xml:"UpdatedAt"`
}
