# project-name

A production-ready Go microservice with best practices and modern patterns.

## Features

- **Chi Router** - Fast and lightweight HTTP router
- **Structured Logging** - JSON logging with zerolog
- **Health Checks** - `/health` and `/ready` endpoints
- **Graceful Shutdown** - Clean handling of termination signals
- **CORS Support** - Pre-configured cross-origin requests
- **Middleware** - Logging, recovery, timeout, authentication
- **Hot Reload** - Development with Air (optional)
- **Docker Ready** - Multi-stage Dockerfile included
- **Configuration** - Environment-based config management

## Quick Start

```bash
# Install dependencies
go mod download

# Copy environment file
cp .env.example .env

# Run the application
make run

# Or directly
go run cmd/server/main.go
```

Visit `http://localhost:8080/health` to verify it's running.

## Development

### Prerequisites

- Go 1.21 or higher
- Make (optional, for convenience)

### Running Locally

```bash
# Run with make
make run

# Run with go
go run cmd/server/main.go

# Build binary
make build
./bin/main

# Run tests
make test

# Format code
make fmt
```

### Hot Reload (Optional)

Install Air for hot reloading:

```bash
go install github.com/cosmtrek/air@latest
make dev
```

## Project Structure

```
.
├── cmd/
│   └── server/
│       └── main.go              # Application entry point
├── internal/
│   ├── config/
│   │   └── config.go            # Configuration management
│   ├── handlers/
│   │   ├── health.go            # Health check handlers
│   │   └── users.go             # Example CRUD handlers
│   ├── middleware/
│   │   ├── auth.go              # Authentication middleware
│   │   └── logger.go            # Logging middleware
│   └── models/
│       └── user.go              # Data models
├── pkg/
│   └── logger/
│       └── logger.go            # Logger initialization
├── .env.example                 # Environment variables template
├── Dockerfile                   # Multi-stage Docker build
├── Makefile                     # Development tasks
└── go.mod                       # Go module definition
```

## API Endpoints

### Health Checks

```bash
# Basic health check
curl http://localhost:8080/health

# Readiness check (includes dependencies)
curl http://localhost:8080/ready
```

### Users API (Example)

```bash
# List users
curl http://localhost:8080/api/v1/users

# Get user
curl http://localhost:8080/api/v1/users/123

# Create user
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","name":"John Doe"}'

# Update user
curl -X PUT http://localhost:8080/api/v1/users/123 \
  -H "Content-Type: application/json" \
  -d '{"email":"updated@example.com","name":"Jane Doe"}'

# Delete user
curl -X DELETE http://localhost:8080/api/v1/users/123

# Protected endpoint (requires authentication)
curl http://localhost:8080/api/v1/protected \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Configuration

Configuration is managed through environment variables. See `.env.example`:

### Key Variables

- `APP_NAME` - Application name
- `APP_ENV` - Environment (development, staging, production)
- `PORT` - Server port (default: 8080)
- `LOG_LEVEL` - Logging level (debug, info, warn, error)
- `LOG_FORMAT` - Log format (json, console)
- `JWT_SECRET` - Secret for JWT signing
- `CORS_ALLOWED_ORIGINS` - Comma-separated list of allowed origins

## Docker

### Build Image

```bash
make docker-build

# Or manually
docker build -t project-name:latest .
```

### Run Container

```bash
make docker-run

# Or manually
docker run -p 8080:8080 --env-file .env project-name:latest
```

### Docker Compose (Example)

```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8080:8080"
    environment:
      - APP_ENV=production
      - DATABASE_URL=postgresql://db:5432/project_name
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=project_name
      - POSTGRES_PASSWORD=secret
```

## Testing

```bash
# Run all tests
make test

# Run specific package tests
go test -v ./internal/handlers

# Run with coverage
go test -cover ./...

# Generate coverage report
make test
# Opens coverage.html in browser
```

## Logging

The application uses structured JSON logging via zerolog:

```go
log.Info().
    Str("user_id", userID).
    Int("count", count).
    Msg("Processing user data")
```

Log levels:
- `debug` - Development debugging
- `info` - General information (default)
- `warn` - Warning messages
- `error` - Error messages

Set `LOG_FORMAT=console` for human-readable logs in development.

## Authentication

The skeleton includes basic JWT authentication middleware:

1. Protected routes use the `Auth` middleware
2. Tokens are passed in `Authorization: Bearer TOKEN` header
3. Implement JWT signing/verification in `middleware/auth.go`

Example JWT implementation:

```go
import "github.com/golang-jwt/jwt/v5"

func GenerateToken(userID string, secret string) (string, error) {
    claims := jwt.MapClaims{
        "user_id": userID,
        "exp":     time.Now().Add(24 * time.Hour).Unix(),
    }
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(secret))
}
```

## Graceful Shutdown

The application handles `SIGINT` and `SIGTERM` signals gracefully:

1. Stops accepting new connections
2. Waits for active requests to complete (up to `SHUTDOWN_TIMEOUT`)
3. Closes database connections and resources
4. Exits cleanly

## Production Checklist

- [ ] Set strong `JWT_SECRET` and `API_SECRET_KEY`
- [ ] Configure `CORS_ALLOWED_ORIGINS` for your frontend
- [ ] Set appropriate timeouts (read, write, idle, shutdown)
- [ ] Enable HTTPS/TLS
- [ ] Set up monitoring (health check endpoint)
- [ ] Configure log aggregation
- [ ] Set up error tracking (Sentry, etc.)
- [ ] Add rate limiting
- [ ] Implement database connection pooling
- [ ] Add metrics (Prometheus, etc.)

## Performance Tips

- Use connection pooling for databases
- Implement caching (Redis, in-memory)
- Add rate limiting middleware
- Use database indexes
- Profile with pprof: `import _ "net/http/pprof"`
- Monitor goroutine leaks

## Common Tasks

### Adding a New Endpoint

1. Define handler in `internal/handlers/`
2. Add route in `cmd/server/main.go`
3. Add tests

### Adding Middleware

1. Create middleware function in `internal/middleware/`
2. Add to router chain in `main.go`

### Database Integration

```go
// Add to dependencies
import "database/sql"
import _ "github.com/lib/pq"

// In main.go
db, err := sql.Open("postgres", cfg.DatabaseURL)
defer db.Close()
```

## Next Steps

1. Implement database layer (PostgreSQL, MongoDB, etc.)
2. Add authentication/authorization logic
3. Create your domain models and handlers
4. Write comprehensive tests
5. Set up CI/CD pipeline
6. Add monitoring and metrics

See `CLAUDE_CONTEXT.md` for architecture details and patterns.
