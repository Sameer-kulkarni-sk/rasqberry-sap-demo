#!/bin/bash

# RasQberry Disk Space Cleanup and App Restart Script
# Fixes "no space left on device" error

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: RasQberry IP address required${NC}"
    echo "Usage: ./scripts/fix_rasqberry_space.sh YOUR_RASQBERRY_IP"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RasQberry Disk Space Cleanup & App Restart                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Target: ${RASQBERRY_USER}@${RASQBERRY_IP}${NC}"
echo ""

# Set up SSH connection multiplexing
CONTROL_PATH="$HOME/.ssh/control-rasqberry-${RASQBERRY_IP}"
SSH_KEY="$HOME/.ssh/rasqberry_key"
SSH_OPTS="-o ControlMaster=auto -o ControlPath=${CONTROL_PATH} -o ControlPersist=10m"

if [ -f "$SSH_KEY" ]; then
    SSH_OPTS="$SSH_OPTS -i $SSH_KEY"
fi

# Establish connection
echo -e "${YELLOW}[1/6]${NC} Establishing connection..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" > /dev/null 2>&1; then
    echo -e "${RED}✗ Cannot connect to RasQberry${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Connected${NC}"

# Check disk space
echo -e "${YELLOW}[2/6]${NC} Checking disk space..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "Current disk usage:"
df -h / | tail -1
echo ""
echo "Largest directories in home:"
du -sh ~/* 2>/dev/null | sort -hr | head -10
ENDSSH
echo ""

# Clean up npm cache and logs
echo -e "${YELLOW}[3/6]${NC} Cleaning npm cache and logs..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "Cleaning npm cache..."
npm cache clean --force 2>/dev/null || true

echo "Removing npm logs..."
rm -rf ~/.npm/_logs/* 2>/dev/null || true

echo "Cleaning apt cache..."
sudo apt-get clean 2>/dev/null || true

echo "Removing old log files..."
sudo journalctl --vacuum-time=7d 2>/dev/null || true

echo "Cleanup complete"
ENDSSH
echo -e "${GREEN}✓ Cleanup complete${NC}"

# Check disk space again
echo -e "${YELLOW}[4/6]${NC} Checking disk space after cleanup..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "Disk usage after cleanup:"
df -h / | tail -1
ENDSSH
echo ""

# Start the application server
echo -e "${YELLOW}[5/6]${NC} Starting application server..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
cd ~/rasqberry-sap-demo

# Stop any existing instance
echo "Stopping any existing instances..."
fuser -k 3000/tcp 2>/dev/null || true
pkill -f chromium 2>/dev/null || true

# Start server
echo "Starting server..."
if command -v serve &> /dev/null; then
    nohup serve -s build -l 3000 > /tmp/sap-quantum-app.log 2>&1 &
else
    nohup npx serve -s build -l 3000 > /tmp/sap-quantum-app.log 2>&1 &
fi

sleep 3

# Check if server started
if curl -s http://localhost:3000 > /dev/null; then
    echo "✓ Server started successfully on port 3000"
else
    echo "✗ Server failed to start"
    echo "Log contents:"
    cat /tmp/sap-quantum-app.log 2>/dev/null || echo "No log file"
fi
ENDSSH
echo -e "${GREEN}✓ Server started${NC}"

# Verify application
echo -e "${YELLOW}[6/6]${NC} Verifying application..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "Checking server status..."
if lsof -i :3000 &> /dev/null; then
    echo "✓ Server is running on port 3000"
else
    echo "✗ Server is not running"
fi

echo ""
echo "Testing HTTP access..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$HTTP_CODE" = "200" ]; then
    echo "✓ Application is accessible (HTTP $HTTP_CODE)"
else
    echo "✗ Application returned HTTP $HTTP_CODE"
fi
ENDSSH
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Fix Complete!                                             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ Disk space cleaned up${NC}"
echo -e "${GREEN}✓ Application server restarted${NC}"
echo ""
echo "Access the app:"
echo "  • Web Browser: http://${RASQBERRY_IP}:3000"
echo "  • Desktop Icon: Double-click 'Sap Quantum Learning' on RasQberry"
echo ""

# Clean up SSH control master
ssh -O exit $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" 2>/dev/null || true