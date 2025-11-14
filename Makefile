.PHONY: help build run test clean docker-build docker-run fmt lint

# Default target
help:
	@echo "Available targets:"
	@echo "  make build        - Build the application"
	@echo "  make run          - Run the application"
	@echo "  make test         - Run tests"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-run   - Run Docker container"
	@echo "  make fmt          - Format code"
	@echo "  make lint         - Run linter"

# Build the application
build:
	@echo "Building..."
	@go build -o bin/main cmd/server/main.go

# Run the application
run:
	@echo "Running..."
	@go run cmd/server/main.go

# Run tests
test:
	@echo "Running tests..."
	@go test -v -race -coverprofile=coverage.out ./...
	@go tool cover -html=coverage.out -o coverage.html

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -rf bin/
	@rm -f coverage.out coverage.html

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	@docker build -t project-name:latest .

# Run Docker container
docker-run:
	@echo "Running Docker container..."
	@docker run --rm -p 8080:8080 --env-file .env project-name:latest

# Format code
fmt:
	@echo "Formatting code..."
	@go fmt ./...

# Run linter
lint:
	@echo "Running linter..."
	@golangci-lint run

# Install dependencies
deps:
	@echo "Installing dependencies..."
	@go mod download
	@go mod tidy

# Run with hot reload (requires air)
dev:
	@echo "Running with hot reload..."
	@air
