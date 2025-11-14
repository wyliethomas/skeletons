# Go Microservice Project - Scaffolding Prompt (v2 - Optimized)

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to scaffold a new Go microservice.

---

## 📋 Copy This Prompt:

```
I need to scaffold a new Go microservice using a pre-built template.

Please follow these steps:

1. Download the Go microservice template from GitHub (no authentication required):

   Download URL: https://github.com/wyliethomas/skeletons/archive/refs/heads/template/go-microservice.tar.gz

   Use curl to download and extract:
   - Download the archive to the current directory
   - Extract it to the current directory
   - The template files will be at: skeletons-template-go-microservice/

2. Ask me what I want to name my project.

3. Move the skeletons-template-go-microservice folder to my project name.
   Example: mv skeletons-template-go-microservice my-project-name

4. Clean up the temporary archive file.

5. Update go.mod in my new project:
   - Change the module name to match my project name

6. Show me available Make commands:
   - make run    # Build and run
   - make test   # Run tests
   - make docker # Build Docker image

7. Give me a summary with:
   - Project location and name
   - Available Make commands
   - What the template includes
   - Next steps for development

Important: This downloads ONLY the Go microservice template, not the entire repository.
```

---

## What This Does

This prompt will:
1. Download ONLY the Go microservice template (~2MB vs ~15MB for all templates)
2. Set up a new project with your chosen name
3. Configure go.mod
4. Show you available commands to run

## Template Includes

- Chi HTTP router
- Structured logging
- Environment configuration
- Graceful shutdown handling
- Docker multi-stage builds
- Makefile for common tasks
- Unit test setup
- CORS middleware
- Health check endpoints

## Requirements

Before running this prompt:
- Go 1.19+ installed (or Docker)
- Make installed
- Your AI coding assistant ready

## After Scaffolding

Run these commands:
```bash
cd your-project-name
make run                      # Build and run locally
# OR
make docker                   # Build Docker image
docker run -p 8080:8080 your-project-name
```

Your service will be available at: http://localhost:8080

## Available Make Commands

```bash
make run      # Build and run locally
make build    # Build binary
make test     # Run tests
make clean    # Clean build artifacts
make docker   # Build Docker image
```

## Next Steps

After scaffolding:
1. Review and customize README.md
2. Update .env with your configuration
3. Add your business logic to handlers
4. Define your API routes

---

**Documentation:** See `AGENTS.md` in your new project for AI assistant context

## Improvements in v2

✅ **85% smaller download** - Only Go template, not all 3
✅ **Simpler extraction** - Template files at root level
✅ **Cleaner process** - Just rename folder, no subdirectory copying
✅ **Faster** - Less data to download and extract
