# CLAUDE_CONTEXT.md - Go Microservice Architecture

This document explains the architecture, patterns, and conventions used in this Go microservice. Use this as a guide when extending or modifying the codebase.

## Architecture Overview

This is a **Go HTTP microservice** following these principles:

1. **Clean Architecture** - Separation of concerns (handlers, models, config)
2. **Standard Project Layout** - Following Go community conventions
3. **Middleware Pattern** - Composable request/response processing
4. **Structured Logging** - JSON logs for production, human-readable for dev
5. **Graceful Shutdown** - Clean handling of termination signals
6. **Health Checks** - Kubernetes-ready liveness and readiness probes

## Project Structure

### Directory Layout

```
cmd/                    # Application entry points
  server/
    main.go            # Main application (routing, server setup)

internal/              # Private application code
  config/              # Configuration management
  handlers/            # HTTP request handlers
  middleware/          # HTTP middleware
  models/              # Data models and types

pkg/                   # Public libraries (can be imported by external projects)
  logger/              # Logger initialization
```

### Why This Structure?

- `cmd/` - Multiple entry points (server, CLI tools, migrations)
- `internal/` - Cannot be imported by external projects (enforced by Go)
- `pkg/` - Reusable packages that could be extracted to libraries
- `vendor/` - (Optional) Vendored dependencies

## Request Flow

```
HTTP Request
    ↓
Chi Router
    ↓
Global Middleware (RequestID → Logger → Recoverer → Timeout → CORS)
    ↓
Route-Specific Middleware (Auth)
    ↓
Handler (users.go, health.go)
    ↓
Model/Service Layer (business logic)
    ↓
Database/External Services
    ↓
JSON Response
```

## Core Components

### 1. Main Application (cmd/server/main.go)

**Responsibilities:**
- Load configuration
- Initialize logger
- Set up router and middleware
- Define routes
- Start HTTP server
- Handle graceful shutdown

**Pattern:**
```go
func main() {
    // 1. Load config
    cfg := config.Load()

    // 2. Initialize dependencies
    log := logger.New(cfg.LogLevel, cfg.LogFormat)

    // 3. Set up router
    r := chi.NewRouter()
    r.Use(middleware.Logger(log))

    // 4. Define routes
    r.Get("/health", handlers.HealthCheck)

    // 5. Start server
    server := &http.Server{...}
    go server.ListenAndServe()

    // 6. Graceful shutdown
    <-quit
    server.Shutdown(ctx)
}
```

### 2. Configuration (internal/config/)

**Pattern: Environment-based configuration**

```go
type Config struct {
    AppName    string
    Port       string
    LogLevel   string
    // ...
}

func Load() *Config {
    return &Config{
        AppName:  getEnv("APP_NAME", "default"),
        Port:     getEnv("PORT", "8080"),
        LogLevel: getEnv("LOG_LEVEL", "info"),
    }
}
```

**Conventions:**
- All config from environment variables
- Sensible defaults
- Type-safe parsing (durations, slices, etc.)
- Single source of truth

### 3. Handlers (internal/handlers/)

**Responsibilities:**
- HTTP request/response handling
- Input validation
- Call business logic
- Format responses

**Standard Handler Pattern:**
```go
func CreateUser(w http.ResponseWriter, r *http.Request) {
    // 1. Parse and validate input
    var input models.CreateUserInput
    if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
        respondWithError(w, http.StatusBadRequest, "Invalid input")
        return
    }

    // 2. Business logic (should be in service layer for complex operations)
    user := createUserInDB(input)

    // 3. Format and return response
    respondWithJSON(w, http.StatusCreated, map[string]interface{}{
        "data": user,
    })
}
```

**Response Format Convention:**

Success:
```json
{
  "data": { ... }
}
```

Collection:
```json
{
  "data": [...],
  "meta": {
    "total": 100,
    "page": 1
  }
}
```

Error:
```json
{
  "error": "Human readable message"
}
```

### 4. Middleware (internal/middleware/)

**Pattern: Closure that returns http.Handler**

```go
func Auth(secret string) func(next http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            // Middleware logic
            if !isAuthenticated(r, secret) {
                respondWithError(w, 401, "Unauthorized")
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

**Middleware Chain Order Matters:**
1. RequestID - Add unique ID to each request
2. Logger - Log requests (needs RequestID)
3. Recoverer - Recover from panics
4. Timeout - Request timeout
5. CORS - Handle CORS
6. Auth - Authentication (route-specific)

### 5. Models (internal/models/)

**Responsibilities:**
- Define data structures
- Input validation
- Type definitions

```go
type User struct {
    ID        string    `json:"id"`
    Email     string    `json:"email"`
    Name      string    `json:"name"`
    CreatedAt time.Time `json:"created_at"`
}

