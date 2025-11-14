# Creating Individual Template Branches

This guide shows how to create separate branches for each template so GitHub generates individual tarballs.

## Why Do This?

**Before:** Download entire repo (all 3 templates) → Extract → Copy one template
**After:** Download ONLY the template you need → Extract → Done!

## Steps

### 1. Create Rails API Branch

```bash
cd /home/battlestag/dev/skeletons

# Create orphan branch (no history)
git checkout --orphan template/rails-api

# Remove everything
git rm -rf .

# Copy ONLY rails-api to root
cp -r rails-api/* .
cp -r rails-api/.* . 2>/dev/null || true

# Clean up the rails-api folder reference
rm -rf rails-api react-app go-microservice bundles

# Commit
git add .
git commit -m "Rails API template - isolated branch"

# Push
git push -u origin template/rails-api
```

### 2. Create React App Branch

```bash
# Go back to master
git checkout master

# Create orphan branch
git checkout --orphan template/react-app

# Remove everything
git rm -rf .

# Copy ONLY react-app to root
cp -r react-app/* .
cp -r react-app/.* . 2>/dev/null || true

# Clean up
rm -rf rails-api react-app go-microservice bundles

# Commit
git add .
git commit -m "React App template - isolated branch"

# Push
git push -u origin template/react-app
```

### 3. Create Go Microservice Branch

```bash
# Go back to master
git checkout master

# Create orphan branch
git checkout --orphan template/go-microservice

# Remove everything
git rm -rf .

# Copy ONLY go-microservice to root
cp -r go-microservice/* .
cp -r go-microservice/.* . 2>/dev/null || true

# Clean up
rm -rf rails-api react-app go-microservice bundles

# Commit
git add .
git commit -m "Go Microservice template - isolated branch"

# Push
git push -u origin template/go-microservice
```

### 4. Return to Master

```bash
git checkout master
```

## Result

You'll now have 3 new branches that GitHub will auto-generate tarballs for:

**Download URLs:**
```
https://github.com/wyliethomas/skeletons/archive/refs/heads/template/rails-api.tar.gz
https://github.com/wyliethomas/skeletons/archive/refs/heads/template/react-app.tar.gz
https://github.com/wyliethomas/skeletons/archive/refs/heads/template/go-microservice.tar.gz
```

**When extracted, they create:**
```
skeletons-template-rails-api/         (template files at root)
skeletons-template-react-app/         (template files at root)
skeletons-template-go-microservice/   (template files at root)
```

## Next Steps

After creating the branches, update the scaffold prompts:
- Change download URLs to use template branches
- Update extraction folder names
- Simplify copy commands (no subdirectory needed!)

## Verify

Test each URL in your browser:
```
https://github.com/wyliethomas/skeletons/archive/refs/heads/template/rails-api.tar.gz
```

Should immediately download a tarball!

## Benefits

✅ **Smaller downloads** - Only what you need
✅ **Faster** - Less data to transfer
✅ **Cleaner** - No extracting entire repo
✅ **Same speed** - Still just 1 HTTP request
✅ **Easier cleanup** - Simpler folder structure
