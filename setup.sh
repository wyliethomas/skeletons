#!/bin/bash

echo "=================================================="
echo " Rails Multitenant - Docker Setup"
echo "=================================================="
echo ""

# Check if .env file exists, if not copy from .env.example
if [ ! -f .env ]; then
  echo "Creating .env file from .env.example..."
  cp .env.example .env
  echo "✓ .env file created"
  echo ""
fi

# Check if secrets need to be generated (if they're still placeholder values)
if grep -q "your_secret_key_here\|your_jwt_secret_key_here" .env; then
  echo "Generating secure secrets..."

  # Generate SECRET_KEY_BASE if it's still a placeholder
  if grep -q "SECRET_KEY_BASE=your_secret_key_here" .env; then
    SECRET_KEY_BASE=$(openssl rand -hex 64)
    sed -i.bak "s|SECRET_KEY_BASE=.*|SECRET_KEY_BASE=${SECRET_KEY_BASE}|g" .env
    echo "✓ SECRET_KEY_BASE generated"
  fi

  # Generate JWT_SECRET_KEY if it's still a placeholder
  if grep -q "JWT_SECRET_KEY=your_jwt_secret_key_here" .env; then
    JWT_SECRET_KEY=$(openssl rand -hex 64)
    sed -i.bak "s|JWT_SECRET_KEY=.*|JWT_SECRET_KEY=${JWT_SECRET_KEY}|g" .env
    echo "✓ JWT_SECRET_KEY generated"
  fi

  # Clean up backup file
  rm -f .env.bak

  echo ""
  echo "✓ Security secrets generated successfully!"
  echo ""
fi

echo "⚠️  IMPORTANT: Review .env with your configuration if needed!"
echo "   Pay special attention to:"
echo "   - COMPOSE_NAME (your project name)"
echo "   - Database credentials (if not using defaults)"
echo ""

echo "Removing orphan containers..."
docker compose down --remove-orphans

echo ""
echo "Building Docker containers..."
docker compose build

echo ""
echo "Installing dependencies..."
docker compose run --rm web bundle install

echo ""
echo "Setting up database..."
docker compose run --rm web rake db:create
docker compose run --rm web rake db:migrate
docker compose run --rm web rake db:seed

echo ""
echo "=================================================="
echo " Setup Complete!"
echo "=================================================="
echo ""
echo "Default seed accounts created:"
echo "  • Super Admin: admin@example.com / Admin123!"
echo "  • Admin: demo@example.com / Demo123!"
echo "  • Member: member@example.com / Member123!"
echo ""
echo "⚠️  Change these passwords immediately for production!"
echo ""
echo "To start the application:"
echo "  docker compose up"
echo ""
echo "Or run in the background:"
echo "  docker compose up -d"
echo ""
echo "To view logs:"
echo "  docker compose logs -f"
echo ""
echo "To stop all services:"
echo "  docker compose down"
echo ""
