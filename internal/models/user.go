package models

import "time"

// User represents a user in the system
type User struct {
	ID        string    `json:"id"`
	Email     string    `json:"email"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// CreateUserInput represents the input for creating a user
type CreateUserInput struct {
	Email string `json:"email"`
	Name  string `json:"name"`
}

// UpdateUserInput represents the input for updating a user
type UpdateUserInput struct {
	Email string `json:"email"`
	Name  string `json:"name"`
}

// Validate validates the user input
func (u *CreateUserInput) Validate() error {
	// TODO: Add validation logic
	// Example: Check email format, required fields, etc.
	return nil
}
