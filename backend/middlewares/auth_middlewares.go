package middlewares

import (
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
)

func AuthMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		// Skip auth for login and register routes
		if c.Path() == "/login" || c.Path() == "/register" {
			return next(c)
		}

		// Get the token from the header
		tokenString := c.Request().Header.Get("Authorization")
		if tokenString == "" {
			return echo.NewHTTPError(http.StatusUnauthorized, "missing authorization header")
		}

		// Remove bearer prefix if present
		tokenString = strings.TrimPrefix(tokenString, "Bearer ")

		// Parse the token
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return []byte("secret_key_inventra"), nil
		})
		if err != nil || !token.Valid {
			return echo.NewHTTPError(http.StatusUnauthorized, "user not authenticated")
		}

		// Extract businessPartnerTIN and store it in ctx
		claims := token.Claims.(jwt.MapClaims)
		businessPartnerTIN, ok := claims["businessPartnerTIN"].(string)
		if !ok || businessPartnerTIN == "" {
			return echo.NewHTTPError(http.StatusUnauthorized, "invalid token")
		}

		//  Stroe in ctx for handlers to use
		c.Set("businessPartnerTIN", businessPartnerTIN)

		return next(c)
	}
}
