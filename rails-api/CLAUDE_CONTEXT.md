# CLAUDE_CONTEXT.md - Rails API Architecture

This document explains the architecture, patterns, and conventions used in this Rails API project with comprehensive authentication. Use this as a comprehensive guide when extending or modifying the codebase.

## Architecture Overview

This is a **Rails 7 API-only** application with **comprehensive authentication** following these principles:

1. **Multiple Auth Strategies** - Email/password, Google, Apple, Facebook
2. **JWT Session Management** - Token-based with 5-day expiry, stored in user record
3. **Custom BCrypt** - Not using `has_secure_password`, custom salt+hash
4. **API-First Design** - JSON responses via Jbuilder
5. **Figaro for Secrets** - Environment variables via `application.yml`

## Authentication Flow

### 1. User Sign Up Flow

```ruby
# POST /api/v1/signup
def signup
  @user = User.new(user_params)
  @user.provider = 'Internal'  # Mark as email/password user

  if @user.save
    @user.update_session       # Generate JWT
  end
end
```

**What happens on `@user.save`:**
1. `downcase_email` - Email normalized to lowercase
2. `set_apikey` - Unique API key generated
3. `set_status` - Status set to "ACTIVE"
4. `encrypt_password` - BCrypt hash + salt generated
5. Validations run (email uniqueness, password strength, etc.)

### 2. Session Management (`update_session`)

```ruby
def update_session
  update!(
    jwt: JsonWebToken.jwt_encode(self),
    signed_in: true
  )
end
```

This:
- Generates JWT with user data + 5-day expiry
- Stores JWT in user record (allows single-session per user)
- Marks user as signed_in

### 3. JWT Structure

```ruby
# app/controllers/concerns/json_web_token.rb
def self.jwt_encode(user, exp = 5.days.from_now)
  payload = {
    user_key: user.apikey,
    first_name: user.first_name,
    last_name: user.last_name,
    name: user.name,
    email: user.email,
    expires_at: exp.to_i
  }
  JWT.encode(payload, Figaro.env.lockbox_key)
end
```

**Key points:**
- Uses `user.apikey` (not user ID) as identifier
- Signed with `Figaro.env.lockbox_key` (from application.yml)
- 5-day default expiration

### 4. Authenticated Request Flow

```
Client Request
  ↓
ApplicationController
  ↓
authenticate_request (before_action)
  ↓
set_current_user
  ├── Extract Bearer token
  ├── jwt_decode(token)
  ├── Find user by apikey + status ACTIVE
  ├── JsonWebToken.validate (check expiry)
  └── Verify user.signed_in == true
  ↓
@current_user available in controller
```

**Implementation:**
```ruby
def set_current_user
  bearer_token = request.headers['Authorization']
  bearer_token = bearer_token.split('Bearer ').last&.strip if bearer_token
  decoded = JsonWebToken.jwt_decode(bearer_token)

  user = User.find_by(apikey: decoded['user_key'], status: "ACTIVE")
  return error_response(msg: "User not found.", status_code: 404) if user.nil?

  valid = JsonWebToken.validate(decoded, user)
  unless valid && user&.signed_in
    return error_response(msg: "Session expired. Please login.", status_code: 401)
  end

  @current_user = user
end
```

### 5. Sign Out Flow

```ruby
def signout
  if current_user.update(signed_in: false, jwt: nil)
    render json: { message: 'Signed out' }, status: :ok
  end
end
```

This invalidates the session by:
- Setting `signed_in = false`
- Clearing the `jwt` field

Even if someone has the old token, they can't use it because the validation checks `user.signed_in`.

## Password Security

### Custom BCrypt Implementation

**Why not `has_secure_password`?**
This project uses custom BCrypt for more control:

```ruby
# On Create/Update
def encrypt_password
  if password.present? && !new_password.present?
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  elsif new_password.present?
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(new_password, password_salt)
  end
end
```

**Authentication:**
```ruby
def self.authenticate(email, password)
  user = find_by_email(email)
  if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    return user
  else
    return nil
  end
end
```

### Password Reset Flow

**Two-factor approach: Token + Code**

#### Step 1: Request Reset
```ruby
def forgot_password
  user = User.find_by_email(params[:forgot_password][:email])
  if user && user.provider == "Internal"  # Only for email/password users
    code = set_passcode  # Generate 4-char code (e.g., "A3K9")
    user.update(
      password_reset_key: SecureRandom.uuid,
      password_reset_expires: 10.minutes.from_now,
      password_reset_code: code
    )

    # Email with link + code
    UserMailer.with(user: user, token: user.password_reset_key, code: code)
               .forgot_password.deliver_now
  end
end
```

