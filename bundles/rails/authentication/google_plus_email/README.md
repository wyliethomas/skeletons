# Email + Google OAuth Authentication Bundle

Complete authentication system with email/password and Google OAuth support.

## Overview

This bundle provides a drop-in authentication system for Rails applications with:

- ✓ Email/password authentication with BCrypt
- ✓ Google OAuth (Sign in with Google)
- ✓ JWT token management
- ✓ Password reset flow
- ✓ Session management with 30-minute auto-expiry
- ✓ User status management (ACTIVE, INACTIVE, PENDING, BANNED)
- ✓ Unique API key generation per user

---

## Copy This Prompt

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to install authentication into your Rails project.

**Note:** Use this after scaffolding your Rails API project with the [Rails API scaffold prompt](../../../../documentation/rails/SCAFFOLD_RAILS_API.md).

```
I need to install the Email + Google OAuth authentication bundle into my Rails project.

Please follow these steps:

1. Download the authentication bundle from GitHub (no authentication required):

   Base URL: https://raw.githubusercontent.com/wyliethomas/skeletons/master/bundles/rails/authentication/google_plus_email

   Download these files to a temporary folder:
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

2. Read the downloaded README.md and BUNDLE_INFO.md files to understand what features are included.

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
   - Run rails db:migrate (or docker compose exec web rails db:migrate if using Docker)

7. Add routes:
   - Merge routes from config/routes.rb into my config/routes.rb
   - Show me the added routes

8. Update ApplicationController:
   - Add "include Authenticatable" to app/controllers/application_controller.rb

9. Configure environment variables:
   - Add GOOGLE_CLIENT_ID to .env
   - Generate JWT_SECRET_KEY using "rails secret" and add to .env
   - Show me what was added

10. Give me a summary with:
    - What was installed
    - How to use authentication in my controllers
    - How to test with curl commands
    - Next steps (setting up Google OAuth credentials)

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

## Requirements

Before running this prompt:
- Have a Rails 6.0+ project (use the scaffold prompt if you need one)
- Docker should be running (if using containerized setup)
- No existing authentication system (Devise, etc.)

## After Installation

You'll need to:
1. Set up Google OAuth credentials in [Google Cloud Console](https://console.cloud.google.com/)
2. Test the authentication flow
3. Create authentication views (optional - works as API-only)
4. Customize as needed

---

## What's Included

```
authentication/google_plus_email/
├── models/
│   └── user.rb                          # User model with auth logic
├── controllers/
│   ├── auth_controller.rb               # Auth endpoints (signin, signup, OAuth)
│   └── concerns/
│       ├── authenticatable.rb           # Session management concern
│       └── json_web_token.rb            # JWT encoding/decoding
├── migrations/
│   └── create_users.rb                  # Database migration
├── config/
│   └── routes.rb                        # Routes configuration
├── Gemfile.additions                    # Required gems
└── README.md                            # This file
```

## Installation Steps for AI Assistants

### 1. Add Required Gems

Copy gems from `Gemfile.additions` to the project's `Gemfile`:

```ruby
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'google-id-token'
gem 'figaro'  # Optional but recommended
```

Then run:
```bash
bundle install
```

### 2. Copy Files to Project

Copy bundle files to the Rails project:

```bash
# User model
cp models/user.rb app/models/user.rb

# Controllers
cp controllers/auth_controller.rb app/controllers/auth_controller.rb
cp controllers/concerns/authenticatable.rb app/controllers/concerns/authenticatable.rb
cp controllers/concerns/json_web_token.rb app/controllers/concerns/json_web_token.rb
```

### 3. Run Migration

Copy migration to db/migrate with timestamp:

```bash
# Get current timestamp
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Copy migration with timestamp
cp migrations/create_users.rb "db/migrate/${TIMESTAMP}_create_users.rb"

# Run migration
rails db:migrate
```

### 4. Add Routes

Add routes from `config/routes.rb` to `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Email/Password Authentication
  get  '/signin',  to: 'auth#signin',  as: :signin
  post '/signin',  to: 'auth#signin_do'
  get  '/signup',  to: 'auth#signup',  as: :signup
  post '/signup',  to: 'auth#signup_do'
  get  '/signout', to: 'auth#signout', as: :signout

  # Google OAuth
  post '/gsi',         to: 'auth#gsi'
  get  '/gsi/session', to: 'auth#gsi_session', as: :gsi_session

  # Password Reset
  get  '/forgot',          to: 'auth#forgot',          as: :forgot
  post '/forgot',          to: 'auth#forgot_do'
  get  '/reset-password/:reset_token', to: 'auth#reset_password', as: :reset_password
  post '/reset-password',  to: 'auth#reset_password_do'

  # Your other routes...
end
```

### 5. Include Authenticatable in ApplicationController

Add the concern to `app/controllers/application_controller.rb`:

```ruby
class ApplicationController < ActionController::Base
  include Authenticatable

  # Use before_action in controllers that need authentication
  # before_action :authenticate_user
