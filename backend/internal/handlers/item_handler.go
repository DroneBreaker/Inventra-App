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

func NewItemHandler(service services.ItemService) *itemHandler {
	return &itemHandler{service: service}
}

func (h *itemHandler) GetAll(c echo.Context) error {
	// Get businessPartnerTIN from ctx
	clientTINInterface := c.Get("clientTIN")

	// Safely check if user exists in context
	// businessPartnerTINInterface := c.Get("businessPartnerTIN")
	if clientTINInterface == nil {
		return c.JSON(http.StatusUnauthorized, map[string]string{
			"error": "user not authenticated - missing business partner TIN",
		})
	}

	// Safely perform type assertion
	clientTIN, ok := clientTINInterface.(string)
	if !ok {
		return c.JSON(http.StatusInternalServerError, map[string]string{
			"error": "invalid business partner TIN type in context",
		})
	}

	// Get businessTIN from authenticated user
	// businessTIN := c.Get("user").(models.User).BusinessTIN

	items, err := h.service.GetAll(clientTIN)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, items)
}

func (h *itemHandler) Create(c echo.Context) error {
	// Get businessPartnerTIN from ctx
	clientTIN := c.Get("clientTIN").(string)

	item := new(models.Item)
	if err := c.Bind(item); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	item.Company.TIN = clientTIN

	if err := h.service.Create(item, clientTIN); err != nil {
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

	item, err := h.service.GetByID(string(id))
	if err != nil {
		return c.JSON(http.StatusNotFound, err.Error())
	}
	return c.JSON(http.StatusOK, item)
}

// func (h *itemHandler) Update(c echo.Context) error {
// 	// Get businessPartnerTIN from ctx
// 	businessPartnerTIN := c.Get("businessPartnerTIN").(string)

// 	id, err := strconv.Atoi(c.Param("id"))
// 	if err != nil {
// 		return c.JSON(http.StatusBadRequest, err.Error())
// 	}

// 	existingItem, err := h.service.GetByID(id, businessPartnerTIN)
// 	if err != nil {
// 		return echo.NewHTTPError(http.StatusNotFound, "item not found")
// 	}

// 	if existingItem.BusinessPartnerTIN != businessPartnerTIN {
// 		return echo.NewHTTPError(http.StatusForbidden, "you don't have permission to update the item")
// 	}

// 	updatedItem.ID = id
// 	updatedItem.BusinessPartnerTIN = businessPartnerTIN

// 	// Update the item
// 	if err := h.service.Update(updatedItem.ID, uo); err != nil {
// 		return echo.NewHTTPError(http.StatusInternalServerError, "failed to update item")
// 	}

// 	// businessTIN := c.Get("user").(models.User).BusinessTIN

// 	// item, err := h.service.GetByID(id, c.Param("businessTIN"))
// 	// if err != nil {
// 	// 	return c.JSON(http.StatusNotFound, err.Error())
// 	// }
// 	return c.JSON(http.StatusOK, updatedItem)
// }

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
