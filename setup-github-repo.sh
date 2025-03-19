#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp GitHub Repository Setup ===${NC}"
echo -e "${YELLOW}This script will help you set up a GitHub repository for VideoProcessingApp.${NC}"
echo

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed. Please install git and try again.${NC}"
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}GitHub CLI (gh) is not installed. We recommend installing it for easier repository setup.${NC}"
    echo -e "${YELLOW}You can install it from: https://cli.github.com/${NC}"
    echo
    USE_GH=false
else
    USE_GH=true
    # Check if logged in to GitHub CLI
    if ! gh auth status &> /dev/null; then
        echo -e "${YELLOW}You need to log in to GitHub CLI.${NC}"
        gh auth login
    fi
fi

# Get GitHub username
if [ "$USE_GH" = true ]; then
    GITHUB_USERNAME=$(gh api user | grep login | cut -d'"' -f4)
    echo -e "${GREEN}Using GitHub username: ${GITHUB_USERNAME}${NC}"
else
    read -p "Enter your GitHub username: " GITHUB_USERNAME
fi

# Get repository name
read -p "Enter repository name (default: VideoProcessingApp): " REPO_NAME
REPO_NAME=${REPO_NAME:-VideoProcessingApp}

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

# Create GitHub repository
echo -e "${BLUE}Creating GitHub repository...${NC}"
if [ "$USE_GH" = true ]; then
    gh repo create $REPO_NAME --public --source=. --remote=origin --push
    echo -e "${GREEN}GitHub repository created and code pushed.${NC}"
else
    echo -e "${YELLOW}Please create a new repository on GitHub named '${REPO_NAME}'.${NC}"
    echo -e "${YELLOW}Visit: https://github.com/new${NC}"
    echo
    read -p "Press Enter when you've created the repository..."
    
    # Add remote
    echo -e "${BLUE}Adding remote...${NC}"
    git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
    
    # Push to GitHub
    echo -e "${BLUE}Pushing code to GitHub...${NC}"
    git push -u origin main || git push -u origin master
    echo -e "${GREEN}Code pushed to GitHub.${NC}"
fi

# Set up GitHub Pages
echo -e "${BLUE}Setting up GitHub Pages...${NC}"
if [ "$USE_GH" = true ]; then
    gh api repos/$GITHUB_USERNAME/$REPO_NAME/pages -X POST -F source='{"branch":"main","path":"/docs"}'
    echo -e "${GREEN}GitHub Pages set up.${NC}"
else
    echo -e "${YELLOW}Please set up GitHub Pages manually:${NC}"
    echo -e "${YELLOW}1. Go to https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/pages${NC}"
    echo -e "${YELLOW}2. Select 'main' branch and '/docs' folder${NC}"
    echo -e "${YELLOW}3. Click 'Save'${NC}"
    echo
    read -p "Press Enter when you've set up GitHub Pages..."
fi

# Set up GitHub Secrets
echo -e "${BLUE}Setting up GitHub Secrets...${NC}"
echo -e "${YELLOW}You need to set up the following secrets for the GitHub Actions workflows:${NC}"
echo -e "${YELLOW}1. DIGITALOCEAN_ACCESS_TOKEN: Your Digital Ocean API token${NC}"
echo -e "${YELLOW}2. DIGITALOCEAN_APP_ID: Your Digital Ocean App ID${NC}"
echo -e "${YELLOW}3. SPACES_ACCESS_KEY: Your Digital Ocean Spaces access key${NC}"
echo -e "${YELLOW}4. SPACES_SECRET_KEY: Your Digital Ocean Spaces secret key${NC}"
echo

if [ "$USE_GH" = true ]; then
    echo -e "${BLUE}Do you want to set up these secrets now? (y/n)${NC}"
    read -p "Enter your choice: " SETUP_SECRETS
    
    if [ "$SETUP_SECRETS" = "y" ] || [ "$SETUP_SECRETS" = "Y" ]; then
        read -p "Enter your Digital Ocean API token: " DO_TOKEN
        read -p "Enter your Digital Ocean App ID: " DO_APP_ID
        read -p "Enter your Digital Ocean Spaces access key: " SPACES_ACCESS_KEY
        read -p "Enter your Digital Ocean Spaces secret key: " SPACES_SECRET_KEY
        
        gh secret set DIGITALOCEAN_ACCESS_TOKEN -b"$DO_TOKEN" -R $GITHUB_USERNAME/$REPO_NAME
        gh secret set DIGITALOCEAN_APP_ID -b"$DO_APP_ID" -R $GITHUB_USERNAME/$REPO_NAME
        gh secret set SPACES_ACCESS_KEY -b"$SPACES_ACCESS_KEY" -R $GITHUB_USERNAME/$REPO_NAME
        gh secret set SPACES_SECRET_KEY -b"$SPACES_SECRET_KEY" -R $GITHUB_USERNAME/$REPO_NAME
        
        echo -e "${GREEN}GitHub Secrets set up.${NC}"
    else
        echo -e "${YELLOW}Please set up the secrets manually:${NC}"
        echo -e "${YELLOW}1. Go to https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/secrets/actions${NC}"
        echo -e "${YELLOW}2. Click 'New repository secret' and add each secret${NC}"
    fi
else
    echo -e "${YELLOW}Please set up the secrets manually:${NC}"
    echo -e "${YELLOW}1. Go to https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/secrets/actions${NC}"
    echo -e "${YELLOW}2. Click 'New repository secret' and add each secret${NC}"
fi

echo
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo -e "${GREEN}Your VideoProcessingApp is now deployed to GitHub.${NC}"
echo -e "${GREEN}Web Interface: https://$GITHUB_USERNAME.github.io/$REPO_NAME/${NC}"
echo -e "${GREEN}API: Check your Digital Ocean App Platform dashboard for the URL.${NC}"
echo
echo -e "${YELLOW}Don't forget to update the API_BASE_URL in web/script.js with your actual API URL.${NC}"
echo -e "${YELLOW}You can do this by editing the file and pushing the changes to GitHub.${NC}"
