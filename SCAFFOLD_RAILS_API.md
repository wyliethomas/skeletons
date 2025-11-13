# Rails API Project - Scaffolding Prompt

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to scaffold a new Rails API project.

---

## 📋 Copy This Prompt:

```
I need to scaffold a new Rails API project using a pre-built template.

Please follow these steps:

1. Download the Rails API template from GitHub (no authentication required):

   Download URL: https://github.com/wyliethomas/skeletons/archive/refs/heads/master.tar.gz

   Use curl to download and extract ONLY the rails-api folder:
   - Download the archive to the current directory
   - Extract it to the current directory
   - The rails-api template will be at: skeletons-master/rails-api/

2. Ask me what I want to name my project.

3. Copy ONLY the rails-api folder from the extracted archive to my current directory
   with the new project name I provided.

4. Clean up the temporary files (remove the downloaded archive and extracted folder from the current directory).

5. Update the .env file in my new project:
   - Change COMPOSE_NAME to match my project name
   - Generate a new LOCKBOX_MASTER_KEY using: openssl rand -hex 32

6. Make the setup script executable and show me what to do next:
   - Run: chmod +x setup.sh

7. Give me a summary with:
   - Project location and name
   - How to run the setup: ./setup.sh
   - How to start the project: docker compose up
   - What the template includes
   - Next steps for development

Important: Only copy the rails-api folder, not the entire repository.
```

---

## What This Does

This prompt will:
1. Download only the Rails API template (not all templates)
2. Set up a new project with your chosen name
3. Configure environment variables
4. Prepare you to run setup and start developing

## Template Includes

- Rails 7+ API-only application
- PostgreSQL database
- Redis for caching/jobs
- Sidekiq for background jobs
- Docker + Docker Compose setup
- RSpec for testing
- Figaro for environment variables
- JWT authentication structure
- CORS configuration
- Health check endpoints

## Requirements

Before running this prompt:
- Docker and Docker Compose installed
- Your AI coding assistant ready

## After Scaffolding

Run these commands:
```bash
cd your-project-name
./setup.sh                    # Initialize Docker, database, migrations
docker compose up             # Start all services
```

Your API will be available at: http://localhost:3000

## Next Steps

After scaffolding:
1. Review and customize README.md
2. Update .env with your configuration
3. Install feature bundles (like authentication)
4. Start building your API endpoints

## Add Authentication

Want to add authentication? Use the authentication bundle:
See: `bundles/rails/authentication/google_plus_email/INSTALL_PROMPT.md`

---

**Documentation:** See `AGENTS.md` in your new project for AI assistant context
