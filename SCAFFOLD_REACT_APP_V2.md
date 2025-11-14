# React App Project - Scaffolding Prompt (v2 - Optimized)

Copy and paste this prompt into your AI coding assistant (Claude Code, Cursor, Copilot, etc.) to scaffold a new React application.

---

## 📋 Copy This Prompt:

```
I need to scaffold a new React application using a pre-built template.

Please follow these steps:

1. Download the React app template from GitHub (no authentication required):

   Download URL: https://github.com/wyliethomas/skeletons/archive/refs/heads/template/react-app.tar.gz

   Use curl to download and extract:
   - Download the archive to the current directory
   - Extract it to the current directory
   - The template files will be at: skeletons-template-react-app/

2. Ask me what I want to name my project.

3. Move the skeletons-template-react-app folder to my project name.
   Example: mv skeletons-template-react-app my-project-name

4. Clean up the temporary archive file.

5. Update package.json in my new project:
   - Change the "name" field to match my project name

6. Make the setup script executable:
   - Run: chmod +x setup.sh

7. Give me a summary with:
   - Project location and name
   - How to run the setup: ./setup.sh
   - How to start the dev server: docker compose up
   - What the template includes
   - Next steps for development

Important: This downloads ONLY the React app template, not the entire repository.
```

---

## What This Does

This prompt will:
1. Download ONLY the React app template (~3MB vs ~15MB for all templates)
2. Set up a new project with your chosen name
3. Configure package.json
4. Prepare you to run setup and start developing

## Template Includes

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

## Requirements

Before running this prompt:
- Docker and Docker Compose installed
- Your AI coding assistant ready

## After Scaffolding

Run these commands:
```bash
cd your-project-name
./setup.sh                    # Initialize Docker and dependencies
docker compose up             # Start dev server
```

Your app will be available at: http://localhost:5173

## Next Steps

After scaffolding:
1. Review and customize README.md
2. Edit src/App.tsx to start building
3. Configure API endpoints if connecting to a backend
4. Customize Tailwind configuration

---

**Documentation:** See `AGENTS.md` in your new project for AI assistant context

## Improvements in v2

✅ **80% smaller download** - Only React template, not all 3
✅ **Simpler extraction** - Template files at root level
✅ **Cleaner process** - Just rename folder, no subdirectory copying
✅ **Faster** - Less data to download and extract
