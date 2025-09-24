# FastAPI Ollama TinyLlama Docker Container - Optimized for Railway
# ================================================================
# Lightweight container that downloads Ollama at runtime to reduce image size

FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PORT=5000

# Set working directory
WORKDIR /app

# Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Copy necessary files
COPY requirements.txt main.py start.sh ./

# Make startup script executable
RUN chmod +x start.sh

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=60s --timeout=30s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:${PORT:-5000}/health || exit 1

# Use startup script
CMD ["./start.sh"]

# Labels
LABEL maintainer="Railway Deployment" \
      description="Lightweight FastAPI server with runtime Ollama setup" \
      version="2.0.0"