type CreateUserInput struct {
    Email string `json:"email"`
    Name  string `json:"name"`
}

func (u *CreateUserInput) Validate() error {
    if u.Email == "" {
        return errors.New("email is required")
    }
    // More validation...
    return nil
}
```

## Routing Patterns

### Chi Router Basics

```go
r := chi.NewRouter()

// Simple routes
r.Get("/health", handlers.HealthCheck)
r.Post("/users", handlers.CreateUser)

// URL parameters
r.Get("/users/{id}", handlers.GetUser)

// Nested routes
r.Route("/api/v1", func(r chi.Router) {
    r.Get("/users", handlers.ListUsers)
    r.Post("/users", handlers.CreateUser)
})

// Grouped routes with middleware
r.Group(func(r chi.Router) {
    r.Use(middleware.Auth(secret))
    r.Get("/protected", handlers.Protected)
})
```

### Versioned APIs

```go
// Version 1
r.Route("/api/v1", func(r chi.Router) {
    r.Get("/users", v1handlers.ListUsers)
})

// Version 2
r.Route("/api/v2", func(r chi.Router) {
    r.Get("/users", v2handlers.ListUsers)
})
```

## Error Handling

### Handler-Level Errors

```go
func GetUser(w http.ResponseWriter, r *http.Request) {
    id := chi.URLParam(r, "id")

    user, err := fetchUser(id)
    if err != nil {
        if errors.Is(err, ErrNotFound) {
            respondWithError(w, http.StatusNotFound, "User not found")
            return
        }
        respondWithError(w, http.StatusInternalServerError, "Internal error")
        return
    }

    respondWithJSON(w, http.StatusOK, map[string]interface{}{"data": user})
}
```

### Recoverer Middleware

Chi's `Recoverer` middleware catches panics and returns 500:

```go
r.Use(middleware.Recoverer)
```

### Custom Error Types

```go
var (
    ErrNotFound      = errors.New("not found")
    ErrUnauthorized  = errors.New("unauthorized")
    ErrBadRequest    = errors.New("bad request")
)

// With context
type AppError struct {
    Code    int
    Message string
    Err     error
}

func (e *AppError) Error() string {
    return e.Message
}
```

## Logging Patterns

### Structured Logging

```go
import "github.com/rs/zerolog"

// In handler
log.Info().
    Str("user_id", userID).
    Int("count", count).
    Dur("duration", elapsed).
    Msg("Processing completed")

log.Error().
    Err(err).
    Str("user_id", userID).
    Msg("Failed to process")
```

### Request Logging

The logging middleware automatically logs:
- Request method, path
- Response status, size
- Duration
- Request ID
- Remote address

### Log Levels

- `Debug` - Development details
- `Info` - Normal operations
- `Warn` - Warning conditions
- `Error` - Error conditions
- `Fatal` - Fatal errors (exits program)

## Testing Patterns

### Handler Testing

```go
func TestCreateUser(t *testing.T) {
    // Create test request
    body := `{"email":"test@example.com","name":"Test User"}`
    req := httptest.NewRequest("POST", "/api/v1/users", strings.NewReader(body))
    req.Header.Set("Content-Type", "application/json")

    // Create response recorder
    w := httptest.NewRecorder()

    // Call handler
    handlers.CreateUser(w, req)

    // Assert response
    assert.Equal(t, http.StatusCreated, w.Code)

    var response map[string]interface{}
    json.NewDecoder(w.Body).Decode(&response)
    assert.NotNil(t, response["data"])
}
```

### Middleware Testing

```go
func TestAuthMiddleware(t *testing.T) {
    // Create handler that requires auth
    handler := middleware.Auth("secret")(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
    }))

    // Test without token
    req := httptest.NewRequest("GET", "/protected", nil)
    w := httptest.NewRecorder()
    handler.ServeHTTP(w, req)
    assert.Equal(t, http.StatusUnauthorized, w.Code)

    // Test with valid token
    req.Header.Set("Authorization", "Bearer valid-token")
    w = httptest.NewRecorder()
    handler.ServeHTTP(w, req)
    assert.Equal(t, http.StatusOK, w.Code)
}
```

## Database Integration

### Pattern: Repository Layer

```go
// internal/repository/user.go
type UserRepository interface {
    Create(user *models.User) error
    GetByID(id string) (*models.User, error)
    List() ([]*models.User, error)
    Update(user *models.User) error
    Delete(id string) error
}

type postgresUserRepository struct {
    db *sql.DB
}

func NewUserRepository(db *sql.DB) UserRepository {
    return &postgresUserRepository{db: db}
}

