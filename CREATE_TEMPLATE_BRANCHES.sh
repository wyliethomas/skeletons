#!/bin/bash

# Script to create individual template branches for cleaner downloads
# Each branch will contain ONLY one template at the root level

set -e

echo "════════════════════════════════════════════════════════════"
echo "  Creating Template Branches"
echo "════════════════════════════════════════════════════════════"

# Save current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# Create rails-api template branch
echo ""
echo "Creating template/rails-api branch..."
git checkout --orphan template/rails-api
git rm -rf .
git clean -fdx
cp -r ../skeletons-backup/rails-api/* .
cp -r ../skeletons-backup/rails-api/.* . 2>/dev/null || true
git add .
git commit -m "Rails API template - isolated branch"
git push -u origin template/rails-api

# Create react-app template branch
echo ""
echo "Creating template/react-app branch..."
git checkout --orphan template/react-app
git rm -rf .
git clean -fdx
cp -r ../skeletons-backup/react-app/* .
cp -r ../skeletons-backup/react-app/.* . 2>/dev/null || true
git add .
git commit -m "React App template - isolated branch"
git push -u origin template/react-app

# Create go-microservice template branch
echo ""
echo "Creating template/go-microservice branch..."
git checkout --orphan template/go-microservice
git rm -rf .
git clean -fdx
cp -r ../skeletons-backup/go-microservice/* .
cp -r ../skeletons-backup/go-microservice/.* . 2>/dev/null || true
git add .
git commit -m "Go Microservice template - isolated branch"
git push -u origin template/go-microservice

# Return to original branch
echo ""
echo "Returning to $CURRENT_BRANCH..."
git checkout $CURRENT_BRANCH

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  ✅ Template Branches Created!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "New download URLs:"
echo "  Rails API:        https://github.com/wyliethomas/skeletons/archive/refs/heads/template/rails-api.tar.gz"
echo "  React App:        https://github.com/wyliethomas/skeletons/archive/refs/heads/template/react-app.tar.gz"
echo "  Go Microservice:  https://github.com/wyliethomas/skeletons/archive/refs/heads/template/go-microservice.tar.gz"
echo ""
echo "When extracted, these will create:"
echo "  skeletons-template-rails-api/"
echo "  skeletons-template-react-app/"
echo "  skeletons-template-go-microservice/"
echo ""
echo "Next: Update scaffold prompts with new URLs and folder names"
echo "════════════════════════════════════════════════════════════"
