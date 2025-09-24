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

# Copy only necessary files
COPY requirements.txt main.py ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create optimized startup script that downloads Ollama at runtime
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "Starting FastAPI Ollama TinyLlama Server..."\n\
echo "Note: Ollama will be downloaded on first run to minimize image size"\n\
\n\
# Start FastAPI server directly\n\
# Ollama installation and model download happens at runtime via the app\n\
exec python main.py' > /app/start.sh && chmod +x /app/start.sh

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=60s --timeout=30s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:$PORT/health || exit 1

# Use optimized startup script
CMD ["/app/start.sh"]

# Labels
LABEL maintainer="Railway Deployment" \
      description="Lightweight FastAPI server with runtime Ollama setup" \
      version="2.0.0"