package handlers

type UserHandler struct {
	userService *services.UserService
}

func NewUserHandler(s *services.UserServices) *UserHandler {
	return &userHandler{authHandler: s}
}
