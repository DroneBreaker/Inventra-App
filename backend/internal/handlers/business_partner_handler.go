package handlers

import (
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/labstack/echo/v4"
)

type businessPartnerHandler struct {
	service services.BusinessPartnerService
}

func NewBusinessPartnerService(service services.BusinessPartnerService) *businessPartnerHandler {
	return &businessPartnerHandler{service: service}
}

func (h *businessPartnerHandler) GetAll(c echo.Context) error {
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

	businessPartners, err := h.service.GetAll(user.BusinessTIN)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, businessPartners)
}

func (h *businessPartnerHandler) Create(c echo.Context) error {
	businessPartner := new(models.BusinessPartner)
	if err := c.Bind(businessPartner); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}

	if err := h.service.Create(businessPartner, businessPartner.BusinessPartnerTIN); err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusCreated, businessPartner)
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
