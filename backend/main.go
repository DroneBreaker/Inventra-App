package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/handlers"
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/DroneBreaker/Inventra-App/middlewares"

	// "github.com/labstack/echo/middleware"
	// "github.com/labstack/echo/middleware"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func main() {
	// Database Connection (Fixed MySQL DSN format)
	dsn := "root:DroneBreaker55@tcp(localhost:3306)/inventra?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// AutoMigrate all models
	err = db.AutoMigrate(
		&models.Company{},
		&models.User{},
		&models.Item{},
		&models.Client{},
		&models.Invoice{},
	)
	if err != nil {
		log.Fatal("Database migration failed:", err)
	}

	// // 2. Then add the foreign key columns if they don't exist
	// if !db.Migrator().HasConstraint(&models.User{}, "Company") {
	// 	err = db.Migrator().CreateConstraint(&models.User{}, "Company")
	// 	if err != nil {
	// 		log.Println("Warning: Couldn't create user-company constraint:", err)
	// 	}
	// }

	// if !db.Migrator().HasConstraint(&models.Item{}, "Company") {
	// 	err = db.Migrator().CreateConstraint(&models.Item{}, "Company")
	// 	if err != nil {
	// 		log.Println("Warning: Couldn't create item-company constraint:", err)
	// 	}
	// }

	// Echo instance
	e := echo.New()

	// CORS Configuration (improved)
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPost, http.MethodPut, http.MethodDelete, http.MethodOptions},
		AllowHeaders: []string{echo.HeaderContentType, echo.HeaderAuthorization},
	}))

	// Initialize repositories
	userRepo := repository.NewUserRepository(db)
	itemRepo := repository.NewItemRepository(db)
	businessPartnerRepo := repository.NewBusinessPartnerRepository(db)

	// Initialize services
	userService := services.NewUserService(userRepo)
	itemService := services.NewItemService(itemRepo)
	clientService := services.NewBusinessPartnerService(businessPartnerRepo)

	// Initialize handlers
	userHandler := handlers.NewUserHandler(userService)
	itemHandler := handlers.NewItemHandler(itemService)       // Fixed typo (was itemHandler)
	clientHandler := handlers.NewClientHandler(clientService) // Fixed naming

	// Middlewares
	// e.Use(middlewares.AuthMiddleware) // Your custom auth middleware

	// Routes
	api := e.Group("/api/v1") //Apply middleware to all routes except login and register

	// Public Routes
	api.POST("/register", userHandler.Register)
	api.POST("/login", userHandler.Login)

	// Protected routes with middleware
	protected := api.Group("")
	protected.Use(middlewares.AuthMiddleware)

	// User routes
	protected.GET("/users", userHandler.GetAll)
	protected.DELETE("/users/:id", userHandler.Delete)

	// Item routes
	protected.GET("/items", itemHandler.GetAll)
	protected.POST("/items", itemHandler.Create)
	protected.GET("/items/:id", itemHandler.GetByID)

	// Client routes
	protected.GET("/clients", clientHandler.GetAll)
	protected.POST("/clients", clientHandler.Create)

	// Welcome endpoint
	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Welcome to Inventra API",
			"version": "1.0",
		})
	})

	// Start server
	fmt.Println("INVENTRA API listening on https://127.0.0.1:1323")
	if err := e.Start(":1323"); err != nil && err != http.ErrServerClosed {
		fmt.Println("Echo error:", err)
	}
}
