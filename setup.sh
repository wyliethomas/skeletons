#!/bin/bash

# Check if .env file exists, if not copy from .env.example
if [ ! -f .env ]; then
  echo "-----------------------------------------------------"
  echo " Creating .env file from .env.example"
  echo "-----------------------------------------------------"
  cp .env.example .env
  echo "⚠️  Please update .env with your project name!"
  echo ""
fi

echo "-----------------------------------------------------"
echo " Removing Orphan Containers"
echo "-----------------------------------------------------"
docker compose down --remove-orphans


echo "-----------------------------------------------------"
echo " Building Containers"
echo "-----------------------------------------------------"
docker compose build


echo "-----------------------------------------------------"
echo " Installing Dependencies"
echo "-----------------------------------------------------"
docker compose run --rm web bundle install


echo "-----------------------------------------------------"
echo " Setting up database"
echo "-----------------------------------------------------"
docker compose run --rm web rake db:drop
docker compose run --rm web rake db:create
docker compose run --rm web rake db:migrate
docker compose run --rm web rake db:seed


echo -e "\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " Setup completed"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "\nYou can now start the application with:"
echo -e "\tdocker compose up\n"
echo -e "Or run in the background with:"
echo -e "\tdocker compose up -d\n"
