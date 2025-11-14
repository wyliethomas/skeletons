# Project Skeletons

Battle-tested starter skeleton for rapid application development. Get started in seconds with opinionated, production-ready bones.

## Features

- ** Fast Setup** - Go from zero to coding in under a minute
- ** Docker Ready** - All templates include Docker configurations
- ** Production Patterns** - Best practices baked in from day one
- ** Security First** - JWT auth, environment variables, proper CORS
- ** Well Documented** - Each template includes comprehensive documentation
- ** AI-Friendly** - AGENTS.md files work with Claude Code, GitHub Copilot, Cursor, and other AI coding assistants

## Available Templates

### Rails API
**Perfect starter for:** Backend APIs, microservices, SaaS platforms

**Includes:**
- Rails 7 in API mode
- JWT authentication with refresh tokens
- PostgreSQL database
- Redis for caching and sessions
- Sidekiq for background jobs
- Docker & Docker Compose
- RSpec test suite
- Figaro for environment management
- CORS configuration
- Health check endpoints

- [Rails API Documentation](documentation/rails/SCAFFOLD_RAILS_API.md)

### React App
**Perfect starter for:** Single-page applications, admin dashboards, web apps

**Includes:**
- Vite for lightning-fast builds
- React 18 with hooks
- TypeScript for type safety
- Tailwind CSS for styling
- React Router for navigation
- Axios for API calls
- Docker development environment
- Hot module replacement (HMR)
- ESLint + Prettier
- Production build optimization

### Go Microservice
**Perfect starter for:** High-performance APIs, system services, CLI tools

**Includes:**
- Chi HTTP router
- Structured logging
- Environment configuration
- Graceful shutdown handling
- Docker multi-stage builds
- Makefile for common tasks
- Unit test setup
- CORS middleware
- Health check endpoints

## 📦 Feature Bundles

**Drop-in feature bundles** extracted from production applications. Install complete features with all layers (models, controllers, migrations, routes) in minutes.

### Available Bundles

#### Authentication: Email + Google OAuth
**Status:** ✅ Production-Ready
**For:** Rails applications
**Features:** Email/password + Google Sign-In, JWT tokens, session management, password reset

**Installation:**
- **With AI Assistant:** Use [`INSTALL_PROMPT.md`](bundles/rails/authentication/google_plus_email/INSTALL_PROMPT.md)
- **Manual:** See [`README.md`](bundles/rails/authentication/google_plus_email/README.md)

**Time:** ~15-30 minutes | **Difficulty:** ⭐⭐ Intermediate

---

### Coming Soon
- OAuth Multi-Provider (Apple, Facebook, GitHub)
- Two-Factor Authentication
- Role-Based Access Control
- User Profile Management
- File Upload (S3, Azure, GCS)
- API Rate Limiting

## 🆕 AI-Assisted Workflow (New!)

**Use your AI coding assistant to scaffold projects and install bundles!**

### For AI Assistants (Claude Code, Cursor, Copilot, etc.)

**📋 [View all AI prompts](PROMPTS_INDEX.md)** - Complete guide to using AI assistants

**🚀 Scaffold a project** - Choose your template:
- [Rails API](SCAFFOLD_RAILS_API.md) - Backend APIs, microservices
- [React App](SCAFFOLD_REACT_APP.md) - Frontend SPAs, dashboards
- [Go Microservice](SCAFFOLD_GO_MICROSERVICE.md) - High-performance services

**📦 Install bundles** - Add features like authentication with one prompt

**Example:** Want a Rails API with Google OAuth authentication?
1. Copy [`SCAFFOLD_RAILS_API.md`](SCAFFOLD_RAILS_API.md) → Paste into your AI assistant
2. Copy [`bundles/rails/authentication/google_plus_email/INSTALL_PROMPT.md`](bundles/rails/authentication/google_plus_email/INSTALL_PROMPT.md) → Paste into your AI assistant
3. Done! Your API has full authentication.

---


## Best Practices

### After Creating a Project

1. **Review and customize:**
   - README.md - Update with your project details
   - .env - Configure environment variables
   - Database configuration
   - API keys and secrets

2. **Security checklist:**
   - Change default secrets/keys
   - Review CORS settings
   - Update allowed origins
   - Configure authentication properly

3. **Version control:**
   - Projects are initialized with git
   - Review `.gitignore` files
   - Never commit secrets or credentials
   - Create GitHub/GitLab repository

4. **Documentation:**
   - Update README with your API docs
   - Document environment variables
   - Add setup instructions for your team

## Contributing

Contributions welcome! Here's how:

### Adding a New Template

1. Create template directory in repository root
2. Include a `setup.sh` script (if needed)
3. Include `.env.example` for configuration
4. Add `AGENTS.md` for AI coding assistant context
5. Update this README
6. Update `create-project` script (TEMPLATES array)
7. Test thoroughly
8. Submit a pull request

### Improving Existing Templates

1. Fork the repository
2. Make your changes
3. Test the template generation
4. Submit a pull request with description

### Reporting Issues

Found a bug? Have a suggestion?
- Open an issue on GitHub
- Include template name and steps to reproduce
- Screenshots help!

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

Built with:
- Inspiration from create-react-app, Rails generators, and cookiecutter
- Best practices from the Rails, React, and Go communities
- Feedback from developers using these templates

## Support

- **Documentation:** Check individual template README files
- **Issues:** GitHub Issues
- **Questions:** GitHub Discussions
- **Updates:** Star this repo to stay notified

## Roadmap

### Templates
- [ ] Additional templates (Vue, Svelte, Python/FastAPI)
- [ ] Template variants (with/without auth, different databases)
- [ ] CI/CD template integrations (GitHub Actions, GitLab CI)
- [ ] Cloud deployment configs (AWS, GCP, Heroku)
- [ ] Testing framework options
- [ ] Monorepo template support

### Bundles (Feature Modules)
- [x] **Authentication Bundle** - Email + Google OAuth ✅
- [ ] OAuth Multi-Provider (Apple, Facebook, GitHub)
- [ ] Two-Factor Authentication (TOTP)
- [ ] Role-Based Access Control (RBAC)
- [ ] User Profile Management
- [ ] File Upload (S3, Azure, GCS)
- [ ] Email Notifications (SendGrid, Mailgun)
- [ ] Webhook System
- [ ] API Rate Limiting
- [ ] Payment Processing (Stripe)
- [ ] Multi-Tenancy

### AI Integration
- [x] **AI-Assisted Installation** - Copy-paste prompts ✅
- [x] **AGENTS.md** - Universal AI assistant context ✅
- [ ] Interactive bundle discovery via AI
- [ ] Automated conflict resolution
- [ ] Smart bundle recommendations based on project

## Template Comparison

| Feature | Rails API | React App | Go Microservice |
|---------|-----------|-----------|-----------------|
| Language | Ruby | TypeScript/JavaScript | Go |
| Purpose | Backend API | Frontend SPA | High-performance API |
| Database | PostgreSQL ✅ | - | Optional |
| Authentication | JWT ✅ | - | Optional |
| Background Jobs | Sidekiq ✅ | - | - |
| Caching | Redis ✅ | - | - |
| Docker | ✅ | ✅ | ✅ |
| TypeScript | - | ✅ | - |
| Test Suite | RSpec | Vitest | Go testing |
| Build Time | ~2 min | ~30 sec | ~10 sec |
| Runtime | Ruby VM | Browser | Native binary |

---

**Made with ❤️ for developers who know that time is money.**

**Star ⭐ this repo if you find it useful!**
