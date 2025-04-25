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
		&models.BusinessPartner{},
		&models.Invoice{},
	)
	if err != nil {
		log.Fatal("Database migration failed:", err)
	}

	// 2. Then add the foreign key columns if they don't exist
	if !db.Migrator().HasConstraint(&models.User{}, "Company") {
		err = db.Migrator().CreateConstraint(&models.User{}, "Company")
		if err != nil {
			log.Println("Warning: Couldn't create user-company constraint:", err)
		}
	}

	if !db.Migrator().HasConstraint(&models.Item{}, "Company") {
		err = db.Migrator().CreateConstraint(&models.Item{}, "Company")
		if err != nil {
			log.Println("Warning: Couldn't create item-company constraint:", err)
		}
	}

	// Echo instance
	e := echo.New()

	// Middlewares
	e.Use(middlewares.AuthMiddleware) // Your custom auth middleware

	// Initialize repositories
	userRepo := repository.NewUserRepository(db)
	itemRepo := repository.NewItemRepository(db)
	businessPartnerRepo := repository.NewBusinessPartnerRepository(db)

	// Initialize services
	userService := services.NewUserService(userRepo)
	itemService := services.NewItemService(itemRepo)
	businessPartnerService := services.NewBusinessPartnerService(businessPartnerRepo)

	// Initialize handlers
	userHandler := handlers.NewUserHandler(userService)
	itemHandler := handlers.NewItemHandler(itemService)                                  // Fixed typo (was itemHandler)
	businessPartnerHandler := handlers.NewBusinessPartnerHandler(businessPartnerService) // Fixed naming

	// Routes
	api := e.Group("/api/v1")

	// User routes
	api.POST("/register", userHandler.Register)
	api.POST("/login", userHandler.Login)
	api.GET("/users", userHandler.GetAll)
	api.DELETE("/users/:id", userHandler.Delete)

	// Item routes
	api.GET("/items", itemHandler.GetAll)
	api.POST("/items", itemHandler.Create)
	api.GET("/items/:id", itemHandler.GetByID)

	// Business Partner routes
	api.GET("/business_partners", businessPartnerHandler.GetAll)
	api.POST("/business_partners", businessPartnerHandler.Create)

	// Welcome endpoint
	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Welcome to Inventra API",
			"version": "1.0",
		})
	})

	// CORS Configuration (improved)
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPost, http.MethodPut, http.MethodDelete, http.MethodOptions},
		AllowHeaders: []string{echo.HeaderContentType, echo.HeaderAuthorization},
	}))

	// Start server
	fmt.Println("INVENTRA API listening on https://127.0.0.1:1323")
	if err := e.Start(":1323"); err != nil && err != http.ErrServerClosed {
		fmt.Println("Echo error:", err)
	}
}
