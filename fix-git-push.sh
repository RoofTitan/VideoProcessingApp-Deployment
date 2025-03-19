#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp Git Push Fix ===${NC}"
echo -e "${YELLOW}This script will help you fix the Git push issue.${NC}"
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

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
    echo -e "${GREEN}Git repository initialized.${NC}"
else
    echo -e "${YELLOW}Git repository already initialized.${NC}"
fi

# Create a README.md file if it doesn't exist
if [ ! -f "README.md" ]; then
    echo -e "${BLUE}Creating README.md file...${NC}"
    cat > README.md << EOF
# VideoProcessingApp Deployment

This repository contains the deployment files for the VideoProcessingApp.

## Features

- Web interface for uploading videos
- API for processing videos
- Webhook notifications
- Job management

## Deployment

See the [GITHUB-DEPLOYMENT-GUIDE.md](GITHUB-DEPLOYMENT-GUIDE.md) file for deployment instructions.
EOF
    echo -e "${GREEN}README.md created.${NC}"
else
    echo -e "${YELLOW}README.md already exists.${NC}"
fi

# Add all files to git
echo -e "${BLUE}Adding files to git...${NC}"
git add .
echo -e "${GREEN}Files added to git.${NC}"

# Commit changes
echo -e "${BLUE}Committing changes...${NC}"
git commit -m "Initial commit"
echo -e "${GREEN}Changes committed.${NC}"

# Check which branch we're on
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    # No branch yet, create main branch
    echo -e "${BLUE}Creating main branch...${NC}"
    git checkout -b main
    echo -e "${GREEN}Main branch created.${NC}"
elif [ "$CURRENT_BRANCH" != "main" ]; then
    # Not on main branch, switch to main
    echo -e "${BLUE}Switching to main branch...${NC}"
    git branch -m "$CURRENT_BRANCH" main
    echo -e "${GREEN}Switched to main branch.${NC}"
else
    echo -e "${YELLOW}Already on main branch.${NC}"
fi

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
git push -u origin main
echo -e "${GREEN}Code pushed to GitHub.${NC}"

echo
echo -e "${GREEN}=== Git Push Fix Complete ===${NC}"
echo -e "${GREEN}Your VideoProcessingApp files have been pushed to GitHub.${NC}"
echo -e "${GREEN}Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${YELLOW}1. Run the setup-github-pages.sh script to set up GitHub Pages.${NC}"
echo -e "${YELLOW}2. Follow the instructions in the GITHUB-DEPLOYMENT-GUIDE.md file.${NC}"
