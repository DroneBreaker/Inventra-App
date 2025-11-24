package main

import (
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/database"
	"github.com/DroneBreaker/Inventra-App/internal/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	database.Connect()
	// database.Migrate()

	r := gin.Default()

	// Routes
	routes.LoginRoutes(r)
	routes.RegisterRoutes(r)
	routes.UserRoutes(r)

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Server is up and running",
		})
	})

	// port := os.Getenv("PORT")
	// if port == "" {
	// 	port = "8080"
	// }

	// log.Println("Server running on port", port)
	r.Run()
}
