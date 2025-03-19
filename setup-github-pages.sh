#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp GitHub Pages Setup ===${NC}"
echo -e "${YELLOW}This script will help you set up GitHub Pages for the VideoProcessingApp.${NC}"
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

# Create docs directory if it doesn't exist
if [ ! -d "docs" ]; then
    echo -e "${BLUE}Creating docs directory...${NC}"
    mkdir -p docs
    echo -e "${GREEN}docs directory created.${NC}"
else
    echo -e "${YELLOW}docs directory already exists.${NC}"
fi

# Copy web files to docs directory
echo -e "${BLUE}Copying web files to docs directory...${NC}"
cp -r web/* docs/
echo -e "${GREEN}Web files copied to docs directory.${NC}"

# Create index.html in the root directory
echo -e "${BLUE}Creating index.html in the root directory...${NC}"
cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VideoProcessingApp</title>
    <meta http-equiv="refresh" content="0;url=docs/index.html">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
            text-align: center;
            padding: 50px;
        }
        a {
            color: #0066cc;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>VideoProcessingApp</h1>
    <p>Redirecting to the <a href="docs/index.html">VideoProcessingApp web interface</a>...</p>
</body>
</html>
EOF
echo -e "${GREEN}index.html created in the root directory.${NC}"

# Add files to git
echo -e "${BLUE}Adding files to git...${NC}"
git add docs index.html
echo -e "${GREEN}Files added to git.${NC}"

# Commit changes
echo -e "${BLUE}Committing changes...${NC}"
git commit -m "Add GitHub Pages files"
echo -e "${GREEN}Changes committed.${NC}"

# Push to GitHub
echo -e "${BLUE}Pushing code to GitHub...${NC}"
git push
echo -e "${GREEN}Code pushed to GitHub.${NC}"

echo
echo -e "${GREEN}=== GitHub Pages Setup Complete ===${NC}"
echo -e "${GREEN}Your GitHub Pages site should now be available at:${NC}"
echo -e "${GREEN}https://$GITHUB_USERNAME.github.io/$REPO_NAME/${NC}"
echo
echo -e "${YELLOW}Note: It may take a few minutes for GitHub Pages to build and deploy your site.${NC}"
echo -e "${YELLOW}You can check the status in your repository's Settings > Pages.${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo -e "${YELLOW}1. Set up Digital Ocean Spaces for storage (see GITHUB-DEPLOYMENT-GUIDE.md for details)${NC}"
echo -e "${YELLOW}2. Set up Digital Ocean App Platform for the API (see GITHUB-DEPLOYMENT-GUIDE.md for details)${NC}"
echo -e "${YELLOW}3. Update the API URL in docs/script.js with your actual API URL from Digital Ocean${NC}"
