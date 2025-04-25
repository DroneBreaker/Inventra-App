package utils

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var jwtKey = []byte("secret_key_inventra") // Load this from env in prod

func GenerateJWT(userID string, companyTIN string) (string, error) {
	claims := jwt.MapClaims{
		"user_id":    userID,
		"companyTIN": companyTIN,
		"exp":        time.Now().Add(2 * time.Hour).Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtKey)
}
