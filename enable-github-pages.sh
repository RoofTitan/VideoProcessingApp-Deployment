#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp GitHub Pages Setup ===${NC}"
echo -e "${YELLOW}This script will enable GitHub Pages for the VideoProcessingApp.${NC}"
echo

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed.${NC}"
    echo -e "${YELLOW}Please install GitHub CLI by following the instructions at:${NC}"
    echo -e "${YELLOW}https://cli.github.com/manual/installation${NC}"
    exit 1
fi

# Check if logged in to GitHub CLI
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You need to log in to GitHub CLI.${NC}"
    gh auth login
fi

# Get GitHub username
GITHUB_USERNAME=$(gh api user | grep login | cut -d'"' -f4)
echo -e "${GREEN}Using GitHub username: ${GITHUB_USERNAME}${NC}"

# Get repository name
read -p "Enter repository name (default: VideoProcessingApp-Deployment): " REPO_NAME
REPO_NAME=${REPO_NAME:-VideoProcessingApp-Deployment}

# Enable GitHub Pages
echo -e "${BLUE}Enabling GitHub Pages...${NC}"
gh api repos/$GITHUB_USERNAME/$REPO_NAME/pages -X POST -F source='{"branch":"main","path":"/docs"}'

if [ $? -eq 0 ]; then
    echo -e "${GREEN}GitHub Pages enabled successfully!${NC}"
    echo -e "${GREEN}Your website will be available at: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/${NC}"
    echo -e "${YELLOW}Note: It may take a few minutes for GitHub Pages to build and deploy your site.${NC}"
else
    echo -e "${RED}Failed to enable GitHub Pages. Please try manually:${NC}"
    echo -e "${YELLOW}1. Go to your repository on GitHub: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
    echo -e "${YELLOW}2. Click on 'Settings'${NC}"
    echo -e "${YELLOW}3. Scroll down to the 'GitHub Pages' section${NC}"
    echo -e "${YELLOW}4. Select 'main' as the branch and '/docs' as the folder${NC}"
    echo -e "${YELLOW}5. Click 'Save'${NC}"
fi

echo
echo -e "${GREEN}=== GitHub Pages Setup Complete ===${NC}"
