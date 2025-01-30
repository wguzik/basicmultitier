#!/bin/sh

echo "REACT_APP_API_URL: ${REACT_APP_API_URL}"

# thank you stackoverflow
find /app -type f -exec sed -i "s|http://localhost:3005|${REACT_APP_API_URL}|g" {} +

# Start the server
serve -s /app/build -l 3000