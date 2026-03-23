#!/bin/bash

# SAP Quantum Learning - Final Working Version
# JupyterLab Style Launcher

APP_DIR="/home/rasqberry/rasqberry-sap-demo"
PORT=3000
LOG_FILE="$APP_DIR/app.log"

cd "$APP_DIR"

# Kill existing server
echo "Checking for existing server..."
fuser -k $PORT/tcp 2>/dev/null
sleep 2

echo "Starting SAP Quantum Learning Platform..."
echo "Server will be available at http://localhost:$PORT"
echo ""

# Start server in background
nohup serve -s build -l $PORT > "$LOG_FILE" 2>&1 &
sleep 3

SERVER_URL="http://localhost:$PORT"
echo "✅ Server started at $SERVER_URL"
echo ""

# Force DISPLAY and open browser
export DISPLAY=:0
DISPLAY=:0 chromium-browser --new-window "$SERVER_URL" 2>/dev/null &

echo "✅ SAP Quantum Learning Platform is running!"
echo "📱 Access at: $SERVER_URL"
echo ""
echo "🛑 To stop the server, run: fuser -k $PORT/tcp"
echo "📋 View logs: tail -f $LOG_FILE"
echo ""
echo "Press Enter to stop the server..."

# Keep terminal open and wait for user
read

# Stop server when user presses Enter
echo "Stopping server..."
fuser -k $PORT/tcp
echo "Server stopped."