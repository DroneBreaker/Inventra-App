package routes

import (
	"github.com/DroneBreaker/Inventra-App/internal/database"
	"github.com/DroneBreaker/Inventra-App/internal/handlers"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

func LoginRoutes(r *gin.Engine) {
	db := database.GetDB()

	authService := services.NewAuthService(db)
	authHandler := handlers.NewAuthHandler(authService)

	r.POST("/api/user_account/login", authHandler.Login)
}
