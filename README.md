# VideoProcessingApp Deployment

This repository contains the deployment configuration and web interface for the VideoProcessingApp, a .NET application for processing videos with silence removal and caption generation.

## Overview

The VideoProcessingApp is deployed using the following architecture:

- **Web Interface**: Hosted on GitHub Pages
- **API**: Deployed to Digital Ocean App Platform
- **Storage**: Digital Ocean Spaces (S3-compatible storage)

## Features

- Upload videos directly or provide URLs for processing
- Remove silence from videos
- Generate captions with word-by-word highlighting
- Track job status and receive webhook notifications
- View and download processed videos

## Repository Structure

- `/web`: Web interface files (HTML, CSS, JavaScript)
- `/config`: Configuration files for Digital Ocean App Platform
- `/.github/workflows`: GitHub Actions workflow files for CI/CD

## Prerequisites

To deploy this application, you'll need:

1. A GitHub account
2. A Digital Ocean account
3. Digital Ocean Spaces set up
4. Digital Ocean App Platform set up

## Setup Instructions

### 1. Fork or Clone this Repository

```bash
git clone https://github.com/yourusername/VideoProcessingApp-Deployment.git
cd VideoProcessingApp-Deployment
```

### 2. Set Up Digital Ocean Spaces

1. Log in to your Digital Ocean account
2. Create a new Space in your preferred region
3. Create access keys for the Space
4. Note down the Space name, region, endpoint, access key, and secret key

### 3. Set Up Digital Ocean App Platform

1. Log in to your Digital Ocean account
2. Create a new App
3. Connect to your GitHub repository
4. Configure the app using the `app.yaml` file in the `/config` directory
5. Set up the following environment variables:
   - `SPACES_ACCESS_KEY`: Your Digital Ocean Spaces access key
   - `SPACES_SECRET_KEY`: Your Digital Ocean Spaces secret key
   - `SPACES_BUCKET`: Your Digital Ocean Spaces bucket name
   - `SPACES_ENDPOINT`: Your Digital Ocean Spaces endpoint
   - `WEBHOOK_SECRET`: A secret key for webhook signatures

### 4. Set Up GitHub Secrets

Add the following secrets to your GitHub repository:

- `DIGITALOCEAN_ACCESS_TOKEN`: Your Digital Ocean API token
- `DIGITALOCEAN_APP_ID`: Your Digital Ocean App ID
- `SPACES_ACCESS_KEY`: Your Digital Ocean Spaces access key
- `SPACES_SECRET_KEY`: Your Digital Ocean Spaces secret key

### 5. Deploy the Application

The application will be automatically deployed when you push changes to the main branch. The GitHub Actions workflows will:

1. Build and test the application
2. Deploy the web interface to GitHub Pages
3. Deploy the API to Digital Ocean App Platform

## Usage

### Web Interface

The web interface is available at `https://yourusername.github.io/VideoProcessingApp-Deployment/`.

### API

The API is available at the URL provided by Digital Ocean App Platform. You can find this URL in the Digital Ocean App Platform dashboard.

### API Endpoints

#### Submit Job via URL

```http
POST /api/job/submit
Content-Type: application/json

{
  "videoUrl": "https://example.com/video.mp4",
  "silenceThreshold": -30,
  "silenceDuration": 0.5,
  "removeSilence": true,
  "generateCaptions": true,
  "captionStyle": "TikTok",
  "webhookUrl": "https://your-app.com/webhook"
}
```

#### Submit Job via File Upload

```http
POST /api/job/upload
Content-Type: multipart/form-data

file: [video file]
silenceThreshold: -30
silenceDuration: 0.5
removeSilence: true
generateCaptions: true
captionStyle: TikTok
webhookUrl: https://your-app.com/webhook
```

#### Get Job Status

```http
GET /api/job/status/{jobId}
```

#### Get All Jobs

```http
GET /api/job/all
```

#### Cancel Job

```http
POST /api/job/cancel/{jobId}
```

#### Download Processed Video

```http
GET /api/download/output/{jobId}/{filename}
```

## Development

### Local Development

1. Clone the repository
2. Install dependencies for the web interface:
   ```bash
   cd web
   npm install
   npm run dev
   ```
3. The web interface will be available at `http://localhost:3000`

### Making Changes

1. Make your changes
2. Commit and push to your repository
3. The GitHub Actions workflows will automatically deploy your changes

## Troubleshooting

### Common Issues

1. **API not accessible**: Check the Digital Ocean App Platform dashboard for any errors
2. **Web interface not updated**: Check the GitHub Actions workflow for any errors
3. **Storage issues**: Verify that the Digital Ocean Spaces access keys are correct

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
