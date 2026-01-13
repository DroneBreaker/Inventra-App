package middleware

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

const (
	HeaderCompanyTIN  = "X-Company-TIN"
	ContextCompanyTIN = "company_tin"
)

// CompanyScopeMiddleware ensures that a Company TIN is present in the request
// either via Header or JWT (claims extraction logic to be enhanced if needed)
func CompanyScopeMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1. Check Header first (Client usually sends this)
		tin := c.GetHeader(HeaderCompanyTIN)

		// 2. If not in header, check if it was extracted from Token by AuthMiddleware
		// (Assuming AuthMiddleware runs before this and sets keys in context)
		if tin == "" {
			if val, exists := c.Get("company_tin"); exists {
				tin = val.(string)
			}
		}

		if tin == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Missing Company Context (TIN)"})
			c.Abort()
			return
		}

		// 3. Set it in context for Handlers/Services to use
		c.Set(ContextCompanyTIN, tin)
		c.Next()
	}
}

// Helper to get TIN from context safely
func GetCompanyTIN(c *gin.Context) (string, error) {
	val, exists := c.Get(ContextCompanyTIN)
	if !exists {
		return "", fmt.Errorf("company_tin not found in context")
	}
	return val.(string), nil
}
