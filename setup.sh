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
  echo "⚠️  IMPORTANT: Review and update .env with your configuration!"
  echo "   Pay special attention to:"
  echo "   - COMPOSE_NAME (your project name)"
  echo "   - SECRET_KEY_BASE (generate with: rails secret)"
  echo "   - JWT_SECRET_KEY (generate with: openssl rand -hex 64)"
  echo ""
  read -p "Press Enter to continue after updating .env, or Ctrl+C to exit..."
  echo ""
fi

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
