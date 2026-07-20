package routes

import (
	"github.com/DroneBreaker/Inventra-App/internal/database"
	"github.com/DroneBreaker/Inventra-App/internal/handlers"
	"github.com/DroneBreaker/Inventra-App/internal/middleware"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

func ClientRoutes(r *gin.Engine) {
	db := database.GetDB()

	clientService := services.NewClientService(db)
	clientHandler := handlers.NewClientHandler(clientService)

	// r.Group("/api/clients")
	// r.POST("/", clientHandler.CreateClient)

	clients := r.Group("/api/clients")
	clients.Use(middleware.AuthMiddleware())
	clients.Use(middleware.CompanyScopeMiddleware())
	{
		clients.POST("", clientHandler.CreateClient)
		clients.GET("/", clientHandler.GetAllClients)
		clients.GET("", clientHandler.SearchClients)
		// users.PATCH("/:id", userHandler.UpdateUser)
		// users.DELETE("/:id", userHandler.DeleteUser)
	}
}