end
```

### 6. Configure Environment Variables

Add these environment variables to your `.env` file (if using Figaro) or Rails credentials:

```bash
# .env or config/application.yml (Figaro)
GOOGLE_CLIENT_ID=your_google_client_id
JWT_SECRET_KEY=your_jwt_secret_key_here
```

Generate a secure JWT secret:
```bash
rails secret
```

### 7. Set Up Google OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized JavaScript origins and redirect URIs
6. Copy Client ID to `GOOGLE_CLIENT_ID` environment variable

### 8. Create Views (Optional)

The bundle includes controller actions but not views. Create these views:

```
app/views/auth/
├── signin.html.erb       # Sign in form
├── signup.html.erb       # Sign up form
├── forgot.html.erb       # Password reset request
└── reset_password.html.erb  # Password reset form
```

Example signin form:
```erb
<!-- app/views/auth/signin.html.erb -->
<%= form_with url: signin_path, method: :post do |f| %>
  <%= f.email_field :email, placeholder: "Email", required: true %>
  <%= f.password_field :password, placeholder: "Password", required: true %>
  <%= f.submit "Sign In" %>
<% end %>

<!-- Google Sign In button -->
<div id="g_id_onload"
     data-client_id="<%= ENV['GOOGLE_CLIENT_ID'] %>"
     data-callback="handleGoogleSignIn">
</div>
<div class="g_id_signin" data-type="standard"></div>

<script src="https://accounts.google.com/gsi/client" async defer></script>
<script>
function handleGoogleSignIn(response) {
  fetch('/gsi', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ credential: response.credential })
  })
  .then(res => res.json())
  .then(data => {
    if (data.apikey) {
      window.location.href = `/gsi/session?user_apikey=${data.apikey}`;
    }
  });
}
</script>
```

## Usage

### Protecting Routes

Add authentication to any controller:

```ruby
class DashboardController < ApplicationController
  before_action :authenticate_user

  def index
    # @current_user is available here
  end
end
```

### Manual Authentication

```ruby
# Authenticate with email/password
user = User.authenticate('email@example.com', 'password')

# Create new user
user = User.create(
  first_name: 'John',
  last_name: 'Doe',
  email: 'john@example.com',
  password: 'secure_password',
  password_confirmation: 'secure_password'
)

# Generate JWT token
user.update_session
token = user.jwt

# Decode JWT
payload = JsonWebToken.jwt_decode(token)

# Validate JWT
valid = JsonWebToken.validate(payload)
```

## Database Schema

The migration creates a `users` table with:

| Column | Type | Description |
|--------|------|-------------|
| first_name | string | User's first name |
| last_name | string | User's last name |
| email | string | Email (unique, indexed) |
| password_hash | string | BCrypt password hash |
| password_salt | string | BCrypt salt |
| password_reset_key | string | Password reset token |
| apikey | string | Unique API key (indexed) |
| status | string | User status (ACTIVE, INACTIVE, PENDING, BANNED) |
| provider | string | OAuth provider (Google, Apple, etc.) |
| oauth_sub | string | OAuth subject ID |
| jwt | text | Current JWT token |
| signed_in | boolean | Session status |

## Configuration Options

### JWT Expiry

Default: 5 days. To customize:

```ruby
# In controllers/concerns/json_web_token.rb
JsonWebToken.jwt_encode(user, 24.hours.from_now)
```

### Session Expiry

Default: 30 minutes. To customize:

```ruby
# In controllers/concerns/authenticatable.rb
# Change: if session[:expiry_time] >= 30.minutes.ago.to_s
if session[:expiry_time] >= 1.hour.ago.to_s
```

### Password Requirements

Default: 8 characters minimum, must contain at least one letter

To customize, edit `app/models/user.rb`:

```ruby
validates_length_of :password, on: :create, minimum: 12
validates_format_of :password, on: :create,
                    with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}\Z/,
                    message: 'must include uppercase, lowercase, and number'
```

## Troubleshooting

### Common Issues

**1. "uninitialized constant JsonWebToken"**
- Ensure `controllers/concerns/json_web_token.rb` is in the correct location
- Restart Rails server

**2. "JWT secret key not set"**
- Add `JWT_SECRET_KEY` to environment variables
- Generate with `rails secret`

**3. "Google authentication not working"**
- Verify `GOOGLE_CLIENT_ID` is set correctly
- Check Google Cloud Console for authorized origins
- Ensure `google-id-token` gem is installed

**4. "Password reset emails not sending"**
- Uncomment mailer line in `auth_controller.rb`
- Configure ActionMailer in `config/environments/`

## Security Considerations

- Passwords are hashed with BCrypt (cost factor 10)
- JWT tokens expire after 5 days by default
- Sessions expire after 30 minutes of inactivity
- Password reset tokens are regenerated after use
- Email addresses are downcased before storage
- API keys are cryptographically random

## Testing

Example RSpec tests:

```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe '.authenticate' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    it 'authenticates with correct credentials' do
      expect(User.authenticate('test@example.com', 'password123')).to eq(user)
    end

    it 'fails with incorrect password' do
      expect(User.authenticate('test@example.com', 'wrong')).to be_nil
    end
  end
end
```

## Dependencies

- Ruby 2.7+
- Rails 6.0+
- PostgreSQL or MySQL (any database with string/text support)

## License

MIT License - Free to use in commercial and open-source projects

## Support

This bundle was extracted from production Rails applications. For issues or questions, consult the project maintainer.
