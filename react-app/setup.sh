#!/bin/bash

echo "-----------------------------------------------------"
echo " Removing Orphan Containers"
echo "-----------------------------------------------------"
docker compose down --remove-orphans


echo "-----------------------------------------------------"
echo " Building Docker Image"
echo "-----------------------------------------------------"
docker compose build


echo -e "\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " Setup completed"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "\nYou can now start the application with:"
echo -e "\tdocker compose up\n"
echo -e "Or run in the background with:"
echo -e "\tdocker compose up -d\n"
echo -e "Access the app at:"
echo -e "\thttp://localhost:5173\n"
