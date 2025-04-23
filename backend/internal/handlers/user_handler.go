package handlers

import (
	"fmt"
	"strconv"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/DroneBreaker/Inventra-App/utils"

	"net/http"

	"github.com/labstack/echo/v4"
)

type userHandler struct {
	service services.UserService
}

func NewUserHandler(service services.UserService) *userHandler {
	return &userHandler{service: service}
}

func (h *userHandler) GetAll(c echo.Context) error {
	users, err := h.service.GetAll()
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, users)
}

func (h *userHandler) Register(c echo.Context) error {
	var user models.User
	if err := c.Bind(&user); err != nil {
		return c.JSON(http.StatusBadRequest, echo.Map{"error": "invalid input"})
	}

	if err := h.service.Create(&user); err != nil {
		return c.JSON(http.StatusBadRequest, echo.Map{"error": err.Error()})
	}

	return c.JSON(http.StatusCreated, echo.Map{
		"message": "user registered",
		"user":    user,
	})
}

func (h *userHandler) Login(c echo.Context) error {
	var input struct {
		BusinessPartnerTIN string `json:"businessPartnerTIN"`
		Username           string `json:"username"`
		Password           string `json:"password"`
	}
	// var dbUser models.User

	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, echo.Map{"error": "invalid input"})
	}

	user, err := h.service.Login(input.Username, input.BusinessPartnerTIN, input.Password)
	if err != nil {
		return c.JSON(http.StatusUnauthorized, map[string]string{
			"error": err.Error(),
		})
	}

	// Debug print the stored hash
	fmt.Printf("Comparing with stored hash: %s\n", input.Password)

	token, err := utils.GenerateJWT(uint(user.ID))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, echo.Map{
			"error": "token generation failed",
		})
	}

	return c.JSON(http.StatusOK, echo.Map{
		"user":  user,
		"token": token,
	})
}

func (h *userHandler) Delete(c echo.Context) error {
	id, err := strconv.Atoi(c.Param("id"))

	if err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	if err := h.service.Delete(id); err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}

	return c.JSON(http.StatusOK, map[string]string{
		"message": "The user has been deleted successfully",
	})
}
