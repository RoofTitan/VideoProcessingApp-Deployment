#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp GitHub Push Script ===${NC}"
echo -e "${YELLOW}This script will help you push the VideoProcessingApp files to your GitHub repository.${NC}"
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed. Please install git and try again.${NC}"
    exit 1
fi

# Get GitHub username and repository name
read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter repository name (default: VideoProcessingApp-Deployment): " REPO_NAME
REPO_NAME=${REPO_NAME:-VideoProcessingApp-Deployment}

# Check if the repository exists on GitHub
echo -e "${BLUE}Checking if repository exists on GitHub...${NC}"
if curl -s -o /dev/null -w "%{http_code}" https://github.com/$GITHUB_USERNAME/$REPO_NAME | grep -q "200"; then
    echo -e "${GREEN}Repository exists on GitHub.${NC}"
    REPO_EXISTS=true
else
    echo -e "${YELLOW}Repository does not exist on GitHub. You need to create it first.${NC}"
    echo -e "${YELLOW}Visit: https://github.com/new${NC}"
    echo -e "${YELLOW}Create a repository named '$REPO_NAME' and make it public.${NC}"
    echo
    read -p "Press Enter when you've created the repository..."
    REPO_EXISTS=false
fi

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
    echo -e "${GREEN}Git repository initialized.${NC}"
else
    echo -e "${YELLOW}Git repository already initialized.${NC}"
fi

# Add all files to git
echo -e "${BLUE}Adding files to git...${NC}"
git add .

# Commit changes
echo -e "${BLUE}Committing changes...${NC}"
git commit -m "Initial commit"
echo -e "${GREEN}Changes committed.${NC}"

# Add remote if not already added
if ! git remote | grep -q "origin"; then
    echo -e "${BLUE}Adding remote...${NC}"
    git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
    echo -e "${GREEN}Remote added.${NC}"
else
    echo -e "${YELLOW}Remote already exists.${NC}"
fi

# Push to GitHub
echo -e "${BLUE}Pushing code to GitHub...${NC}"
git push -u origin main || git push -u origin master
echo -e "${GREEN}Code pushed to GitHub.${NC}"

echo
echo -e "${GREEN}=== Push Complete ===${NC}"
echo -e "${GREEN}Your VideoProcessingApp files have been pushed to GitHub.${NC}"
echo -e "${GREEN}Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${YELLOW}1. Run the setup-github-repo.sh script to set up GitHub Pages and GitHub Secrets.${NC}"
echo -e "${YELLOW}2. Follow the instructions in the GITHUB-DEPLOYMENT-GUIDE.md file.${NC}"
