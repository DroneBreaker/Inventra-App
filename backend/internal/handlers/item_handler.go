package handlers

import (
	"net/http"
	"strconv"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/labstack/echo/v4"
)

type itemHandler struct {
	service services.ItemService
}

func NewitemHandler(service services.ItemService) *itemHandler {
	return &itemHandler{service: service}
}

func (h *itemHandler) GetAll(c echo.Context) error {
	// Safely check if user exists in context
	userInterface := c.Get("user")
	if userInterface == nil {
		return c.JSON(http.StatusUnauthorized, map[string]string{
			"error": "user not authenticated",
		})
	}

	// Safely perform type assertion
	user, ok := userInterface.(models.User)
	if !ok {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": "invalid user type in context",
		})
	}

	// Get businessTIN from authenticated user
	// businessTIN := c.Get("user").(models.User).BusinessTIN

	items, err := h.service.GetAll(user.BusinessTIN)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, items)
}

func (h *itemHandler) Create(c echo.Context) error {
	item := new(models.Item)
	if err := c.Bind(item); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	// businessTIN := c.Get("user").(models.User).BusinessTIN

	if err := h.service.Create(item, c.Param("businessTIN")); err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusCreated, item)
}

func (h *itemHandler) GetByID(c echo.Context) error {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	// businessTIN := c.Get("user").(models.User).BusinessTIN

	item, err := h.service.GetByID(id, c.Param("businessTIN"))
	if err != nil {
		return c.JSON(http.StatusNotFound, err.Error())
	}
	return c.JSON(http.StatusOK, item)
}

// func (h *itemHandler) GetByItemName(c echo.Context) error {
// 	itemName, err := strconv.Atoi(c.Param("itemName"))
// 	if err != nil {
// 		return c.JSON(http.StatusBadRequest, err.Error())
// 	}

// 	// businessTIN := c.Get("user").(models.User).BusinessTIN

// 	item, err := h.service.GetByItemName(itemName, c.Param("businessTIN"))
// 	if err != nil {
// 		return c.JSON(http.StatusNotFound, err.Error())
// 	}
// 	return c.JSON(http.StatusOK, item)
// }
