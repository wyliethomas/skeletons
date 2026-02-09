# Rails Multitenant Project - Initial Prompt

[Back to README](../../README.md)

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to scaffold a new Rails multitenant project.

---

## Copy This Prompt:

```
I need to scaffold a new Rails multitenant project using a pre-built template.

Please follow these steps:

1. Download the Rails Multitenant template from GitHub (no authentication required):

   Download URL: https://github.com/wyliethomas/skeletons/archive/refs/heads/template/rails-multitenant.tar.gz

   Use curl to download and extract:
   - Download the archive to the current directory
   - Extract it to the current directory
   - The template files will be at: skeletons-template-rails-multitenant/

2. Ask me what I want to name my project.

3. Move the skeletons-template-rails-multitenant folder to my project name.
   Example: mv skeletons-template-rails-multitenant my-project-name

4. Clean up the temporary archive file.

5. Update the .env.example file in my new project:
   - Change any project-specific values to match my project name
   - Note that I'll need to create a .env file from .env.example

6. Give me a summary with:
   - Project location and name
   - What the template includes
   - Next steps for development
   - How to set up and run the project

Important: This downloads ONLY the Rails Multitenant template, not the entire repository.
```

---

## What This Does

This prompt will:
1. Download ONLY the Rails Multitenant template
2. Set up a new project with your chosen name
3. Prepare you to configure and start developing

## Template Includes

**Core Rails Setup:**
- Rails 8 application with modern conventions
- PostgreSQL database
- Tailwind CSS for styling
- Solid Cache, Queue, and Cable
- Kamal deployment configuration
- Dockerfile for containerization

**Multitenant Features:**
- Client model with URL key-based scoping
- User model with client associations
- JWT-based authentication
- Client scoping middleware
- Soft delete functionality
- URL key generation

**Admin Features:**
- Admin namespace with base controller
- Client management endpoints
- User management endpoints
- Admin privilege system

**Security:**
- Password strength validation
- Rack::Attack rate limiting
- Secure authentication system
- Client data isolation

**Development Tools:**
- Brakeman security scanner
- Bundler Audit for dependencies
- RuboCop for code quality
- CI configuration
- Test setup with Minitest

## Requirements

Before running this prompt:
- Ruby 3.3+ installed
- PostgreSQL installed (or use Docker)
- Your AI coding assistant ready

## After Scaffolding

1. Create your `.env` file:
```bash
cd your-project-name
cp .env.example .env
# Edit .env with your configuration
```

2. Set up the database:
```bash
bin/setup
```

3. Start the development server:
```bash
bin/dev
```

Your application will be available at: http://localhost:3000

## Key Features to Explore

### Multitenant Architecture
- **Client Scoping**: All requests are scoped to a client via URL key
- **Data Isolation**: Users and data are isolated per client
- **Flexible Setup**: Supports subdomain or path-based client routing

### Authentication
- **JWT Tokens**: Secure token-based authentication
- **Client Association**: Users are tied to specific clients
- **Admin System**: Separate admin privileges for cross-client access

### API Structure
- **Health Checks**: `/health` endpoint for monitoring
- **Auth Endpoints**: `/auth/login`, `/auth/register`, `/auth/me`
- **Client Management**: CRUD operations for clients (admin only)
- **User Management**: User administration per client

## Development Workflow

1. **Create a client**:
   ```bash
   rails console
   Client.create!(name: "Test Company", url_key: "test-co")
   ```

2. **Register a user** via API:
   ```bash
   curl -X POST http://localhost:3000/auth/register \
     -H "X-Client-Key: test-co" \
     -H "Content-Type: application/json" \
     -d '{"email":"user@test.com","password":"SecurePass123!"}'
   ```

3. **Login** to get JWT token:
   ```bash
   curl -X POST http://localhost:3000/auth/login \
     -H "X-Client-Key: test-co" \
     -H "Content-Type: application/json" \
     -d '{"email":"user@test.com","password":"SecurePass123!"}'
   ```

## Deployment

The template includes Kamal configuration for easy deployment:

```bash
# Configure your deploy.yml
# Then deploy:
kamal setup
kamal deploy
```

## Customization

See `CUSTOMIZATION.md` in your project for detailed guides on:
- Adding new client-scoped models
- Customizing authentication
- Configuring admin access
- Extending the API

---

**Documentation:** See `README.md` in your new project for complete details

## Differences from Rails API Template

The Multitenant template includes:
- Built-in client scoping system
- User and authentication system
- Admin namespace and privileges
- Soft delete functionality
- JWT authentication out of the box
- Client management endpoints

Use the standard [Rails API template](SCAFFOLD_RAILS_API.md) if you don't need multitenancy.

[Back to README](../../README.md)
