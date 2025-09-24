# FastAPI Ollama TinyLlama Docker Container
# ==========================================
# This Dockerfile creates a complete container with:
# - Python 3.11 runtime
# - Ollama AI platform
# - TinyLlama model pre-downloaded
# - FastAPI server ready to run

# Use official Python 3.11 slim image as base
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PORT=5000

# Set working directory
WORKDIR /app

# Install system dependencies required for Ollama and Python packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY requirements.txt ./
COPY pyproject.toml ./
COPY main.py ./

# Install Python dependencies from requirements.txt (includes hypercorn for Railway)
RUN pip install -r requirements.txt

# Install Ollama
# Download and install Ollama using the official install script
RUN curl -fsSL https://ollama.ai/install.sh | sh

# Create a script to start services
RUN echo '#!/bin/bash\n\
echo "Starting Ollama service..."\n\
ollama serve &\n\
echo "Waiting for Ollama to start..."\n\
sleep 10\n\
echo "Downloading TinyLlama model..."\n\
ollama pull tinyllama\n\
echo "TinyLlama model downloaded successfully"\n\
echo "Starting FastAPI server..."\n\
python main.py' > /app/start_services.sh

# Make the start script executable
RUN chmod +x /app/start_services.sh

# Alternative startup script for production use
RUN echo '#!/bin/bash\n\
# Start Ollama service in background\n\
ollama serve &\n\
OLLAMA_PID=$!\n\
\n\
# Wait for Ollama to be ready\n\
echo "Waiting for Ollama service to start..."\n\
for i in {1..30}; do\n\
    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then\n\
        echo "Ollama service is ready"\n\
        break\n\
    fi\n\
    echo "Attempt $i: Ollama not ready yet, waiting..."\n\
    sleep 2\n\
done\n\
\n\
# Download TinyLlama model if not present\n\
echo "Checking for TinyLlama model..."\n\
if ! ollama list | grep -q tinyllama; then\n\
    echo "Downloading TinyLlama model..."\n\
    ollama pull tinyllama\n\
    echo "TinyLlama model downloaded"\n\
else\n\
    echo "TinyLlama model already available"\n\
fi\n\
\n\
# Start FastAPI server with dynamic port support\n\
echo "Starting FastAPI server on port $PORT..."\n\
if command -v hypercorn >/dev/null 2>&1; then\n\
    echo "Using Hypercorn for production deployment"\n\
    hypercorn main:app --bind 0.0.0.0:$PORT --workers 1\n\
else\n\
    echo "Using Uvicorn for local development"\n\
    uvicorn main:app --host 0.0.0.0 --port $PORT\n\
fi\n\
\n\
# Cleanup on exit\n\
kill $OLLAMA_PID 2>/dev/null || true' > /app/production_start.sh

RUN chmod +x /app/production_start.sh

# Expose port dynamically (supports Railway, Heroku, Render, etc.)
EXPOSE 5000

# Health check to verify the container is working
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:$PORT/health || exit 1

# Set default command to run the production startup script
CMD ["/app/production_start.sh"]

# Optional: Labels for better container management
LABEL maintainer="Replit Agent" \
      description="FastAPI server with Ollama and TinyLlama model" \
      version="1.0.0"

# Volume for persistent data (optional)
VOLUME ["/root/.ollama"]

# Instructions for building and running:
# ====================================
# 
# Build the image:
# docker build -t fastapi-ollama-tinyllama .
# 
# Run the container:
# docker run -p 5000:5000 --name ollama-server fastapi-ollama-tinyllama
#
# For development with volume mounting:
# docker run -p 5000:5000 -v $(pwd):/app --name ollama-dev fastapi-ollama-tinyllama
#
# Check health:
# curl http://localhost:5000/health
#
# Test chat endpoint:
# curl -X POST http://localhost:5000/chat \
#   -H "Content-Type: application/json" \
#   -d '{"prompt": "Hello, how are you?"}'