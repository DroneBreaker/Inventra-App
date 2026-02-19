package handlers

import (
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/middleware"
	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

type ClientHandler struct {
	service *services.ClientService
}

func NewClientHandler(s *services.ClientService) *ClientHandler {
	return &ClientHandler{service: s}
}

func (h *ClientHandler) CreateClient(c *gin.Context) {
	// DEBUG: Capture request body
	// bodyBytes, _ := io.ReadAll(c.Request.Body)
	// fmt.Println("DEBUG BODY:", string(bodyBytes))
	// // Restore the body so ShouldBindJSON can read it
	// c.Request.Body = io.NopCloser(bytes.NewBuffer(bodyBytes))

	var client models.Client

	if err := c.BindJSON(&client); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Could not add client",
			"details": err.Error(),
		})
		return
	}

	companyTIN, err := middleware.GetCompanyTIN(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	client.CompanyTIN = companyTIN

	if err := h.service.CreateClient(&client); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Could not add client",
			"details": err.Error(),
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Client added successfully",
		"client":  client,
	})
}
