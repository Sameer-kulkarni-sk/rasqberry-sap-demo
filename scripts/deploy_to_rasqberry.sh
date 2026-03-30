#!/bin/bash

# RasQberry SAP Quantum Learning App - One-Line Deployment Script
# Usage: ./scripts/deploy_to_rasqberry.sh YOUR_RASQBERRY_IP
# Example: ./scripts/deploy_to_rasqberry.sh 100.67.33.252

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if IP provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: RasQberry IP address required${NC}"
    echo "Usage: ./scripts/deploy_to_rasqberry.sh YOUR_RASQBERRY_IP"
    echo "Example: ./scripts/deploy_to_rasqberry.sh 100.67.33.252"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"
APP_NAME="rasqberry-sap-demo"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RasQberry SAP Quantum Learning App - Deployment          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Target: ${RASQBERRY_USER}@${RASQBERRY_IP}${NC}"
echo ""

# Test connection
echo -e "${YELLOW}[1/6]${NC} Testing connection..."
if ! ssh -o ConnectTimeout=5 "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" > /dev/null 2>&1; then
    echo -e "${RED}✗ Cannot connect to RasQberry${NC}"
    echo "Please check:"
    echo "  - IP address is correct"
    echo "  - RasQberry is powered on"
    echo "  - SSH is enabled on RasQberry"
    exit 1
fi
echo -e "${GREEN}✓ Connection successful${NC}"

# Transfer files
echo -e "${YELLOW}[2/6]${NC} Transferring files..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" "mkdir -p ~/${APP_NAME}"
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude 'build' --exclude 'dist' \
    ./ "${RASQBERRY_USER}@${RASQBERRY_IP}:~/${APP_NAME}/" > /dev/null 2>&1
echo -e "${GREEN}✓ Files transferred${NC}"

# Install dependencies and build
echo -e "${YELLOW}[3/6]${NC} Installing dependencies..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" << 'ENDSSH'
cd ~/rasqberry-sap-demo
npm install --silent > /dev/null 2>&1
ENDSSH
echo -e "${GREEN}✓ Dependencies installed${NC}"

echo -e "${YELLOW}[4/6]${NC} Building application..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" << 'ENDSSH'
cd ~/rasqberry-sap-demo
npm run build > /dev/null 2>&1
ENDSSH
echo -e "${GREEN}✓ Application built${NC}"

# Install serve if needed
echo -e "${YELLOW}[5/6]${NC} Setting up server..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" << 'ENDSSH'
if ! command -v serve &> /dev/null; then
    npm install -g serve --silent > /dev/null 2>&1
fi
ENDSSH
echo -e "${GREEN}✓ Server ready${NC}"

# Start application
echo -e "${YELLOW}[6/6]${NC} Starting application..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" << 'ENDSSH'
cd ~/rasqberry-sap-demo
# Stop any existing instance
fuser -k 3000/tcp 2>/dev/null || true
# Start app in background
nohup serve -s build -l 3000 > /tmp/sap-quantum-app.log 2>&1 &
sleep 2
# Start browser
export DISPLAY=:0
pkill -f chromium 2>/dev/null || true
nohup chromium-browser --kiosk --noerrdialogs --disable-infobars http://localhost:3000 > /dev/null 2>&1 &
ENDSSH
echo -e "${GREEN}✓ Application started${NC}"

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Deployment Complete!                                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ App running at: http://${RASQBERRY_IP}:3000${NC}"
echo -e "${GREEN}✓ Browser launched in kiosk mode on RasQberry${NC}"
echo ""
echo "Access the app:"
echo "  • Web Browser: http://${RASQBERRY_IP}:3000"
echo "  • VNC Viewer: ${RASQBERRY_IP}:5900"
echo ""