# Bundle Metadata

## Bundle Information

**Bundle Name:** Email + Google OAuth Authentication
**Bundle ID:** `google_plus_email`
**Category:** Authentication
**Framework:** Ruby on Rails
**Version:** 1.0.0
**Last Updated:** 2025-01-13
**Status:** Production-Ready

## Description

Complete authentication system with email/password and Google OAuth support. Extracted from 3 production Rails applications with proven reliability.

## Features

- [x] Email/password authentication with BCrypt
- [x] Google OAuth (Sign in with Google)
- [x] JWT token-based authentication
- [x] Session management with auto-expiry (30 minutes)
- [x] Password reset flow with email
- [x] User status management (ACTIVE, INACTIVE, PENDING, BANNED)
- [x] Unique API key generation per user
- [x] Protection against timing attacks
- [x] Secure password hashing (BCrypt cost factor 10)

## Compatibility

### Rails Versions
- ✅ Rails 6.0+
- ✅ Rails 6.1
- ✅ Rails 7.0+
- ✅ Rails 7.1

### Ruby Versions
- ✅ Ruby 2.7+
- ✅ Ruby 3.0+
- ✅ Ruby 3.1+
- ✅ Ruby 3.2+

### Databases
- ✅ PostgreSQL
- ✅ MySQL
- ✅ SQLite (development only)

## Dependencies

### Required Gems
```ruby
bcrypt (~> 3.1.7)        # Password hashing
jwt                       # JSON Web Tokens
google-id-token          # Google OAuth verification
```

### Optional Gems
```ruby
figaro                   # Environment variable management
```

### System Dependencies
- None (pure Ruby/Rails)

## Files Included

| File Path | Purpose | Required |
|-----------|---------|----------|
| `models/user.rb` | User model with auth logic | ✅ Yes |
| `controllers/auth_controller.rb` | Authentication endpoints | ✅ Yes |
| `controllers/concerns/authenticatable.rb` | Session management | ✅ Yes |
| `controllers/concerns/json_web_token.rb` | JWT service | ✅ Yes |
| `migrations/create_users.rb` | Database schema | ✅ Yes |
| `config/routes.rb` | Route definitions | ✅ Yes |
| `Gemfile.additions` | Required gems | ✅ Yes |
| `README.md` | Installation guide | ℹ️ Documentation |
| `BUNDLE_INFO.md` | This file | ℹ️ Metadata |

## Environment Variables Required

| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `GOOGLE_CLIENT_ID` | Google OAuth Client ID | `123456.apps.googleusercontent.com` | ✅ Yes (for OAuth) |
| `JWT_SECRET_KEY` | Secret key for JWT signing | `rails secret` output | ✅ Yes |

## Installation Complexity

**Difficulty:** ⭐⭐ Intermediate

**Estimated Time:** 15-30 minutes

**Steps Required:**
1. Add gems to Gemfile
2. Copy 4 files to project
3. Run migration
4. Add routes
5. Configure environment variables
6. Create views (optional)

## Breaking Changes

None - This is a self-contained bundle that doesn't override existing functionality.

## Conflicts

### Known Conflicts
- ❌ Devise gem (both provide authentication)
- ❌ Authlogic gem (both provide authentication)
- ❌ Clearance gem (both provide authentication)

### Compatible With
- ✅ CanCanCan (authorization)
- ✅ Pundit (authorization)
- ✅ Rolify (role management)
- ✅ ActiveAdmin
- ✅ Sidekiq
- ✅ Action Cable

## Customization Points

### Easy to Customize
- Session expiry time (default: 30 minutes)
- JWT expiry time (default: 5 days)
- Password requirements (length, format)
- User statuses
- Redirect paths after authentication
- Email templates

### Moderate Customization
- Adding additional OAuth providers (Apple, Facebook)
- Multi-factor authentication
- Remember me functionality
- Account lockout after failed attempts

## Security Features

- ✅ BCrypt password hashing (cost factor 10)
- ✅ Secure random API key generation
- ✅ JWT token expiry
- ✅ Session timeout
- ✅ Password reset token regeneration
- ✅ Email normalization (downcasing)
- ✅ CSRF protection (Rails default)

## Testing Status

**Extracted From:** 3 production applications
- coachlab (in production)
- saaslab_ecomm (in production)
- saaslab_seed (in production)

**Test Coverage:** Not included (extract from production code)

**Recommended Tests:**
- Unit tests for User model
- Integration tests for authentication flow
- OAuth callback tests
- Password reset flow tests

## Performance Considerations

### Database Queries
- Indexed columns: `email`, `apikey`, `password_reset_key`, `status`, `oauth_sub`
- Average queries per auth: 1-2 SELECT queries

### Memory Usage
- Minimal (standard Rails controller/model)
- BCrypt hashing: ~50-100ms per password hash

### Caching Opportunities
- User lookup by apikey (cache user object)
- JWT validation results (cache for token expiry)

## Known Limitations

1. **Views Not Included** - Controllers provided but views must be created
2. **Single OAuth Provider** - Only Google included (Apple/Facebook in source but not bundled)
3. **Email Mailer** - Password reset mailer commented out (needs ActionMailer config)
4. **No Account Management** - User CRUD operations not included (only auth)

## Migration Path

### From Devise
1. Export users table data
2. Map Devise columns to bundle columns
3. Re-hash passwords (users must reset)
4. Update authentication calls

### From Custom Auth
1. Review existing User model
2. Merge authentication methods
3. Run migration to add missing columns
4. Test authentication flow

## Support & Maintenance

**Maintainer:** PXP Development Team
**Source:** Extracted from production codebases
**Updates:** As needed based on production usage

## License

MIT License - Free for commercial and open-source use

## Changelog

### Version 1.0.0 (2025-01-13)
- Initial bundle creation
- Extracted from 3 production applications
- Includes email/password and Google OAuth
- Full session and JWT management
- Password reset functionality

## AI Integration Notes

### For AI Code Assistants

This bundle is designed to be AI-parseable and installable. When installing:

1. **Read README.md first** - Contains step-by-step installation
2. **Check conflicts** - Verify no existing auth system (Devise, etc.)
3. **Follow order** - Gems → Files → Migration → Routes → Config
4. **Generate views** - Create auth views based on project style
5. **Test auth flow** - Verify signin, signup, OAuth work

### Auto-Installation Command

```bash
# For AI assistants - automate installation
bundle exec rails runner "$(cat <<'RUBY'
  # Copy files
  FileUtils.cp 'bundles/rails/authentication/google_plus_email/models/user.rb',
               'app/models/user.rb'
  FileUtils.cp 'bundles/rails/authentication/google_plus_email/controllers/auth_controller.rb',
               'app/controllers/auth_controller.rb'
  # ... continue for other files

  # Run migration
  system('rails db:migrate')

  puts 'Authentication bundle installed!'
RUBY
)"
```

## Related Bundles

### Future Bundles
- `authentication/oauth_multi` - Multiple OAuth providers
- `authentication/two_factor` - 2FA with TOTP
- `authorization/role_based` - Role-based access control
- `user_management/profile` - User profile management

## Tags

`authentication`, `oauth`, `google`, `jwt`, `bcrypt`, `session`, `login`, `signup`, `password-reset`, `rails`, `ruby`, `production-ready`
