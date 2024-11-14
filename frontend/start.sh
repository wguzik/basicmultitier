#!/bin/sh

# Create env-config.js with runtime values
echo "window.ENV_CONFIG = {" > /app/build/env-config.js
if [ ! -z "$REACT_APP_API_URL" ]; then
    echo "  REACT_APP_API_URL: \"$REACT_APP_API_URL\"" >> /app/build/env-config.js
fi
echo "};" >> /app/build/env-config.js

echo "REACT_APP_API_URL=localhost:3000" > /app/.env

# Start the server
serve -s /app/build -l 3000