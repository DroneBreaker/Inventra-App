package routes

import (
	"github.com/DroneBreaker/Inventra-App/internal/database"
	"github.com/DroneBreaker/Inventra-App/internal/handlers"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

func UserRoutes(r *gin.Engine) {
	db := database.GetDB()

	userService := services.NewUserService(db)
	userHandler := handlers.NewUserHandler(userService)

	users := r.Group("/users")
	{
		users.POST("/", userHandler.CreateUser)
		users.GET("/", userHandler.GetUsers)
		users.GET("/:id", userHandler.GetUser)
		users.PATCH("/:id", userHandler.UpdateUser)
		users.DELETE("/:id", userHandler.DeleteUser)
	}
}
