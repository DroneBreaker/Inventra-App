package models

import (
	"database/sql"
	"time"
)

type User struct {
	ID          uint         `gorm:"primaryKey" json:"id" xml:"id"`
	Name        string       `json:"name" xml:"name"`
	Username    string       `gorm:"unique;not null" json:"username" validate:"required,min=6" xml:"username"`
	Email       string       `json:"email" xml:"email"`
	BusinessTIN string       `gorm:"unique;not null" json:"businessTIN" validate:"required,businessTIN" xml:"businessTIN"`
	Password    string       `json:"-,omitempty" validate:"required,min=6" xml:"-"`
	Role        string       `json:"role" xml:"role"`
	CreatedAt   sql.NullTime `json:"created_at" xml:"created_at"`
	UpdatedAt   time.Time    `json:"updated_at" xml:"updated_at"`
}