func (r *postgresUserRepository) GetByID(id string) (*models.User, error) {
    var user models.User
    err := r.db.QueryRow("SELECT id, email, name FROM users WHERE id = $1", id).
        Scan(&user.ID, &user.Email, &user.Name)
    if err == sql.ErrNoRows {
        return nil, ErrNotFound
    }
    return &user, err
}
```

### Dependency Injection

```go
// In main.go
db, err := sql.Open("postgres", cfg.DatabaseURL)
if err != nil {
    log.Fatal().Err(err).Msg("Failed to connect to database")
}
defer db.Close()

// Create repositories
userRepo := repository.NewUserRepository(db)

// Pass to handlers
r.Get("/users/{id}", handlers.GetUser(userRepo))

// Handler signature
func GetUser(repo repository.UserRepository) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        id := chi.URLParam(r, "id")
        user, err := repo.GetByID(id)
        // ...
    }
}
```

## Service Layer Pattern

For complex business logic, add a service layer:

```go
// internal/service/user_service.go
type UserService struct {
    userRepo repository.UserRepository
    emailSvc EmailService
}

func (s *UserService) RegisterUser(input models.CreateUserInput) (*models.User, error) {
    // Validate
    if err := input.Validate(); err != nil {
        return nil, err
    }

    // Check if exists
    existing, _ := s.userRepo.GetByEmail(input.Email)
    if existing != nil {
        return nil, ErrUserExists
    }

    // Create user
    user := &models.User{
        Email: input.Email,
        Name:  input.Name,
    }

    if err := s.userRepo.Create(user); err != nil {
        return nil, err
    }

    // Send welcome email
    go s.emailSvc.SendWelcome(user.Email)

    return user, nil
}
```

## Graceful Shutdown

The application handles shutdown signals properly:

```go
// Channel for OS signals
quit := make(chan os.Signal, 1)
signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

// Block until signal received
<-quit

log.Info().Msg("Shutting down...")

// Create context with timeout
ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
defer cancel()

// Shutdown server
if err := server.Shutdown(ctx); err != nil {
    log.Fatal().Err(err).Msg("Forced shutdown")
}

// Close database connections
db.Close()

// Close other resources
```

## Adding New Features

### Adding a New Endpoint

1. **Define model** (`internal/models/post.go`):
```go
type Post struct {
    ID    string `json:"id"`
    Title string `json:"title"`
    Body  string `json:"body"`
}
```

2. **Create handler** (`internal/handlers/posts.go`):
```go
func ListPosts(w http.ResponseWriter, r *http.Request) {
    // Implementation
}
```

3. **Add route** (`cmd/server/main.go`):
```go
r.Get("/api/v1/posts", handlers.ListPosts)
```

4. **Write tests** (`internal/handlers/posts_test.go`)

### Adding Middleware

1. **Create middleware** (`internal/middleware/ratelimit.go`):
```go
func RateLimit(limit int) func(next http.Handler) http.Handler {
    // Implementation
}
```

2. **Apply to routes**:
```go
// Global
r.Use(middleware.RateLimit(100))

// Route-specific
r.With(middleware.RateLimit(10)).Get("/expensive", handler)
```

## Security Best Practices

1. **Input Validation** - Always validate and sanitize input
2. **SQL Injection** - Use parameterized queries
3. **Authentication** - Implement JWT or session-based auth
4. **CORS** - Restrict origins in production
5. **Rate Limiting** - Prevent abuse
6. **Secrets** - Never commit secrets, use env vars
7. **HTTPS** - Always use TLS in production
8. **Headers** - Set security headers (CSP, HSTS, etc.)

## Performance Tips

1. **Connection Pooling** - Configure `db.SetMaxOpenConns()`
2. **Caching** - Use Redis for frequently accessed data
3. **Goroutines** - Don't overuse, can cause memory issues
4. **Context** - Pass context for cancellation
5. **Profiling** - Use pprof to find bottlenecks
6. **Indexes** - Database indexes for common queries

## Common Patterns

### Context Values

```go
// Set value
ctx := context.WithValue(r.Context(), "user_id", userID)
r = r.WithContext(ctx)

// Get value
userID := r.Context().Value("user_id").(string)
```

### Background Jobs

```go
go func() {
    // Long-running task
    sendEmail(user.Email)
}()
```

### Timeouts

```go
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

req, _ := http.NewRequestWithContext(ctx, "GET", url, nil)
resp, err := client.Do(req)
```

## Conventions Summary

1. **Package naming** - Short, lowercase, single word
2. **Error handling** - Check all errors, return early
3. **JSON tags** - snake_case for API consistency
4. **Handlers** - One file per resource (users.go, posts.go)
5. **Responses** - Always wrap in `{"data": ...}` or `{"error": ...}`
6. **Logging** - Use structured logging, include context
7. **Config** - Environment variables only
8. **Tests** - `_test.go` suffix, table-driven tests
9. **Middleware** - Composable, single responsibility
10. **Shutdown** - Always handle gracefully

---

**When in doubt:** Look at the existing handlers and middleware as reference implementations.
