const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Add CORS middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  next();
});

app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Video processing endpoint
app.post('/api/process', (req, res) => {
  const { videoUrl, options } = req.body;
  
  // In a real implementation, this would start a video processing job
  // For now, we'll just return a mock response
  res.status(202).json({
    jobId: `job-${Date.now()}`,
    status: 'processing',
    videoUrl,
    options,
    estimatedCompletionTime: new Date(Date.now() + 60000).toISOString()
  });
});

// Job status endpoint
app.get('/api/jobs/:jobId', (req, res) => {
  const { jobId } = req.params;
  
  // In a real implementation, this would fetch the job status from a database
  // For now, we'll just return a mock response
  res.status(200).json({
    jobId,
    status: 'completed',
    result: {
      processedVideoUrl: `https://example.com/videos/${jobId}.mp4`,
      duration: 120,
      size: 1024 * 1024 * 10 // 10MB
    }
  });
});

app.listen(port, () => {
  console.log(`Video processing API listening at http://localhost:${port}`);
});
