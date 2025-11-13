# project-name

A production-ready Rails 7 API with comprehensive authentication and OAuth support.

## Features

- **Rails 7 API-only** - Latest stable version optimized for APIs
- **Comprehensive Authentication** - Email/password + OAuth (Google, Apple, Facebook)
- **JWT Session Management** - Token-based auth with 5-day expiry
- **API Key Support** - Each user gets a unique API key
- **Password Reset Flow** - Email-based with token + code verification
- **User Status Management** - ACTIVE, INACTIVE, PENDING, BANNED states
- **PostgreSQL + Redis** - Primary database and caching
- **Sidekiq** - Background job processing
- **Figaro** - Secure environment variable management
- **Jbuilder** - JSON response building
- **RSpec** - Comprehensive testing framework
- **Docker Ready** - Full Docker setup with PostgreSQL, Redis, and Sidekiq

## Quick Start (Docker) - Recommended

Docker setup includes PostgreSQL, Redis, Rails web server, and Sidekiq worker.

```bash
# 1. Copy environment files
cp .env.example .env
cp config/application.yml.example config/application.yml

# 2. Update .env with your project name
# Edit COMPOSE_NAME in .env

# 3. Edit config/application.yml
# Update lockbox_key (generate with: rails secret)
# Update OAuth credentials if needed
# Docker database credentials are already set

# 4. Run setup script (builds containers and sets up database)
./setup.sh

# 5. Start all services
docker compose up

# Or run in background
docker compose up -d

# View logs
docker compose logs -f web
docker compose logs -f sidekiq
```

Visit `http://localhost:3000/health` to verify it's running.

### Docker Commands

```bash
# Stop all services
docker compose down

# Rebuild after Gemfile changes
docker compose build
docker compose run --rm web bundle install

# Run migrations
docker compose run --rm web rails db:migrate

# Access Rails console
docker compose run --rm web rails console

# Run tests
docker compose run --rm web rspec

# Reset database
docker compose run --rm web rails db:reset
```

## Quick Start (Local)

```bash
# Install dependencies
bundle install

# Setup Figaro configuration
cp config/application.yml.example config/application.yml
# Edit config/application.yml with your values

# Setup database
rails db:create db:migrate

# Start Redis
redis-server

# Start Sidekiq (in another terminal)
bundle exec sidekiq

# Start Rails server
rails server
```

Visit `http://localhost:3000/health` to verify it's running.

## Authentication

### Authentication Methods

#### 1. Email/Password (Internal)

```bash
# Sign Up
POST /api/v1/signup
{
  "user": {
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "password": "SecurePass123",
    "password_confirmation": "SecurePass123"
  }
}

# Sign In
POST /api/v1/signin
{
  "data": {
    "email": "john@example.com",
    "password": "SecurePass123"
  }
}

# Response
{
  "user": {
    "jwt": "eyJhbGciOiJIUzI1NiJ9...",
    "user_key": "abc123def456",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "name": "John Doe",
    "status": "ACTIVE",
    "role": null
  }
}
```

#### 2. Google Sign-In

```bash
POST /api/v1/auth/gsi/callback
{
  "data": {
    "email": "user@gmail.com",
    "given_name": "John",
    "family_name": "Doe",
    "sub": "google-user-id"
  }
}
```

#### 3. Apple Sign-In

```bash
POST /api/v1/auth/apple
{
  "payload": {
    "authorization": {
      "id_token": "apple-id-token"
    },
    "user": {
      "name": {
        "firstName": "John",
        "lastName": "Doe"
      }
    }
  }
}
```

#### 4. Facebook Auth

```bash
POST /api/v1/auth/facebook
{
  "id": "facebook-user-id",
  "name": "John Doe"
}
```

### Making Authenticated Requests

Once signed in, use the JWT token for all requests:

```bash
GET /api/v1/users
Authorization: Bearer {JWT_TOKEN}
```

The token includes:
- User apikey
- User name and email
- 5-day expiration

### Sign Out

```bash
POST /api/v1/signout
Authorization: Bearer {JWT_TOKEN}
```

## Password Reset Flow

### 1. Request Password Reset

```bash
POST /api/v1/forgot_password
{
  "forgot_password": {
    "email": "user@example.com",
    "link": "https://yourapp.com/reset-password"
  }
}
```

This generates:
- A unique `password_reset_key` (UUID)
- A 4-character `password_reset_code` (e.g., "A3K9")
- 10-minute expiration

An email is sent with both the link and code.

### 2. Reset Password

```bash
POST /api/v1/reset_password
{
  "password_reset": {
    "token": "uuid-from-email-link",
    "code": "A3K9",
    "password": "NewSecurePass123",
    "password_confirmation": "NewSecurePass123"
  }
}

# Returns new JWT on success
{
  "jwt": "new-jwt-token..."
}
```

## User Status Management

Users have four possible statuses:

- **ACTIVE** - Can sign in and use the system (default)
- **INACTIVE** - Cannot sign in
- **PENDING** - Awaiting validation/approval
- **BANNED** - Permanently blocked

Only ACTIVE users can authenticate.

## Configuration (Figaro)

This project uses **Figaro** for environment variables instead of dotenv.

### Setup

```bash
# 1. Copy example file
cp config/application.yml.example config/application.yml

# 2. Generate JWT secret
rails secret
# Copy output to lockbox_key in application.yml

# 3. Update other values
# - Google OAuth credentials
# - Database URL
# - SMTP settings for emails
# - etc.
```

### Key Configuration Values

