# VideoProcessingApp GitHub Deployment Guide

This guide will walk you through the process of deploying the VideoProcessingApp to GitHub Pages and Digital Ocean.

## Prerequisites

- GitHub account
- Digital Ocean account
- Git installed on your local machine

## Step 1: Push Code to GitHub

1. Run the `fix-git-push.sh` script to initialize the Git repository and push the code to GitHub:

```bash
./fix-git-push.sh
```

2. Follow the prompts to enter your GitHub username and repository name.

## Step 2: Set Up GitHub Pages

1. Run the `setup-github-pages.sh` script to set up GitHub Pages:

```bash
./setup-github-pages.sh
```

2. This script will:
   - Create a docs directory
   - Copy the web files to the docs directory
   - Create an index.html file in the root directory
   - Commit and push the changes to GitHub

3. Go to your GitHub repository settings and enable GitHub Pages:
   - Navigate to your repository on GitHub
   - Click on "Settings"
   - Scroll down to the "GitHub Pages" section
   - Select "main" as the branch and "/docs" as the folder
   - Click "Save"

## Step 3: Set Up Digital Ocean Spaces for Storage

1. Log in to your Digital Ocean account
2. Navigate to "Spaces" in the left sidebar
3. Click "Create a Space"
4. Choose a region close to your users
5. Name your space (e.g., "videoprocessingapp")
6. Click "Create a Space"
7. Create an API key:
   - Navigate to "API" in the left sidebar
   - Click "Generate New Key"
   - Name your key (e.g., "VideoProcessingApp")
   - Copy the Access Key and Secret Key

## Step 4: Set Up Digital Ocean App Platform for the API

1. Log in to your Digital Ocean account
2. Navigate to "Apps" in the left sidebar
3. Click "Create App"
4. Choose "GitHub" as the source
5. Select your VideoProcessingApp-Deployment repository
6. Select the "main" branch
7. Configure the app:
   - Choose the "api" directory as the source directory
   - The API is a simple Node.js Express application that provides endpoints for video processing
   - Set the environment variables:
     - `DO_SPACES_KEY`: Your Digital Ocean Spaces Access Key
     - `DO_SPACES_SECRET`: Your Digital Ocean Spaces Secret Key
     - `DO_SPACES_ENDPOINT`: Your Digital Ocean Spaces Endpoint (e.g., "nyc3.digitaloceanspaces.com")
     - `DO_SPACES_BUCKET`: Your Digital Ocean Spaces Bucket Name (e.g., "videoprocessingapp")
8. Click "Next"
9. Choose the "Basic" plan
10. Click "Create Resources"

### Troubleshooting DigitalOcean Deployment

If you encounter an error like "target source directory does not exist: invalid argument" when deploying to DigitalOcean, make sure:

1. The "api" directory exists in your repository
2. The "api" directory contains at least:
   - index.js - The main API file
   - package.json - With proper dependencies and start script

## Step 5: Configure GitHub Repository Settings and Secrets

1. Run the `setup-github-repo.sh` script to set up GitHub Secrets:

```bash
./setup-github-repo.sh
```

2. Follow the prompts to enter your Digital Ocean API key and other required information.

## Step 6: Update the API URL in the Web Interface

1. Edit the `docs/script.js` file to update the API URL with your actual API URL from Digital Ocean:

```bash
# Edit the file
nano docs/script.js

# Find the line that looks like:
const API_URL = 'https://your-api-url.ondigitalocean.app';

# Replace it with your actual API URL from Digital Ocean:
const API_URL = 'https://your-actual-api-url.ondigitalocean.app';

# Save the file
```

2. Commit and push the changes to GitHub:

```bash
git add docs/script.js
git commit -m "Update API URL"
git push
```

## Step 7: Verify the Deployment

1. Web Interface: https://yourusername.github.io/VideoProcessingApp-Deployment/
2. API: The URL provided by Digital Ocean App Platform

## Next Steps

After deployment, you may want to:

1. Add custom domains for both the web interface and API
2. Set up monitoring for the API
3. Implement authentication for the API
4. Add more features to the web interface

## Troubleshooting

### GitHub Pages Not Working

1. Make sure you've enabled GitHub Pages in your repository settings
2. Check that the "main" branch and "/docs" folder are selected
3. Wait a few minutes for GitHub Pages to build and deploy your site

### API Not Working

1. Check the logs in Digital Ocean App Platform
2. Make sure all environment variables are set correctly
3. Check that the API is properly configured to use Digital Ocean Spaces

### Git Push Issues

If you encounter issues pushing to GitHub, run the `fix-git-push.sh` script again to fix the issues.
