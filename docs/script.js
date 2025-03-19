document.addEventListener('DOMContentLoaded', function() {
    // API base URL - replace with your actual API URL from DigitalOcean
    const API_BASE_URL = 'https://videoprocessingapp-api.ondigitalocean.app';
    
    // Upload method switching
    const uploadMethods = document.querySelectorAll('.upload-method');
    const uploadForms = document.querySelectorAll('.upload-form');
    
    uploadMethods.forEach(method => {
        method.addEventListener('click', function() {
            const methodType = this.getAttribute('data-method');
            
            // Update active method
            uploadMethods.forEach(m => m.classList.remove('active'));
            this.classList.add('active');
            
            // Show corresponding form
            uploadForms.forEach(form => form.classList.remove('active'));
            document.getElementById(`upload-${methodType}-form`).classList.add('active');
        });
    });
    
    // Range input value display
    const rangeInputs = document.querySelectorAll('input[type="range"]');
    
    rangeInputs.forEach(input => {
        const valueDisplay = input.nextElementSibling;
        
        // Set initial value
        if (input.id.includes('threshold')) {
            valueDisplay.textContent = `${input.value} dB`;
        } else if (input.id.includes('duration')) {
            valueDisplay.textContent = `${input.value} seconds`;
        }
        
        // Update value on change
        input.addEventListener('input', function() {
            if (this.id.includes('threshold')) {
                valueDisplay.textContent = `${this.value} dB`;
            } else if (this.id.includes('duration')) {
                valueDisplay.textContent = `${this.value} seconds`;
            }
        });
    });
    
    // File upload visual feedback
    const fileInput = document.getElementById('file-upload');
    const fileLabel = document.querySelector('.file-upload-label span');
    const fileContainer = document.querySelector('.file-upload-container');
    
    fileInput.addEventListener('change', function() {
        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            fileLabel.textContent = fileName;
            fileContainer.style.borderColor = '#0066cc';
        } else {
            fileLabel.textContent = 'Drag & drop or click to select';
            fileContainer.style.borderColor = '#ddd';
        }
    });
    
    // Form submissions
    const fileForm = document.getElementById('upload-file-form');
    const urlForm = document.getElementById('upload-url-form');
    
    fileForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const formData = new FormData();
        
        // Add file
        const fileInput = document.getElementById('file-upload');
        if (fileInput.files.length === 0) {
            alert('Please select a video file');
            return;
        }
        formData.append('file', fileInput.files[0]);
        
        // Add other parameters
        formData.append('silenceThreshold', document.getElementById('silence-threshold').value);
        formData.append('silenceDuration', document.getElementById('silence-duration').value);
        formData.append('removeSilence', document.getElementById('remove-silence').checked);
        formData.append('generateCaptions', document.getElementById('generate-captions').checked);
        formData.append('captionStyle', document.getElementById('caption-style').value);
        
        const webhookUrl = document.getElementById('webhook-url').value;
        if (webhookUrl) {
            formData.append('webhookUrl', webhookUrl);
        }
        
        try {
            // Show loading state
            const submitButton = fileForm.querySelector('button[type="submit"]');
            const originalText = submitButton.textContent;
            submitButton.textContent = 'Processing...';
            submitButton.disabled = true;
            
            // Submit the form
            const response = await fetch(`${API_BASE_URL}/api/job/upload`, {
                method: 'POST',
                body: formData
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            // Reset form
            fileForm.reset();
            fileLabel.textContent = 'Drag & drop or click to select';
            fileContainer.style.borderColor = '#ddd';
            
            // Show success message
            alert(`Job submitted successfully! Job ID: ${result.jobId}`);
            
            // Refresh jobs list
            fetchJobs();
            
            // Reset button
            submitButton.textContent = originalText;
            submitButton.disabled = false;
        } catch (error) {
            console.error('Error submitting job:', error);
            alert('Error submitting job. Please try again.');
            
            // Reset button
            const submitButton = fileForm.querySelector('button[type="submit"]');
            submitButton.textContent = 'Process Video';
            submitButton.disabled = false;
        }
    });
    
    urlForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const videoUrl = document.getElementById('video-url').value;
        if (!videoUrl) {
            alert('Please enter a video URL');
            return;
        }
        
        const jobData = {
            videoUrl: videoUrl,
            silenceThreshold: parseInt(document.getElementById('silence-threshold-url').value),
            silenceDuration: parseFloat(document.getElementById('silence-duration-url').value),
            removeSilence: document.getElementById('remove-silence-url').checked,
            generateCaptions: document.getElementById('generate-captions-url').checked,
            captionStyle: document.getElementById('caption-style-url').value
        };
        
        const webhookUrl = document.getElementById('webhook-url-url').value;
        if (webhookUrl) {
            jobData.webhookUrl = webhookUrl;
        }
        
        try {
            // Show loading state
            const submitButton = urlForm.querySelector('button[type="submit"]');
            const originalText = submitButton.textContent;
            submitButton.textContent = 'Processing...';
            submitButton.disabled = true;
            
            // Submit the form
            const response = await fetch(`${API_BASE_URL}/api/job/submit`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(jobData)
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            // Reset form
            urlForm.reset();
            
            // Show success message
            alert(`Job submitted successfully! Job ID: ${result.jobId}`);
            
            // Refresh jobs list
            fetchJobs();
            
            // Reset button
            submitButton.textContent = originalText;
            submitButton.disabled = false;
        } catch (error) {
            console.error('Error submitting job:', error);
            alert('Error submitting job. Please try again.');
            
            // Reset button
            const submitButton = urlForm.querySelector('button[type="submit"]');
            submitButton.textContent = 'Process Video';
            submitButton.disabled = false;
        }
    });
    
    // Jobs list functionality
    async function fetchJobs() {
        try {
            const response = await fetch(`${API_BASE_URL}/api/job/all`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const jobs = await response.json();
            
            const jobsList = document.getElementById('jobs-list');
            
            if (jobs.length === 0) {
                jobsList.innerHTML = '<div class="no-jobs">No jobs found. Upload a video to get started.</div>';
                return;
            }
            
            jobsList.innerHTML = '';
            
            jobs.forEach(job => {
                const jobItem = document.createElement('div');
                jobItem.className = 'job-item';
                
                const jobId = document.createElement('div');
                jobId.className = 'job-id';
                jobId.textContent = job.id;
                
                const jobStatus = document.createElement('div');
                jobStatus.className = `job-status ${job.status.toLowerCase()}`;
                jobStatus.textContent = job.status;
                
                const jobCreated = document.createElement('div');
                jobCreated.className = 'job-created';
                jobCreated.textContent = new Date(job.createdAt).toLocaleString();
                
                const jobActions = document.createElement('div');
                jobActions.className = 'job-actions';
                
                // View action
                const viewAction = document.createElement('div');
                viewAction.className = 'job-action view';
                viewAction.textContent = 'View';
                viewAction.addEventListener('click', () => viewJob(job.id));
                
                // Download action (only for completed jobs)
                if (job.status === 'Completed') {
                    const downloadAction = document.createElement('div');
                    downloadAction.className = 'job-action download';
                    downloadAction.textContent = 'Download';
                    downloadAction.addEventListener('click', () => downloadJob(job.id, job.outputFilename));
                    jobActions.appendChild(downloadAction);
                }
                
                // Cancel action (only for queued or processing jobs)
                if (job.status === 'Queued' || job.status === 'Processing') {
                    const cancelAction = document.createElement('div');
                    cancelAction.className = 'job-action cancel';
                    cancelAction.textContent = 'Cancel';
                    cancelAction.addEventListener('click', () => cancelJob(job.id));
                    jobActions.appendChild(cancelAction);
                }
                
                jobActions.appendChild(viewAction);
                
                jobItem.appendChild(jobId);
                jobItem.appendChild(jobStatus);
                jobItem.appendChild(jobCreated);
                jobItem.appendChild(jobActions);
                
                jobsList.appendChild(jobItem);
            });
        } catch (error) {
            console.error('Error fetching jobs:', error);
            const jobsList = document.getElementById('jobs-list');
            jobsList.innerHTML = '<div class="no-jobs">Error fetching jobs. Please try again later.</div>';
        }
    }
    
    async function viewJob(jobId) {
        try {
            const response = await fetch(`${API_BASE_URL}/api/job/status/${jobId}`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const job = await response.json();
            
            // Create a modal to display job details
            const modal = document.createElement('div');
            modal.className = 'modal';
            
            const modalContent = document.createElement('div');
            modalContent.className = 'modal-content';
            
            const closeButton = document.createElement('span');
            closeButton.className = 'close-button';
            closeButton.innerHTML = '&times;';
            closeButton.addEventListener('click', () => {
                document.body.removeChild(modal);
            });
            
            const title = document.createElement('h2');
            title.textContent = `Job Details: ${jobId}`;
            
            const details = document.createElement('div');
            details.className = 'job-details';
            
            // Format job details
            let detailsHTML = `
                <div class="detail-item">
                    <div class="detail-label">Status:</div>
                    <div class="detail-value ${job.status.toLowerCase()}">${job.status}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Created:</div>
                    <div class="detail-value">${new Date(job.createdAt).toLocaleString()}</div>
                </div>
            `;
            
            if (job.status === 'Completed') {
                detailsHTML += `
                    <div class="detail-item">
                        <div class="detail-label">Completed:</div>
                        <div class="detail-value">${new Date(job.completedAt).toLocaleString()}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Original Duration:</div>
                        <div class="detail-value">${job.stats.originalDuration.toFixed(2)} seconds</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Processed Duration:</div>
                        <div class="detail-value">${job.stats.processedDuration.toFixed(2)} seconds</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Silence Removed:</div>
                        <div class="detail-value">${job.stats.silenceDurationRemoved.toFixed(2)} seconds (${job.stats.silencePeriodsRemoved} periods)</div>
                    </div>
                `;
                
                if (job.stats.captionWordCount) {
                    detailsHTML += `
                        <div class="detail-item">
                            <div class="detail-label">Caption Words:</div>
                            <div class="detail-value">${job.stats.captionWordCount}</div>
                        </div>
                    `;
                }
                
                detailsHTML += `
                    <div class="detail-item">
                        <div class="detail-label">Processing Time:</div>
                        <div class="detail-value">${job.stats.processingDuration.toFixed(2)} seconds</div>
                    </div>
                `;
            } else if (job.status === 'Failed') {
                detailsHTML += `
                    <div class="detail-item">
                        <div class="detail-label">Error:</div>
                        <div class="detail-value error">${job.errorMessage}</div>
                    </div>
                `;
            }
            
            details.innerHTML = detailsHTML;
            
            modalContent.appendChild(closeButton);
            modalContent.appendChild(title);
            modalContent.appendChild(details);
            
            if (job.status === 'Completed') {
                const downloadButton = document.createElement('button');
                downloadButton.className = 'btn';
                downloadButton.textContent = 'Download Video';
                downloadButton.addEventListener('click', () => {
                    downloadJob(job.id, job.outputFilename);
                });
                
                modalContent.appendChild(downloadButton);
            }
            
            modal.appendChild(modalContent);
            document.body.appendChild(modal);
            
            // Add modal styles if not already added
            if (!document.getElementById('modal-styles')) {
                const modalStyles = document.createElement('style');
                modalStyles.id = 'modal-styles';
                modalStyles.textContent = `
                    .modal {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background-color: rgba(0, 0, 0, 0.5);
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        z-index: 1000;
                    }
                    
                    .modal-content {
                        background-color: white;
                        padding: 30px;
                        border-radius: 10px;
                        max-width: 600px;
                        width: 90%;
                        max-height: 90vh;
                        overflow-y: auto;
                        position: relative;
                    }
                    
                    .close-button {
                        position: absolute;
                        top: 15px;
                        right: 15px;
                        font-size: 1.5rem;
                        cursor: pointer;
                        color: #666;
                    }
                    
                    .job-details {
                        margin: 20px 0;
                    }
                    
                    .detail-item {
                        display: flex;
                        margin-bottom: 10px;
                        border-bottom: 1px solid #eee;
                        padding-bottom: 10px;
                    }
                    
                    .detail-label {
                        font-weight: 500;
                        width: 150px;
                        color: #333;
                    }
                    
                    .detail-value {
                        flex: 1;
                    }
                    
                    .detail-value.completed {
                        color: #2ecc71;
                    }
                    
                    .detail-value.failed {
                        color: #e74c3c;
                    }
                    
                    .detail-value.processing {
                        color: #3498db;
                    }
                    
                    .detail-value.queued {
                        color: #f39c12;
                    }
                    
                    .detail-value.error {
                        color: #e74c3c;
                    }
                `;
                document.head.appendChild(modalStyles);
            }
        } catch (error) {
            console.error('Error fetching job details:', error);
            alert('Error fetching job details. Please try again.');
        }
    }
    
    function downloadJob(jobId, filename) {
        window.open(`${API_BASE_URL}/api/download/output/${jobId}/${filename}`);
    }
    
    async function cancelJob(jobId) {
        if (!confirm(`Are you sure you want to cancel job ${jobId}?`)) {
            return;
        }
        
        try {
            const response = await fetch(`${API_BASE_URL}/api/job/cancel/${jobId}`, {
                method: 'POST'
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            alert('Job cancelled successfully');
            
            // Refresh jobs list
            fetchJobs();
        } catch (error) {
            console.error('Error cancelling job:', error);
            alert('Error cancelling job. Please try again.');
        }
    }
    
    // Initial jobs fetch
    fetchJobs();
    
    // Periodically refresh jobs list
    setInterval(fetchJobs, 30000); // Every 30 seconds
});
