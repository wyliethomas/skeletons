# Contributing to Project Skeletons

Thank you for your interest in contributing! This guide will help you get started.

## 🎯 Ways to Contribute

- **Add new templates** - Share your battle-tested project setups
- **Improve existing templates** - Update dependencies, add features
- **Fix bugs** - Help us squash issues
- **Improve documentation** - Make it easier for others
- **Share feedback** - Tell us what works and what doesn't

## 📋 Before You Start

1. Check existing [issues](https://github.com/YOUR_USERNAME/skeletons/issues) and [pull requests](https://github.com/YOUR_USERNAME/skeletons/pulls)
2. For major changes, open an issue first to discuss
3. Make sure all templates follow our standards (see below)

## 🚀 Adding a New Template

### Template Requirements

Each template must include:

1. **README.md** - Comprehensive documentation including:
   - What the template is for
   - Technologies included
   - Setup instructions
   - Common tasks/commands
   - Configuration guide

2. **CLAUDE_CONTEXT.md** - AI assistance context file with:
   - Project structure overview
   - Key patterns and conventions
   - Important files and their purposes
   - Common operations and commands

3. **.env.example** - Example environment variables (if applicable)
   - Document each variable
   - Provide sensible defaults where possible
   - Never include actual secrets

4. **setup.sh** - Automated setup script (if needed)
   - Must be idempotent (safe to run multiple times)
   - Should handle missing dependencies gracefully
   - Print clear progress messages

5. **.gitignore** - Properly configured to exclude:
   - Dependencies (node_modules, vendor, etc.)
   - Environment files (.env)
   - IDE-specific files
   - OS-specific files
   - Build artifacts

6. **Docker support** (preferred)
   - Dockerfile
   - docker-compose.yml (if multi-container)
   - Development and production configs

### Template Standards

#### Security
- ✅ Never commit secrets or credentials
- ✅ Use environment variables for configuration
- ✅ Include `.env.example` with placeholders
- ✅ Set secure defaults
- ✅ Document security considerations

#### Code Quality
- ✅ Follow language/framework best practices
- ✅ Include linting configuration
- ✅ Include basic test setup
- ✅ Use consistent formatting
- ✅ Comment complex logic

#### Documentation
- ✅ Clear, concise README
- ✅ Setup instructions that work
- ✅ Common tasks documented
- ✅ Troubleshooting section
- ✅ Links to official docs

#### Developer Experience
- ✅ Fast setup (< 5 minutes)
- ✅ Works on macOS and Linux
- ✅ Clear error messages
- ✅ Sensible defaults
- ✅ Easy to customize

### Step-by-Step Guide

1. **Create template directory**
```bash
mkdir my-template
cd my-template
```

2. **Build your template**
   - Create project structure
   - Add necessary files
   - Configure tooling
   - Test thoroughly

3. **Add required documentation**
```bash
touch README.md
touch CLAUDE_CONTEXT.md
touch .env.example
```

4. **Test the template**
```bash
# Copy template to test location
cp -r my-template /tmp/test-project
cd /tmp/test-project

# Run setup
./setup.sh  # or your setup method

# Verify it works
# - Build succeeds
# - Tests pass
# - Linting passes
```

5. **Update create-project script**

Edit `create-project` and add your template to the `TEMPLATES` array:

```bash
TEMPLATES=(
    ["my-template"]="Description of my template"
    # ... existing templates
)

TEMPLATE_ORDER=("my-template" "${TEMPLATE_ORDER[@]}")
```

6. **Add CI test**

Create or update `.github/workflows/test-templates.yml`:

```yaml
test-my-template:
  name: Test My Template
  runs-on: ubuntu-latest
  steps:
    # ... copy pattern from existing template tests
```

7. **Update README.md**

Add your template to the "Available Templates" section.

8. **Submit pull request**
   - Descriptive title
   - Explanation of what the template provides
   - Why it's useful
   - Screenshots (if applicable)

## 🔧 Improving Existing Templates

### Updating Dependencies

Use pull requests to update dependencies:

1. Update Gemfile/package.json/go.mod
2. Test thoroughly
3. Document any breaking changes
4. Update README if needed

### Adding Features

1. Ensure feature is generally useful
2. Make it optional if possible
3. Document configuration
4. Update CLAUDE_CONTEXT.md
5. Add tests

### Bug Fixes

1. Describe the issue clearly
2. Include steps to reproduce
3. Explain your fix
4. Test on fresh template copy

## 🧪 Testing Guidelines

Before submitting a PR:

### Manual Testing

```bash
# Test template generation
./create-project
# Select your template
# Enter test name
# Verify success

# Test setup
cd test-project
./setup.sh

# Test basic functionality
# (varies by template)
```

### CI Testing

GitHub Actions will automatically:
- Build Docker images
- Install dependencies
- Run tests
- Check for security issues

Ensure all checks pass before requesting review.

## 📝 Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, missing semicolons, etc
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples
```
feat(rails-api): add GitHub Actions CI template

Added preconfigured GitHub Actions workflow for Rails apps
including RSpec, Rubocop, and security scanning.
```

```
fix(react-app): correct Vite config for production builds

Fixed issue where environment variables weren't being
properly substituted in production builds.
```

```
docs(readme): add troubleshooting section

Added common issues and solutions to main README.
```

## 🔍 Code Review Process

1. **Automated checks** - CI must pass
2. **Maintainer review** - At least one approval needed
3. **Discussion** - Address feedback promptly
4. **Approval** - Once approved, will be merged
5. **Release** - Included in next release

## 📦 Release Process

We use semantic versioning:
- **Major** (1.0.0): Breaking changes
- **Minor** (0.1.0): New features, backwards compatible
- **Patch** (0.0.1): Bug fixes

Releases are automated via GitHub Actions when tags are pushed.

## ❓ Questions?

- **General questions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/skeletons/discussions)
- **Bug reports**: [GitHub Issues](https://github.com/YOUR_USERNAME/skeletons/issues)
- **Security issues**: Email [security@example.com](mailto:security@example.com)

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions
- Help others learn

## 🙏 Recognition

Contributors are recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page

Thank you for contributing! 🎉
