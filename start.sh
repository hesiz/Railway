
#!/bin/bash

# Railway startup script with proper port handling
# Set default port if PORT environment variable is not set
PORT=${PORT:-5000}

echo "Starting FastAPI server on port $PORT"
uvicorn main:app --host 0.0.0.0 --port $PORT
