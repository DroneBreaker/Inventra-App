package models

import (
	"database/sql"
	"time"
)

type User struct {
	ID                 uint         `gorm:"primaryKey" json:"id" xml:"id"`
	FirstName          string       `json:"firstName" xml:"firstName"`
	LastName           string       `json:"lastName" xml:"lastName"`
	Username           string       `json:"username" xml:"username"`
	Email              string       `json:"email" xml:"email"`
	BusinessPartnerTIN string       `gorm:"unique;not null" json:"businessPartnerTIN" xml:"businessPartnerTIN"`
	Password           string       `json:"password",omitempty" validate:"required,min=6" xml:"password"`
	Role               string       `json:"role" xml:"role"`
	CreatedAt          sql.NullTime `json:"createdAt" xml:"createdAt"`
	UpdatedAt          time.Time    `json:"updatedAt" xml:"UpdatedAt"`
}
