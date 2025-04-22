package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/handlers"
	"github.com/DroneBreaker/Inventra-App/internal/repository"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo/v4"
)

func main() {
	//Connect the DB
	db, err := sql.Open("mysql", "root:DroneBreaker55@tcp(localhost:3306)/inventra")
	if err != nil {
		log.Fatal(err)
	}

	defer db.Close()

	// Initiate the app
	e := echo.New()

	// User Routes
	userRepo := repository.NewUserRepository(db)
	userService := services.NewUserService(userRepo)
	userHandler := handlers.NewUserHandler(userService)

	e.GET("/users", userHandler.GetAll)
	e.POST("/register", userHandler.Register)
	e.POST("/login", userHandler.Login)
	e.DELETE("/users/:id", userHandler.Delete)

	// Item Routes
	itemRepo := repository.NewItemRepository(db)
	itemService := services.NewItemService(itemRepo)
	itemHandler := handlers.NewitemHandler(&itemService)

	e.GET("/items", itemHandler.GetAll)
	e.POST("/items", itemHandler.Create)
	e.GET("/items/:id", itemHandler.GetByID)
	// e.DELETE("/users/:id", userHandler.Delete)

	// Business Partners Routes
	businessPartnerRepo := repository.NewBusinessPartnerRepository(db)
	businessPartnerService := services.NewBusinessPartnerService(businessPartnerRepo)
	businessPartnerHandler := handlers.NewBusinessPartnerService(&businessPartnerService)

	e.GET("/business_partners", businessPartnerHandler.GetAll)
	e.POST("/business_partners", businessPartnerHandler.Create)

	e.GET("/welcome", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Welcome to Inventra servers",
		})
	})

	fmt.Println("INVENTRA API listening on https://localhost:1323")
	if err := e.Start(":1323"); err != nil && err != http.ErrServerClosed {
		fmt.Println("Echo error:", err)
	}
}
