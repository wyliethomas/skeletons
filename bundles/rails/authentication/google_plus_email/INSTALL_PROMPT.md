# Email + Google OAuth Authentication Bundle - Installation Prompt

Copy and paste this prompt into your AI coding assistant to install authentication into your Rails project.

---

## 📋 Copy This Prompt:

```
I need to install the Email + Google OAuth authentication bundle into my Rails project.

Please follow these steps:

1. Download the authentication bundle from GitHub (no authentication required):

   Base URL: https://raw.githubusercontent.com/wyliethomas/skeletons/master/bundles/rails/authentication/google_plus_email

   Download these files to preload folder in current location:
   - README.md
   - BUNDLE_INFO.md
   - Gemfile.additions
   - models/user.rb
   - controllers/auth_controller.rb
   - controllers/concerns/authenticatable.rb
   - controllers/concerns/json_web_token.rb
   - migrations/create_users.rb
   - config/routes.rb

   All files are at: {Base URL}/{filepath}
   Example: https://raw.githubusercontent.com/wyliethomas/skeletons/master/bundles/rails/authentication/google_plus_email/README.md

2. Read the downloaded README.md and BUNDLE_INFO.md files to understand:
   - What features are included
   - Required dependencies
   - Installation steps
   - Potential conflicts with existing code

3. Check for conflicts:
   - Verify I don't already have Devise, Authlogic, or Clearance installed
   - Check if app/models/user.rb already exists (if so, ask me how to proceed)
   - Verify the routes don't conflict with existing routes

4. Install dependencies:
   - Add required gems from Gemfile.additions to my Gemfile
   - Run bundle install

5. Copy bundle files to my project:
   - Copy models/user.rb to app/models/user.rb
   - Copy controllers/auth_controller.rb to app/controllers/auth_controller.rb
   - Copy controllers/concerns/authenticatable.rb to app/controllers/concerns/authenticatable.rb
   - Copy controllers/concerns/json_web_token.rb to app/controllers/concerns/json_web_token.rb

6. Create and run migration:
   - Copy migrations/create_users.rb to db/migrate/ with current timestamp
   - Run rails db:migrate

7. Add routes:
   - Merge routes from config/routes.rb into my config/routes.rb
   - Show me the added routes

8. Update ApplicationController:
   - Add "include Authenticatable" to app/controllers/application_controller.rb
   - Show me the changes

9. Configure environment variables:
   - Add GOOGLE_CLIENT_ID to .env or config/application.yml
   - Generate JWT_SECRET_KEY using "rails secret" and add to .env
   - Show me what was added

10. Create basic auth views (optional):
    - Ask if I want you to generate signin/signup views
    - If yes, create minimal views in app/views/auth/
    - Include Google Sign-In button integration

11. Test the installation:
    - Show me how to test authentication manually
    - Provide curl commands to test the API endpoints

12. Give me a summary:
    - What was installed
    - How to use authentication in my controllers
    - Next steps (setting up Google OAuth, creating views, etc.)

Important: Before making any changes, show me what will be modified and ask for confirmation.
```

---

## What This Does

This prompt will:
1. Download and analyze the authentication bundle
2. Check for conflicts with your existing code
3. Install all required files and dependencies
4. Configure routes and environment variables
5. Set up database tables
6. Provide testing instructions

## Bundle Features

- ✅ Email/password authentication with BCrypt
- ✅ Google OAuth (Sign in with Google)
- ✅ JWT token management
- ✅ Session management (30-minute auto-expiry)
- ✅ Password reset flow
- ✅ User status management

## Requirements

Before running this prompt:
- Have a Rails 6.0+ project (use SCAFFOLD_PROMPT.md if you need one)
- Docker should be running (if using containerized setup)
- No existing authentication system (Devise, etc.)

## After Installation

You'll need to:
1. Set up Google OAuth credentials in Google Cloud Console
2. Create authentication views (or use as API-only)
3. Test the authentication flow
4. Customize as needed

## Environment Variables Required

```bash
GOOGLE_CLIENT_ID=your_google_client_id_here
JWT_SECRET_KEY=output_of_rails_secret_command
```

## Testing Authentication

After installation, test with:

```bash
# Create a user via API
curl -X POST http://localhost:3000/signup \
  -H "Content-Type: application/json" \
  -d '{"first_name":"Test","last_name":"User","email":"test@example.com","password":"password123","password_confirmation":"password123"}'

# Sign in
curl -X POST http://localhost:3000/signin \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## Troubleshooting

If the AI assistant encounters issues:
- Ask it to read the BUNDLE_INFO.md for compatibility information
- Check the README.md troubleshooting section
- Verify all environment variables are set correctly

## Example Usage Timeline

1. **Developer pastes prompt** → AI starts installation
2. **AI asks about conflicts** → Developer confirms to proceed
3. **AI installs files** → Shows what was added
4. **AI runs migration** → Database table created
5. **AI configures environment** → Shows required variables
6. **Installation complete** → Developer can start using authentication

## Related Bundles

After installing authentication, consider:
- Role-based authorization bundle (coming soon)
- User profile management bundle (coming soon)
- Two-factor authentication bundle (coming soon)
