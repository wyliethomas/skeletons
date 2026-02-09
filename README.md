# Rails Multi-Tenant Seed Project

A production-ready Rails application seed with built-in multi-tenant architecture, authentication, and authorization. This project provides a solid foundation for building SaaS applications with client/organization isolation, role-based access control, and secure authentication.

## Features

### Core Architecture
- **Multi-Tenancy**: Client (organization) model with user isolation
- **URL-Based Identification**: 12-character alphanumeric URL keys for all resources
- **Soft Delete**: Audit-friendly data deletion with restore capabilities
- **Role-Based Access Control**: Super Admin, Admin, and Member roles

### Authentication & Security
- **Email/Password Authentication**: BCrypt-encrypted passwords with strength validation
- **Google OAuth**: Sign in with Google integration
- **JWT Tokens**: Secure session management
- **Password Reset**: Cryptographically secure token-based reset flow
- **Rate Limiting**: Rack::Attack protection against brute force attacks
- **Security Headers**: secure_headers gem for comprehensive protection
- **CSRF Protection**: Rails built-in CSRF protection enabled

### Frontend
- **Tailwind CSS**: Modern utility-first CSS framework
- **Hotwire**: Turbo and Stimulus for reactive interfaces
- **Importmap**: Zero-build JavaScript with ES modules

### Infrastructure Ready
- **PostgreSQL**: Production-grade database
- **Solid Cache & Queue**: Database-backed caching and background jobs
- **Docker Support**: Kamal deployment configuration included
- **Health Checks**: Built-in health endpoint for monitoring

## Tech Stack

- **Ruby**: 3.4.7 (configurable)
- **Rails**: 8.1.1
- **Database**: PostgreSQL
- **CSS**: Tailwind CSS 4.x
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Authentication**: BCrypt + JWT
- **Security**: rack-attack, secure_headers

## Quick Start

### Prerequisites

- Ruby 3.2+
- PostgreSQL 12+
- Redis (optional, for caching)

### Installation

1. **Clone and setup**:
   ```bash
   git clone <your-repo>
   cd rails-seed-multitenant
   bundle install
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Setup database**:
   ```bash
   rails db:create db:migrate db:seed
   ```

4. **Start the server**:
   ```bash
   bin/dev  # Uses Procfile.dev for Rails + Tailwind
   # OR
   rails server
   ```

5. **Access the application**:
   - Navigate to http://localhost:3000
   - Sign in with default credentials:
     - **Super Admin**: admin@example.com / Admin123!
     - **Demo Admin**: demo@example.com / Demo123!
     - **Member**: member@example.com / Member123!

   ⚠️ **IMPORTANT**: Change these passwords immediately in production!

## Project Structure

```
app/
├── controllers/
│   ├── concerns/           # Shared controller functionality
│   │   ├── authenticatable.rb      # Session-based authentication
│   │   ├── current_client.rb       # Multi-tenant context
│   │   └── json_web_token.rb       # JWT encoding/decoding
│   ├── admin/             # Super admin features
│   │   ├── base_controller.rb
│   │   ├── clients_controller.rb
│   │   └── users_controller.rb
│   ├── auth_controller.rb         # Authentication flows
│   ├── accounts_controller.rb     # User account management
│   ├── clients_controller.rb      # Client/organization management
│   └── health_controller.rb       # Health checks
├── models/
│   ├── concerns/
│   │   ├── urlkeyable.rb          # 12-char URL key generation
│   │   ├── soft_deletable.rb      # Soft delete functionality
│   │   └── admin_privileges.rb    # Role-based permissions
│   ├── client.rb                  # Tenant/organization model
│   └── user.rb                    # User with authentication
├── validators/
│   └── password_strength_validator.rb  # Strong password requirements
└── javascript/
    └── controllers/               # Stimulus controllers

config/
├── initializers/
│   └── rack_attack.rb            # Rate limiting configuration
├── routes.rb                     # Application routes
└── database.yml                  # Database configuration

