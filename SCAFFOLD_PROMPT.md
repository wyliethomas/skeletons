# Rails API Project Scaffolding Prompt

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to scaffold a new Rails API project.

---

## 📋 Copy This Prompt:

```
I need to scaffold a new Rails API project using a pre-built template.

Please follow these steps:

1. Clone the rails-api template from this repository:
   https://github.com/battlestag/skeletons

2. Copy the rails-api folder to my current directory with a new project name.
   Ask me what I want to name the project.

3. Update the .env file:
   - Change COMPOSE_NAME to match my project name
   - Generate a new LOCKBOX_MASTER_KEY (use: rails secret or equivalent)

4. Run the setup script:
   - Make sure setup.sh is executable
   - Run ./setup.sh to initialize the project

5. Verify the installation:
   - Check that Docker containers start properly
   - Confirm the Rails app is accessible
   - Show me the status of all services

6. Give me a summary of:
   - What was installed
   - How to start/stop the project
   - Where to find the API documentation
   - Next steps for development

The template includes:
- Rails 7+ API-only application
- PostgreSQL database
- Redis for caching/jobs
- Sidekiq for background jobs
- Docker + Docker Compose setup
- RSpec for testing
- Figaro for environment variables
```

---

## What This Does

This prompt will:
1. Download the Rails API skeleton template
2. Set up a new project with your chosen name
3. Configure environment variables
4. Initialize Docker containers
5. Get you ready to start developing

## Next Steps

After your AI assistant completes this prompt, you'll have a fully working Rails API project. Then you can install bundles (like authentication) using the bundle installation prompts.

## Requirements

Before running this prompt, ensure you have:
- Docker and Docker Compose installed
- Git installed
- Your AI coding assistant ready (Claude Code, Cursor, Copilot, etc.)

## Example Usage

**Developer:** "rails_blog_api"

**AI Response:** Will create a new Rails API project named `rails_blog_api` with all services configured and running.
