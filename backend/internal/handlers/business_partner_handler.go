package handlers

import (
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/labstack/echo/v4"
)

type clientHandler struct {
	service services.BusinessPartnerService
}

func NewClientHandler(service services.BusinessPartnerService) *clientHandler {
	return &clientHandler{service: service}
}

func (h *clientHandler) GetAll(c echo.Context) error {
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

	businessPartners, err := h.service.GetAll(user.CompanyID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, businessPartners)
}

func (h *clientHandler) Create(c echo.Context) error {
	client := new(models.Client)
	if err := c.Bind(client); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	if err := h.service.Create(client, client.ClienTIN); err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusCreated, client)
}

// func (h *businessPartnerHandler) GetByID(c echo.Context) error {
// 	id, err := strconv.Atoi(c.Param("id"))
// 	if err != nil {
// 		return c.JSON(http.StatusBadRequest, err.Error())
// 	}

// 	businessPartner, err := h.service.GetByID(id)
// 	if err != nil {
// 		return c.JSON(http.StatusNotFound, err.Error())
// 	}
// 	return c.JSON(http.StatusOK, businessPartner)
// }
