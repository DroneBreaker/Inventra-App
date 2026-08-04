package handlers

import (
	"fmt"
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

	fmt.Printf("Received Client: %+v\n", client)
	fmt.Println("Client Type:", client.ClientType)

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

func (h *ClientHandler) GetAllClients(c *gin.Context) {
	clientType := c.Query("type") // e.g. ?type=Customer

	companyTIN, err := middleware.GetCompanyTIN(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	clients, err := h.service.GetAllClients(clientType, companyTIN)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Could not get clients",
			"details": err.Error(),
		})
		return
	}
	c.JSON(http.StatusOK, clients)
}

// client_handler.go
func (h *ClientHandler) SearchClients(c *gin.Context) {
	query := c.Query("search")

	companyTIN, err := middleware.GetCompanyTIN(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	clients, err := h.service.SearchClients(query, companyTIN)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Could not search clients",
			"details": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, clients) // bare array — matches Flutter's List<dynamic> parse
}

func (h *ClientHandler) UpdateClient(c *gin.Context) {
	id := c.Param("id")

	companyTIN, err := middleware.GetCompanyTIN(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var body map[string]interface{}
	if err := c.BindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	// Only allow safe fields to be updated
	allowed := map[string]interface{}{}
	for _, field := range []string{"client_name", "client_email", "client_phone"} {
		if val, ok := body[field]; ok {
			allowed[field] = val
		}
	}

	if err := h.service.UpdateClient(id, companyTIN, allowed); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Could not update client",
			"details": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Client updated successfully"})
}