**Generates:**
- `password_reset_key` - UUID in the email link
- `password_reset_code` - 4-character code displayed in email
- `password_reset_expires` - 10-minute window

**Why both token and code?**
- Token: Prevents brute force on password reset endpoints
- Code: Extra verification, easy to copy from email

#### Step 2: Reset Password
```ruby
def reset_password
  @user = User.find_by(password_reset_key: params[:password_reset][:token])

  if @user && @user.password_reset_code == params[:password_reset][:code]
    if @user.password_reset_expires > 30.minutes.ago  # Check not expired
      if @user.update(new_password: params[:password_reset][:password], ...)
        @user.update(password_reset_key: nil, password_reset_code: nil, ...)
        render json: { jwt: JsonWebToken.jwt_encode(@user) }, status: :ok
      end
    end
  end
end
```

**Returns new JWT on success** - User is automatically logged in.

## OAuth Integration

### Google Sign-In

```ruby
def self.from_gsi(payload)
  user = User.find_by_email(payload[:email])

  if !user  # New user
    password = SecureRandom.hex(15)  # Random password (not used)
    user = User.new(
      email: payload["email"],
      first_name: payload[:given_name],
      last_name: payload[:family_name],
      provider: 'Google',
      oauth_sub: payload[:sub],  # Google user ID
      password: password,
      password_confirmation: password
    )
    user.save
  end

  return user
end
```

