package routes

import (
	"github.com/DroneBreaker/Inventra-App/internal/database"
	"github.com/DroneBreaker/Inventra-App/internal/handlers"
	"github.com/DroneBreaker/Inventra-App/internal/middleware"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

func ItemRoutes(r *gin.Engine) {
	db := database.GetDB()

	itemService := services.NewItemService(db)
	itemHandler := handlers.NewItemHandler(itemService)

	items := r.Group("/api/items")
	items.Use(middleware.AuthMiddleware())
	items.Use(middleware.CompanyScopeMiddleware())
	{
		items.GET("", itemHandler.GetItems)
		items.POST("/", itemHandler.CreateItem)
	}
}