db/
├── migrate/                      # Database migrations
└── seeds.rb                      # Seed data
```

## Core Models

### User
- **Authentication**: Email/password + Google OAuth
- **Roles**: super_admin, admin, member
- **Features**: Password reset, JWT sessions, API keys
- **Security**: BCrypt encryption, strength validation
- **Soft Delete**: Audit trail enabled

### Client
- **Multi-Tenant Root**: Organization/company entity
- **Relationships**: Has many users
- **Features**: URL key identification
- **Soft Delete**: Audit trail enabled

## Security Features

### Password Requirements
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one digit
- At least one special character

### Rate Limiting (Rack::Attack)
- Login attempts: 5 per 20 seconds (by IP and email)
- Signup attempts: 5 per hour (by IP)
- Password reset: 3 per hour (by IP and email)
- API requests: 300 per 5 minutes (by IP)

### Session Management
- Automatic expiry after 30 minutes of inactivity
- Refresh on each request
- Secure session storage

## Usage Examples

### Creating a New Client

```ruby
client = Client.create(name: "ACME Corp")
admin_user = client.users.create(
  first_name: "John",
  last_name: "Doe",
  email: "john@acme.com",
  password: "SecurePass123!",
  password_confirmation: "SecurePass123!",
  role: "admin"
)
```

### Role-Based Authorization

```ruby
# In your controllers
class ProjectsController < ApplicationController
  before_action :require_admin, only: [:destroy]

  private

  def require_admin
    unless current_user.can_manage_team?
      redirect_to root_path, alert: "Access denied"
    end
  end
end
```

### Multi-Tenant Queries

```ruby
# CurrentClient concern provides current_client method
class ProjectsController < ApplicationController
  def index
    # Automatically scoped to current user's client
    @projects = current_client.projects
  end
end
```

## Customization

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for detailed guide on:
- Adding new models
- Customizing authentication
- Extending authorization
- Adding features to the admin panel
- Customizing the UI

## Environment Variables

Key environment variables (see `.env.example` for full list):

```bash
# Database
DATABASE_HOST=localhost
DATABASE_NAME=rails_seed_multitenant_development

# Security
SECRET_KEY_BASE=<generate with: rails secret>
JWT_SECRET_KEY=<generate with: openssl rand -hex 64>

# Google OAuth (optional)
GOOGLE_CLIENT_ID=your_client_id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret

# Email (for password reset)
SMTP_ADDRESS=smtp.gmail.com
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
```

## Deployment

This project includes Kamal configuration for Docker-based deployment:

```bash
# Setup (first time)
kamal setup

# Deploy updates
kamal deploy

# Other commands
kamal app logs
kamal app console
kamal app restart
```

See `config/deploy.yml` for Kamal configuration.

## Development

### Running Tests
```bash
rails test
# or
rspec  # if you add RSpec
```

### Code Quality
```bash
bundle exec rubocop          # Ruby style checking
bundle exec brakeman         # Security scanning
bundle exec bundler-audit    # Gem vulnerability checking
```

### Database Console
```bash
rails console
# or
rails dbconsole
```

## Production Checklist

Before deploying to production:

- [ ] Change all default passwords
- [ ] Set strong SECRET_KEY_BASE
- [ ] Set strong JWT_SECRET_KEY
- [ ] Configure production database
- [ ] Set up email delivery (SMTP or service)
- [ ] Configure Google OAuth (if using)
- [ ] Review rack-attack rate limits
- [ ] Set up SSL/TLS certificates
- [ ] Configure application host URL
- [ ] Set up monitoring and logging
- [ ] Review and customize error pages
- [ ] Set up database backups
- [ ] Configure CORS if needed for API

## Architecture Decisions

### Why URL Keys Instead of IDs?
- **Security**: Prevents enumeration attacks
- **UX**: Clean, shareable URLs
- **Flexibility**: Decouples URLs from database IDs

### Why Soft Delete?
- **Audit Trail**: Compliance and debugging
- **Data Recovery**: Restore accidentally deleted data
- **Referential Integrity**: Maintain relationships

### Why Super Admin Role?
- **Platform Management**: Manage all clients
- **Support**: Help customers debug issues
- **Analytics**: Cross-client reporting

## Contributing

This is a seed project meant to be forked and customized. Feel free to:
- Remove features you don't need
- Add your own models and controllers
- Customize the UI
- Extend authentication/authorization

## License

This seed project is released as open source. Use it however you like!

## Credits

Extracted from PXP Consultant - a production Rails application built by PXP Consulting.
