
#!/bin/bash

# Railway startup script
echo "Starting FastAPI server..."
echo "PORT environment variable: $PORT"

# Use Python to handle the port variable properly
python3 -c "
import os
import subprocess
port = os.environ.get('PORT', '5000')
print(f'Starting server on port {port}')
subprocess.run(['uvicorn', 'main:app', '--host', '0.0.0.0', '--port', port])
"
