#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp DigitalOcean Deployment ===${NC}"
echo -e "${YELLOW}This script will help you deploy the VideoProcessingApp to DigitalOcean App Platform.${NC}"
echo

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo -e "${RED}Error: doctl (DigitalOcean CLI) is not installed.${NC}"
    echo -e "${YELLOW}Please install doctl by following the instructions at:${NC}"
    echo -e "${YELLOW}https://docs.digitalocean.com/reference/doctl/how-to/install/${NC}"
    exit 1
fi

# Check if doctl is authenticated
if ! doctl account get &> /dev/null; then
    echo -e "${YELLOW}You need to authenticate with DigitalOcean.${NC}"
    echo -e "${YELLOW}Please run 'doctl auth init' and follow the instructions.${NC}"
    exit 1
fi

# Get DigitalOcean Spaces information
echo -e "${BLUE}Setting up DigitalOcean Spaces for storage...${NC}"
read -p "Enter your DigitalOcean Spaces Access Key: " DO_SPACES_KEY
read -p "Enter your DigitalOcean Spaces Secret Key: " DO_SPACES_SECRET
read -p "Enter your DigitalOcean Spaces Endpoint (e.g., nyc3.digitaloceanspaces.com): " DO_SPACES_ENDPOINT
read -p "Enter your DigitalOcean Spaces Bucket Name: " DO_SPACES_BUCKET

# Get app name
echo -e "${BLUE}Setting up DigitalOcean App Platform...${NC}"
read -p "Enter your DigitalOcean App name (default: videoprocessingapp-$(date +%Y%m%d)): " APP_NAME
APP_NAME=${APP_NAME:-videoprocessingapp-$(date +%Y%m%d)}

# Create app spec file
echo -e "${BLUE}Creating app spec file...${NC}"
cat > app.yaml << EOF
name: ${APP_NAME}
region: nyc
services:
- name: api
  github:
    repo: RoofTitan/VideoProcessingApp-Deployment
    branch: main
    deploy_on_push: true
  source_dir: api
  http_port: 8080
  instance_count: 1
  instance_size_slug: basic-xxs
  routes:
  - path: /
  envs:
  - key: DO_SPACES_KEY
    value: ${DO_SPACES_KEY}
    scope: RUN_TIME
    type: SECRET
  - key: DO_SPACES_SECRET
    value: ${DO_SPACES_SECRET}
    scope: RUN_TIME
    type: SECRET
  - key: DO_SPACES_ENDPOINT
    value: ${DO_SPACES_ENDPOINT}
    scope: RUN_TIME
  - key: DO_SPACES_BUCKET
    value: ${DO_SPACES_BUCKET}
    scope: RUN_TIME
EOF

echo -e "${GREEN}App spec file created.${NC}"

# Deploy to DigitalOcean App Platform
echo -e "${BLUE}Deploying to DigitalOcean App Platform...${NC}"
echo -e "${YELLOW}This may take a few minutes.${NC}"

doctl apps create --spec app.yaml

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Deployment successful!${NC}"
    
    # Get app URL
    echo -e "${BLUE}Getting app URL...${NC}"
    APP_ID=$(doctl apps list --format ID --no-header | head -n 1)
    APP_URL=$(doctl apps get $APP_ID --format DefaultIngress --no-header)
    
    echo -e "${GREEN}Your API is now deployed at: ${APP_URL}${NC}"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "${YELLOW}1. Update the API_BASE_URL in docs/script.js with your actual API URL: ${APP_URL}${NC}"
    echo -e "${YELLOW}2. Enable GitHub Pages in your repository settings${NC}"
    echo -e "${YELLOW}   - Go to your repository on GitHub${NC}"
    echo -e "${YELLOW}   - Click on 'Settings'${NC}"
    echo -e "${YELLOW}   - Scroll down to the 'GitHub Pages' section${NC}"
    echo -e "${YELLOW}   - Select 'main' as the branch and '/docs' as the folder${NC}"
    echo -e "${YELLOW}   - Click 'Save'${NC}"
    
    # Update API URL in docs/script.js
    read -p "Do you want to update the API URL in docs/script.js now? (y/n): " UPDATE_API_URL
    
    if [ "$UPDATE_API_URL" = "y" ] || [ "$UPDATE_API_URL" = "Y" ]; then
        echo -e "${BLUE}Updating API URL in docs/script.js...${NC}"
        
        # Replace API URL in docs/script.js
        sed -i "s|const API_BASE_URL = 'https://videoprocessingapp-api.ondigitalocean.app';|const API_BASE_URL = '${APP_URL}';|g" docs/script.js
        
        # Commit and push changes
        git add docs/script.js
        git commit -m "Update API URL with actual DigitalOcean App Platform URL"
        git push
        
        echo -e "${GREEN}API URL updated and changes pushed to GitHub.${NC}"
    fi
else
    echo -e "${RED}Deployment failed. Please check the error message above.${NC}"
fi

echo
echo -e "${GREEN}=== Deployment Process Complete ===${NC}"
