package handlers

import (
	"net/http"

	"github.com/DroneBreaker/Inventra-App/internal/models"
	"github.com/DroneBreaker/Inventra-App/internal/services"
	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	AuthService *services.AuthService
}

func NewAuthHandler(s *services.AuthService) *AuthHandler {
	return &AuthHandler{AuthService: s}
}

func (h *AuthHandler) Register(c *gin.Context) {
	var payload models.RegisterDTO
	if err := c.Bind(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.AuthService.Register(payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "User created successfully",
	})
}

func (h *AuthHandler) Login(c *gin.Context) {
	var payload models.LoginDTO
	if err := c.Bind(&payload); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, err := h.AuthService.Login(payload)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
	})
}
