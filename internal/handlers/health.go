package handlers

import (
	"encoding/json"
	"net/http"
	"time"
)

type HealthResponse struct {
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
	Version   string    `json:"version"`
}

type ReadinessResponse struct {
	Status    string            `json:"status"`
	Checks    map[string]string `json:"checks"`
	Timestamp time.Time         `json:"timestamp"`
}

// HealthCheck returns basic health status
func HealthCheck(w http.ResponseWriter, r *http.Request) {
	response := HealthResponse{
		Status:    "healthy",
		Timestamp: time.Now(),
		Version:   "1.0.0",
	}

	respondWithJSON(w, http.StatusOK, response)
}

// ReadinessCheck checks if service is ready to accept traffic
func ReadinessCheck(w http.ResponseWriter, r *http.Request) {
	checks := make(map[string]string)

	// TODO: Add actual health checks
	// Example: Check database connectivity
	// if err := db.Ping(); err != nil {
	//     checks["database"] = "unhealthy"
	// } else {
	//     checks["database"] = "healthy"
	// }

	// Example: Check Redis connectivity
	// if err := redis.Ping(); err != nil {
	//     checks["redis"] = "unhealthy"
	// } else {
	//     checks["redis"] = "healthy"
	// }

	checks["application"] = "healthy"

	// Determine overall status
	status := "ready"
	for _, check := range checks {
		if check != "healthy" {
			status = "not ready"
			break
		}
	}

	response := ReadinessResponse{
		Status:    status,
		Checks:    checks,
		Timestamp: time.Now(),
	}

	statusCode := http.StatusOK
	if status != "ready" {
		statusCode = http.StatusServiceUnavailable
	}

	respondWithJSON(w, statusCode, response)
}

func respondWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	response, err := json.Marshal(payload)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"error":"Internal server error"}`))
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	w.Write(response)
}