| Variable | Description |
|----------|-------------|
| `lockbox_key` | JWT encoding/decoding secret (use `rails secret`) |
| `google_client_id` | Google OAuth client ID |
| `database_url` | PostgreSQL connection string |
| `redis_url` | Redis connection string |
| `smtp_*` | Email server configuration for password resets |

## API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/v1/signup` | Create new user | None |
| POST | `/api/v1/signin` | Login with email/password | None |
| POST | `/api/v1/signout` | Logout current user | JWT |
| POST | `/api/v1/forgot_password` | Request password reset | None |
| POST | `/api/v1/reset_password` | Complete password reset | None |
| POST | `/api/v1/auth/gsi/callback` | Google Sign-In | None |
| POST | `/api/v1/auth/apple` | Apple Sign-In | None |
| POST | `/api/v1/auth/facebook` | Facebook Login | None |

### User Management

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/v1/users` | List users | JWT |
| GET | `/api/v1/users/:id` | Get user details | JWT |
| POST | `/api/v1/users` | Create user | JWT |
| PUT | `/api/v1/users/:id` | Update user | JWT |
| DELETE | `/api/v1/users/:id` | Delete user | JWT |

## Database Schema

### Users Table

```ruby
t.string      :first_name
t.string      :last_name
t.string      :email               # Unique globally
t.string      :mobile
t.string      :oauth_sub           # OAuth provider ID
t.string      :jwt                 # Current session token
t.boolean     :signed_in           # Session state
t.string      :provider            # Internal, Google, Apple, Facebook
t.string      :password_hash       # BCrypt hash
t.string      :password_salt       # BCrypt salt
t.string      :password_reset_key  # UUID for reset flow
t.string      :password_reset_code # 4-char verification code
t.datetime    :password_reset_expires
t.datetime    :last_active
t.string      :role
t.string      :apikey              # Unique API key
t.string      :status              # ACTIVE, INACTIVE, PENDING, BANNED
# + address fields
```

## Password Security

This API uses **custom BCrypt hashing** (not `has_secure_password`):

```ruby
# On create/update
password_salt = BCrypt::Engine.generate_salt
password_hash = BCrypt::Engine.hash_secret(password, password_salt)

# On authentication
BCrypt::Engine.hash_secret(input_password, user.password_salt) == user.password_hash
```

**Password Requirements:**
- Minimum 8 characters
- Must contain at least one letter
- Must match confirmation

## Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test
bundle exec rspec spec/models/user_spec.rb

# With coverage
COVERAGE=true bundle exec rspec
```

## Email Setup

For password resets to work, configure SMTP in `config/application.yml`:

```yaml
smtp_address: "smtp.gmail.com"
smtp_port: "587"
smtp_username: "your-email@gmail.com"
smtp_password: "your-app-password"
```

**Gmail Users:** Use an [App Password](https://support.google.com/accounts/answer/185833), not your regular password.

## OAuth Setup

### Google Sign-In

1. Create project at [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Google+ API
3. Create OAuth 2.0 credentials
4. Add `google_client_id` to `application.yml`

### Apple Sign-In

1. Configure at [Apple Developer](https://developer.apple.com/)
2. Create Service ID
3. Generate private key
4. Implement `apple_cert` method in User model (see TODO comments)

### Facebook Login

1. Create app at [Facebook Developers](https://developers.facebook.com/)
2. Get App ID and Secret
3. Add to `application.yml`

## Production Checklist

- [ ] Generate strong `lockbox_key` with `rails secret`
- [ ] Configure production database URL
- [ ] Set up Redis for production
- [ ] Configure SMTP for emails (SendGrid, Mailgun, etc.)
- [ ] Set up OAuth credentials for each provider
- [ ] Configure CORS for your frontend domain
- [ ] Protect Sidekiq web UI (add authentication)
- [ ] Set up error tracking (Sentry, Rollbar, etc.)
- [ ] Configure logging and monitoring
- [ ] Set up automated backups
- [ ] Review and update user permissions
- [ ] SSL/TLS certificates configured
- [ ] Rate limiting implemented

## Development Tips

### Creating Test Users

```ruby
rails console

user = User.create!(
  first_name: "Test",
  last_name: "User",
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123",
  provider: "Internal"
)
```

### JWT Debugging

```ruby
# Decode a token
decoded = JsonWebToken.jwt_decode("your-jwt-token")
puts decoded

# Check expiration
expires_at = Time.at(decoded['expires_at'])
puts "Expires: #{expires_at}"
```

## Common Issues

### "Session expired" error

JWT tokens expire after 5 days. User needs to sign in again.

### Password reset email not sending

1. Check SMTP configuration in `application.yml`
2. Check Sidekiq is running for background jobs
3. Check logs: `tail -f log/development.log`

### OAuth authentication failing

1. Verify OAuth credentials in `application.yml`
2. Check redirect URIs match your configuration
3. Review OAuth provider dashboards for errors

## Architecture Patterns

See `AGENTS.md` for detailed information about:
- Authentication flow and strategies
- JWT token lifecycle
- Password reset implementation
- OAuth integration patterns
- Best practices and conventions

This file works with Claude Code, GitHub Copilot, Cursor, and other AI coding assistants.

## Support

For issues, questions, or contributions, please refer to the project repository.

## For AI Coding Assistants

This project includes an `AGENTS.md` file with detailed architecture, patterns, and conventions for AI coding assistants. If you're using Claude Code, GitHub Copilot, Cursor, or similar tools, refer to that file for comprehensive context about:

- Authentication flows and patterns
- JWT session management
- OAuth integration (Google, Apple, Facebook)
- Password security and reset flows
- API response formats
- Testing patterns
- Security best practices

The AGENTS.md file provides detailed examples and explanations to help AI assistants understand the codebase architecture.
