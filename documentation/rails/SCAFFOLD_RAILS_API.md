# Rails API Project - Initial Prompt 

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to scaffold a new Rails API project.

---

## Copy This Prompt:

```
I need to scaffold a new Rails API project using a pre-built template.

Please follow these steps:

1. Download the Rails API template from GitHub (no authentication required):

   Download URL: https://github.com/wyliethomas/skeletons/archive/refs/heads/template/rails-api.tar.gz

   Use curl to download and extract:
   - Download the archive to the current directory
   - Extract it to the current directory
   - The template files will be at: skeletons-template-rails-api/

2. Ask me what I want to name my project.

3. Move the skeletons-template-rails-api folder to my project name.
   Example: mv skeletons-template-rails-api my-project-name

4. Clean up the temporary archive file.

5. Update the .env file in my new project:
   - Change COMPOSE_NAME to match my project name
   - Generate a new LOCKBOX_MASTER_KEY using: openssl rand -hex 32

6. Make the setup script executable:
   - Run: chmod +x setup.sh

7. Give me a summary with:
   - Project location and name
   - How to run the setup: ./setup.sh
   - How to start the project: docker compose up
   - What the template includes
   - Next steps for development

Important: This downloads ONLY the Rails API template, not the entire repository.
```

---

## What This Does

This prompt will:
1. Download ONLY the Rails API template (~5MB vs ~15MB for all templates)
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
- CORS configuration
- Health check endpoints

**No authentication included** - Add it with a bundle!

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

## Add Bundles

The following bundles can be added to your new project

- [Authentication: Google + Email ](../../bundles/rails/authentication/google_plus_email)


---

**Documentation:** See `AGENTS.md` in your new project for AI assistant context

## Improvements in v2

✅ **50% smaller download** - Only Rails template, not all 3
✅ **Simpler extraction** - Template files at root level
✅ **Cleaner process** - Just rename folder, no subdirectory copying
✅ **Faster** - Less data to download and extract
