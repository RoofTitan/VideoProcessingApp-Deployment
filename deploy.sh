#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== VideoProcessingApp Complete Deployment ===${NC}"
echo -e "${YELLOW}This script will deploy both the API to DigitalOcean and the web interface to GitHub Pages.${NC}"
echo

# Check if scripts exist
if [ ! -f "./deploy-to-digitalocean.sh" ]; then
    echo -e "${RED}Error: deploy-to-digitalocean.sh not found.${NC}"
    exit 1
fi

if [ ! -f "./enable-github-pages.sh" ]; then
    echo -e "${RED}Error: enable-github-pages.sh not found.${NC}"
    exit 1
fi

# Make sure scripts are executable
chmod +x ./deploy-to-digitalocean.sh
chmod +x ./enable-github-pages.sh

# Step 1: Deploy to DigitalOcean
echo -e "${BLUE}Step 1: Deploying API to DigitalOcean App Platform...${NC}"
./deploy-to-digitalocean.sh

# Check if DigitalOcean deployment was successful
if [ $? -ne 0 ]; then
    echo -e "${RED}DigitalOcean deployment failed. Stopping deployment process.${NC}"
    exit 1
fi

# Step 2: Enable GitHub Pages
echo -e "${BLUE}Step 2: Enabling GitHub Pages for web interface...${NC}"
./enable-github-pages.sh

# Check if GitHub Pages setup was successful
if [ $? -ne 0 ]; then
    echo -e "${RED}GitHub Pages setup failed. Please try manually.${NC}"
    echo -e "${YELLOW}The API has been deployed to DigitalOcean, but the web interface setup failed.${NC}"
    exit 1
fi

echo
echo -e "${GREEN}=== Deployment Complete! ===${NC}"
echo -e "${GREEN}Your VideoProcessingApp has been successfully deployed:${NC}"
echo -e "${YELLOW}1. API: Check the output of the DigitalOcean deployment for the API URL${NC}"
echo -e "${YELLOW}2. Web Interface: Check the output of the GitHub Pages setup for the web URL${NC}"
echo
echo -e "${BLUE}Note: It may take a few minutes for GitHub Pages to build and deploy your site.${NC}"
echo -e "${BLUE}You can check the status of your GitHub Pages deployment in the repository's Actions tab.${NC}"