**Key Points:**
- Find existing user by email
- If new, create with random password (OAuth users don't use password auth)
- Store `oauth_sub` (Google's unique user ID)
- Set `provider = 'Google'`
- Password reset only works for `provider == 'Internal'`

### Apple Sign-In

```ruby
def self.from_apple(payload)
  id_token = payload["authorization"]["id_token"]
  token_data = apple_cert(id_token)  # Verify Apple JWT

  if token_data["email"]
    user = User.find_by_email(token_data['email'])
    if !user
      # Create new user similar to Google
      user = User.new(
        email: token_data['email'],
        first_name: payload['user']['name']['firstName'],
        last_name: payload['user']['name']['lastName'],
        provider: 'Apple',
        oauth_sub: token_data['sub']
      )
    end
  end

  return user
end
```

**Note:** `apple_cert` method needs to be implemented to verify Apple's JWT tokens.

### Facebook Auth

```ruby
def self.from_fb(id, name)
  email = "#{id}@fb.meta"  # Facebook doesn't always provide email
  user = User.find_by_email(email)

  if !user
    name = name.split(" ")
    user = User.new(
      email: email,
      first_name: name.first,
      last_name: name.last,
      provider: 'Facebook',
      oauth_sub: nil  # Facebook ID is in email
    )
  end

  return user
end
```

**Pattern:** Create synthetic email when real email not available.

## User Status System

Users have four statuses:

```ruby
USER_STATUSES = ['ACTIVE', 'INACTIVE', 'PENDING', 'BANNED']
```

**Usage:**
- **ACTIVE** - Default. Can authenticate and use API.
- **INACTIVE** - Temporarily disabled. Cannot authenticate.
- **PENDING** - Awaiting approval/verification. Cannot authenticate.
- **BANNED** - Permanently blocked. Cannot authenticate.

**Enforcement:**
```ruby
# In set_current_user
user = User.find_by(apikey: decoded['user_key'], status: "ACTIVE")
```

Only ACTIVE users can get past authentication.

**Scope:**
```ruby
scope :for_status, ->(status) { where("status = ?", status) if status.present? }

# Usage
User.for_status('ACTIVE')
User.for_status('BANNED')
```

## Response Format (Jbuilder)

### Sign In/Sign Up Response

```ruby
# app/views/api/v1/welcome/signin.json.jbuilder
json.user do
  json.jwt @user.jwt
  json.user_key @user.apikey
  json.email @user.email
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.name @user.name
  json.status @user.status
  json.role @user.role
end
```

**Returns:**
```json
{
  "user": {
    "jwt": "eyJhbG...",
    "user_key": "abc123",
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "name": "John Doe",
    "status": "ACTIVE",
    "role": null
  }
}
```

## Controller Patterns

### Welcome Controller (No Auth Required)

```ruby
class Api::V1::WelcomeController < ApplicationController
  before_action :current_user, only: [:signout]
  before_action :authenticate_request, only: [:signout]
```

**Key Points:**
- Inherits from `ApplicationController`
- Signup/signin endpoints don't require authentication
- `authenticate_request` only for signout (needs JWT)

### Authenticated Controllers

```ruby
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_request  # All actions need auth

  def index
    @users = User.all
    # @current_user available
  end
end
```

## Error Handling Pattern

Consistent error responses:

```ruby
def error_response(msg:, status_code:)
  render json: {error: msg}, status: status_code
end

# Usage
return error_response(msg: "User not found", status_code: 404)
return error_response(msg: @user.errors.full_messages, status_code: 422)
```

**Always returns:**
```json
{
  "error": "Error message or array of messages"
}
```

## Configuration (Figaro)

### Why Figaro over dotenv?

- Environment-specific config (development, test, production)
- Heroku-friendly (`figaro heroku:set`)
- Structured YAML format
- Can use ERB in values

### Structure

```yaml
# config/application.yml
lockbox_key: "secret-key"
google_client_id: "client-id"

development:
  database_url: "postgresql://localhost/dev_db"

production:
  database_url: <%= ENV['DATABASE_URL'] %>
```

### Access

```ruby
Figaro.env.lockbox_key
Figaro.env.google_client_id
```

## Adding New Features

### Adding a New Auth Method

1. **Add method to User model:**
```ruby
def self.from_github(payload)
  user = User.find_by_email(payload[:email])
  if !user
    # Create user logic
  end
  return user
end
```

2. **Add controller action:**
```ruby
def github_auth
  @user = User.from_github(params[:data])
  if @user.present?
    @user.update_session
    render :signin
  end
end
```

3. **Add route:**
```ruby
post 'auth/github', to: 'welcome#github_auth'
```

### Adding a New Resource

1. **Generate model:**
```bash
rails g model Post title:string body:text user:references
rails db:migrate
```

2. **Add controller:**
```ruby
class Api::V1::PostsController < ApplicationController
  before_action :authenticate_request

  def index
    @posts = Post.where(user: @current_user)
    render json: @posts
  end
end
```

3. **Add routes:**
```ruby
namespace :api do
  namespace :v1 do
    resources :posts
  end
end
```

## Testing Patterns

### Model Tests

```ruby
RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe ".authenticate" do
    it "returns user with valid credentials" do
      user = create(:user, password: "password123")
      result = User.authenticate(user.email, "password123")
      expect(result).to eq(user)
    end
  end
end
```

### Request Tests

```ruby
RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:jwt) { JsonWebToken.jwt_encode(user) }

  describe "GET /api/v1/users" do
    it "returns users" do
      get "/api/v1/users", headers: { Authorization: "Bearer #{jwt}" }

      expect(response).to have_http_status(:ok)
    end
  end
end
```

## Security Best Practices

1. **JWT Secret** - Use strong secret, never commit to git
2. **Password Validation** - Enforce strong passwords (8+ chars, letters required)
3. **Email Normalization** - Always downcase emails
4. **Email Uniqueness** - Email unique globally across all users
5. **Status Checks** - Only ACTIVE users can authenticate
6. **OAuth Providers** - Only allow password reset for provider='Internal'
7. **Token Expiry** - 5-day JWT expiry enforced
8. **Single Session** - JWT stored in user record, old tokens invalid on new login
9. **Password Reset Window** - 10-minute expiry on reset tokens
10. **HTTPS Only** - Always use SSL/TLS in production

## Common Patterns

### Scope to Current User

```ruby
def index
  @posts = @current_user.posts
end
```

### Check User Permission

```ruby
def check_admin_role
  return error_response(msg: "Forbidden", status_code: 403) unless @current_user.role == 'admin'
end
```

## Conventions Summary

1. **Controllers** - Namespace under `Api::V1`
2. **Routes** - All under `/api/v1/`
3. **Auth** - `before_action :authenticate_request` for protected endpoints
4. **Errors** - Use `error_response(msg:, status_code:)` helper
5. **JSON** - Use Jbuilder for complex responses
6. **Secrets** - Figaro `application.yml`, never commit
7. **OAuth** - Set `provider` field, store `oauth_sub`
8. **Passwords** - Custom BCrypt, not `has_secure_password`
9. **Status Management** - Use ACTIVE, INACTIVE, PENDING, BANNED statuses
10. **API Keys** - Each user has unique apikey for identification

---

**When in doubt:** Look at `WelcomeController` for auth patterns, `User` model for authentication logic, and `ApplicationController` for middleware patterns.
