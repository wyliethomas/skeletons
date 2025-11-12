package middleware

import (
	"context"
	"net/http"
	"strings"
)

type contextKey string

const UserContextKey contextKey = "user"

func Auth(jwtSecret string) func(next http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Get token from Authorization header
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				respondWithError(w, http.StatusUnauthorized, "Missing authorization header")
				return
			}

			// Extract Bearer token
			parts := strings.Split(authHeader, " ")
			if len(parts) != 2 || parts[0] != "Bearer" {
				respondWithError(w, http.StatusUnauthorized, "Invalid authorization header format")
				return
			}

			token := parts[1]

			// TODO: Implement JWT validation here
			// For now, just check if token is not empty
			if token == "" {
				respondWithError(w, http.StatusUnauthorized, "Invalid token")
				return
			}

			// TODO: Parse JWT and extract user information
			// user, err := parseJWT(token, jwtSecret)
			// if err != nil {
			//     respondWithError(w, http.StatusUnauthorized, "Invalid token")
			//     return
			// }

			// Add user to context (example)
			// ctx := context.WithValue(r.Context(), UserContextKey, user)
			ctx := context.WithValue(r.Context(), UserContextKey, map[string]interface{}{
				"id":    "example-user-id",
				"email": "user@example.com",
			})

			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

func respondWithError(w http.ResponseWriter, code int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write([]byte(`{"error":"` + message + `"}`))
}
