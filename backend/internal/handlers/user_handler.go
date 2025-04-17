package handlers

import (
	"strconv"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"

	"net/http"

	"github.com/labstack/echo/v4"
)

type UserHandler struct {
	service services.UserService
}

func NewUserHandler(service services.UserService) *UserHandler {
	return &UserHandler{service: service}
}

func (h *UserHandler) Register(c echo.Context) error {
	var user models.User
	if err := c.Bind(&user); err != nil {
		return c.JSON(http.StatusBadRequest, echo.Map{"error": "invalid input"})
	}

	if err := h.service.Register(&user); err != nil {
		return c.JSON(http.StatusBadRequest, echo.Map{"error": err.Error()})
	}

	return c.JSON(http.StatusCreated, echo.Map{
		"message": "user registered",
		"user":    user,
	})
}

func (h *UserHandler) Login(c echo.Context) error {
	var input struct {
		Username    string `json:"username"`
		Email       string `json:"email"`
		BusinessTIN string `json:"businessTIN"`
		Password    string `json:"password"`
	}

	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, echo.Map{"error": "invalid input"})
	}

	user, err := h.service.Login(input.Username, input.Email, input.BusinessTIN, input.Password)
	if err != nil {
		return c.JSON(http.StatusUnauthorized, echo.Map{"error": err.Error()})
	}

	return c.JSON(http.StatusOK, user)
}

func (h *UserHandler) Delete(c echo.Context) error {
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
