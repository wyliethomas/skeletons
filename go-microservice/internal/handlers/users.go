package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/PROJECT_NAME/project-name/internal/models"
	"github.com/go-chi/chi/v5"
)

// ListUsers returns a list of users
func ListUsers(w http.ResponseWriter, r *http.Request) {
	// TODO: Fetch from database
	users := []models.User{
		{ID: "1", Email: "user1@example.com", Name: "User One"},
		{ID: "2", Email: "user2@example.com", Name: "User Two"},
	}

	response := map[string]interface{}{
		"data": users,
		"meta": map[string]interface{}{
			"total": len(users),
		},
	}

	respondWithJSON(w, http.StatusOK, response)
}

// GetUser returns a single user by ID
func GetUser(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")

	// TODO: Fetch from database
	user := models.User{
		ID:    id,
		Email: "user@example.com",
		Name:  "Example User",
	}

	response := map[string]interface{}{
		"data": user,
	}

	respondWithJSON(w, http.StatusOK, response)
}

// CreateUser creates a new user
func CreateUser(w http.ResponseWriter, r *http.Request) {
	var input models.CreateUserInput

	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}

	// Validate input
	if input.Email == "" || input.Name == "" {
		respondWithError(w, http.StatusBadRequest, "Email and name are required")
		return
	}

	// TODO: Create user in database
	user := models.User{
		ID:    "new-user-id",
		Email: input.Email,
		Name:  input.Name,
	}

	response := map[string]interface{}{
		"data": user,
	}

	respondWithJSON(w, http.StatusCreated, response)
}

// UpdateUser updates an existing user
func UpdateUser(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")

	var input models.UpdateUserInput
	if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
		respondWithError(w, http.StatusBadRequest, "Invalid request payload")
		return
	}

	// TODO: Update user in database
	user := models.User{
		ID:    id,
		Email: input.Email,
		Name:  input.Name,
	}

	response := map[string]interface{}{
		"data": user,
	}

	respondWithJSON(w, http.StatusOK, response)
}

// DeleteUser deletes a user
func DeleteUser(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")

	// TODO: Delete user from database
	_ = id

	w.WriteHeader(http.StatusNoContent)
}

// ProtectedEndpoint is an example of a protected endpoint
func ProtectedEndpoint(w http.ResponseWriter, r *http.Request) {
	// User context is set by the auth middleware
	// user := r.Context().Value(middleware.UserContextKey)

	response := map[string]interface{}{
		"message": "This is a protected endpoint",
		"data":    "Secret data",
	}

	respondWithJSON(w, http.StatusOK, response)
}

func respondWithError(w http.ResponseWriter, code int, message string) {
	response := map[string]string{"error": message}
	respondWithJSON(w, code, response)
}
