# Project Skeletons

Battle-tested project templates for modern application development. Get started in seconds with opinionated, production-ready templates.

## Features

- ** Interactive CLI** - Beautiful, user-friendly command-line interface
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

## Installation

### Quick Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/install.sh | bash
```

Or with wget:

```bash
wget -qO- https://raw.githubusercontent.com/wyliethomas/skeletons/master/install.sh | bash
```

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/wyliethomas/skeletons.git
cd skeletons
```

2. Run the installer:
```bash
./install.sh
```

3. Add to PATH (if not already):
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Alternative: Direct Download

Download just the CLI script:

```bash
curl -o create-project https://raw.githubusercontent.com/wyliethomas/skeletons/master/create-project
chmod +x create-project
./create-project
```

## Uninstallation

### Quick Uninstall

```bash
curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/uninstall.sh | bash
```

Or with wget:

```bash
wget -qO- https://raw.githubusercontent.com/wyliethomas/skeletons/master/uninstall.sh | bash
```

### Force Uninstall (Skip Confirmation)

```bash
curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/uninstall.sh | bash -s -- --force
```

### Manual Uninstall

```bash
rm -f ~/.local/bin/create-project
rm -rf ~/.local/share/project-skeletons
```

This will remove:
- The `create-project` CLI tool
- All project templates
- Nothing else on your system is affected

## Usage

### Interactive Mode (Recommended)

Simply run:

```bash
create-project
```

The CLI will guide you through:
1. Selecting a template
2. Naming your project
3. Reviewing your choices
4. Generating the project

### Example Session

```

.▄▄ · ▄ •▄ ▄▄▄ .▄▄▌  ▄▄▄ .▄▄▄▄▄       ▐ ▄ .▄▄ · 
▐█ ▀. █▌▄▌▪▀▄.▀·██•  ▀▄.▀·•██  ▪     •█▌▐█▐█ ▀. 
▄▀▀▀█▄▐▀▀▄·▐▀▀▪▄██▪  ▐▀▀▪▄ ▐█.▪ ▄█▀▄ ▐█▐▐▌▄▀▀▀█▄
▐█▄▪▐█▐█.█▌▐█▄▄▌▐█▌▐▌▐█▄▄▌ ▐█▌·▐█▌.▐▌██▐█▌▐█▄▪▐█
 ▀▀▀▀ ·▀  ▀ ▀▀▀ .▀▀▀  ▀▀▀  ▀▀▀  ▀█▄▀▪▀▀ █▪ ▀▀▀▀ 

  Fast, opinionated templates for quick starts


▶ Select a project template:

1) rails-api
2) react-app
3) go-microservice
Enter number (1-3): 1

✓ Selected: rails-api
ℹ Rails 7 API with JWT auth, Docker, Redis, Sidekiq

▶ Enter project name:

Project name: my-awesome-api

Summary:
  Template:     rails-api
  Project name: my-awesome-api

Proceed? (y/n): y

▶ Generating project: my-awesome-api

ℹ Copying template files...
✓ Template files copied
✓ .env file configured with project name
✓ Git repository initialized

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Project created successfully!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Next steps:

  cd my-awesome-api
  ./setup.sh          # Run setup script
  docker compose up   # Start the application
```

## Template-Specific Guides

### Rails API Setup

```bash
cd your-project
./setup.sh                    # Builds Docker, creates DB, runs migrations
docker compose up             # Start all services
docker compose run web rspec  # Run tests
```

**Endpoints:**
- API: http://localhost:3000
- Database: localhost:5432
- Redis: localhost:6379

**Configuration:**
1. Copy `config/application.yml.example` to `config/application.yml`
2. Update with your values (API keys, secrets, etc.)
3. Never commit `config/application.yml` (gitignored)

### React App Setup

```bash
cd your-project
./setup.sh                    # Initial setup
docker compose up             # Start dev server
docker compose exec web npm test  # Run tests
```

**Development:**
- Dev server: http://localhost:5173
- Hot reload enabled
- Edit `src/App.tsx` to get started

**Build for production:**
```bash
docker compose run web npm run build
```

### Go Microservice Setup

```bash
cd your-project
make run      # Build and run
make test     # Run tests
make docker   # Build Docker image
```

**Available Make commands:**
- `make run` - Build and run locally
- `make build` - Build binary
- `make test` - Run tests
- `make clean` - Clean build artifacts
- `make docker` - Build Docker image

## Updating Templates

The templates are versioned and updated regularly with:
- Security patches
- Framework updates
- New features and best practices

### Update installed templates:

```bash
cd ~/.local/share/project-skeletons
git pull
```

### Check for CLI updates:

```bash
curl -sSL https://raw.githubusercontent.com/wyliethomas/skeletons/master/install.sh | bash
```

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
