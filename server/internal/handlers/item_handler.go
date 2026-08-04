package handlers

import (
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/middleware"
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

type ItemHandler struct {
	Service *services.ItemService
}

func NewItemHandler(s *services.ItemService) *ItemHandler {
	return &ItemHandler{Service: s}
}

func (h *ItemHandler) GetItems(c *gin.Context) {
	companyTIN, err := middleware.GetCompanyTIN(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	items, err := h.Service.GetItems(companyTIN)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, items)
}

func (h *ItemHandler) CreateItem(c *gin.Context) {
	var item models.Item

	if err := c.ShouldBindJSON(&item); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Could not bind item data",
			"details": err.Error(),
			"success": false,
		})
		return
	}

	companyTIN, err := middleware.GetCompanyTIN(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error":   "Unauthorized",
			"success": false,
		})
		return
	}
	item.CompanyTIN = companyTIN

	if err := h.Service.CreateItem(&item); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Could not add item",
			"details": err.Error(),
			"success": false,
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Item created successfully",
		"item":    item,
	})
}
