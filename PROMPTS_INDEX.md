# AI Assistant Prompts - Quick Reference

Ready-to-use prompts for scaffolding projects and installing bundles with any AI coding assistant.

## 🚀 Quick Start

### Step 1: Scaffold a New Project

📄 **Prompt File:** [`SCAFFOLD_PROMPT.md`](./SCAFFOLD_PROMPT.md)

**Use this to:** Create a new Rails API project from scratch

**What you'll get:**
- Rails 7+ API application
- PostgreSQL + Redis + Sidekiq
- Docker containerized setup
- Testing framework (RSpec)
- Ready to develop

**Time:** ~5 minutes

---

### Step 2: Install Feature Bundles

Choose from available bundles below and use their installation prompts.

---

## 📦 Available Bundles

### Authentication

#### Email + Google OAuth Authentication
📄 **Prompt File:** [`bundles/rails/authentication/google_plus_email/INSTALL_PROMPT.md`](./bundles/rails/authentication/google_plus_email/INSTALL_PROMPT.md)

**Features:**
- Email/password authentication
- Google Sign-In integration
- JWT token management
- Session handling
- Password reset flow

**Difficulty:** ⭐⭐ Intermediate
**Time:** ~15-30 minutes
**Status:** ✅ Production-Ready

---

## 📋 How to Use These Prompts

### For Claude Code:
1. Open your terminal with Claude Code
2. Copy the entire prompt from the `.md` file
3. Paste into Claude Code
4. Answer any questions Claude asks
5. Review changes before confirming

### For Cursor:
1. Open Cursor in your project directory
2. Open the AI chat panel (Cmd/Ctrl + L)
3. Copy and paste the prompt
4. Follow along as Cursor makes changes

### For GitHub Copilot:
1. Open VS Code with Copilot enabled
2. Open Copilot Chat
3. Paste the prompt
4. Confirm each step as Copilot suggests changes

### For Other AI Assistants:
These prompts are designed to work with any AI coding assistant that can:
- Read files from GitHub URLs
- Execute file operations
- Run terminal commands
- Edit code files

---

## 🎯 Example Workflow

**Scenario:** Developer wants to build a new Rails API with authentication

```
1. Copy SCAFFOLD_PROMPT.md → Paste into AI assistant
   Result: New Rails API project created

2. Copy google_plus_email/INSTALL_PROMPT.md → Paste into AI assistant
   Result: Authentication installed and configured

3. Start developing your application!
```

---

## 🗂️ Repository Structure

```
project-skeletons/
├── SCAFFOLD_PROMPT.md                    # ← Start here
├── PROMPTS_INDEX.md                      # ← You are here
│
├── rails-api/                            # Rails API skeleton template
│   ├── AGENTS.md
│   └── [project files...]
│
├── react-app/                            # React skeleton template
│   └── [project files...]
│
├── go-microservice/                      # Go skeleton template
│   └── [project files...]
│
└── bundles/                              # Feature bundles
    └── rails/
        └── authentication/
            └── google_plus_email/
                ├── INSTALL_PROMPT.md     # ← Use after scaffolding
                ├── README.md
                ├── BUNDLE_INFO.md
                └── [bundle files...]
```

---

## 🔗 GitHub Repository

All templates and bundles are available at:
**https://github.com/battlestag/project-skeletons**

---

## 💡 Tips for AI Assistants

When using these prompts with AI assistants:

1. **Let the AI read the docs** - The bundles include README.md and BUNDLE_INFO.md that AI assistants can parse
2. **Review before confirming** - Always review changes before allowing the AI to apply them
3. **One step at a time** - If issues occur, break the prompt into smaller steps
4. **Check conflicts** - AI should warn about existing files/gems before overwriting

---

## 🆘 Troubleshooting

### "AI can't access GitHub URLs"
- Clone the repository locally first
- Update prompts to reference local file paths instead of GitHub URLs

### "Conflicts with existing code"
- AI should detect this and ask how to proceed
- You can merge manually or choose to skip conflicting files

### "Environment variables not set"
- AI should guide you through setting required variables
- Check bundle's README.md for required variables

### "Migration fails"
- Ensure database is running (Docker containers should be up)
- Check for existing tables with same name
- Review migration file for conflicts

---

## 🚧 Coming Soon

More bundles in development:

- **Authentication**
  - OAuth Multi-Provider (Apple, Facebook, GitHub)
  - Two-Factor Authentication (TOTP)
  - Magic Link Authentication

- **Authorization**
  - Role-Based Access Control
  - Permission Management
  - Multi-Tenancy

- **Features**
  - User Profile Management
  - File Upload (S3, Azure, GCS)
  - Email Notifications
  - Webhook System
  - API Rate Limiting

---

## 📚 Additional Resources

- **Project Templates:** See individual template AGENTS.md files
- **Bundle Documentation:** Each bundle includes detailed README.md
- **Installation Scripts:** Use `create-project` CLI for interactive setup

---

## 🤝 Contributing

Have a bundle to contribute?
1. Follow the bundle structure (see existing bundles)
2. Include README.md, BUNDLE_INFO.md, and INSTALL_PROMPT.md
3. Test with multiple AI assistants
4. Submit a pull request

---

## 📝 License

MIT License - Free for commercial and open-source use

---

**Last Updated:** 2025-01-13
**Maintained by:** PXP Development Team
