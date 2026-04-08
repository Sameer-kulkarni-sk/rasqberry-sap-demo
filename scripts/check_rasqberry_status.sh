#!/bin/bash

# RasQberry SAP Quantum App Status Check Script
# This script checks the current state of the deployed application

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: RasQberry IP address required${NC}"
    echo "Usage: ./scripts/check_rasqberry_status.sh YOUR_RASQBERRY_IP"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RasQberry SAP Quantum App - Status Check                  ║${NC}"
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
echo -e "${YELLOW}[1/8]${NC} Testing connection..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" > /dev/null 2>&1; then
    echo -e "${RED}✗ Cannot connect to RasQberry${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Connected${NC}"
echo ""

# Check if application directory exists
echo -e "${YELLOW}[2/8]${NC} Checking application files..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if [ -d ~/rasqberry-sap-demo ]; then
    echo "✓ Application directory exists: ~/rasqberry-sap-demo"
    echo "  Files:"
    ls -lh ~/rasqberry-sap-demo | head -10
    echo ""
    if [ -d ~/rasqberry-sap-demo/build ]; then
        echo "✓ Build directory exists"
        echo "  Build size: $(du -sh ~/rasqberry-sap-demo/build | cut -f1)"
    else
        echo "✗ Build directory NOT found"
    fi
else
    echo "✗ Application directory NOT found"
fi
ENDSSH
echo ""

# Check Node.js and npm
echo -e "${YELLOW}[3/8]${NC} Checking Node.js environment..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if command -v node &> /dev/null; then
    echo "✓ Node.js installed: $(node --version)"
else
    echo "✗ Node.js NOT installed"
fi

if command -v npm &> /dev/null; then
    echo "✓ npm installed: $(npm --version)"
else
    echo "✗ npm NOT installed"
fi

if command -v serve &> /dev/null; then
    echo "✓ serve installed: $(serve --version 2>&1 | head -1)"
else
    echo "✗ serve NOT installed globally"
fi
ENDSSH
echo ""

# Check if server is running
echo -e "${YELLOW}[4/8]${NC} Checking server status..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if lsof -i :3000 &> /dev/null; then
    echo "✓ Server is running on port 3000"
    echo "  Process:"
    lsof -i :3000 | grep LISTEN || true
else
    echo "✗ No server running on port 3000"
fi
ENDSSH
echo ""

# Check if app is accessible
echo -e "${YELLOW}[5/8]${NC} Testing application accessibility..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    echo "✓ Application is accessible at http://localhost:3000"
    echo "  HTTP Status: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)"
else
    echo "✗ Application is NOT accessible"
    echo "  HTTP Status: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)"
fi
ENDSSH
echo ""

# Check browser status
echo -e "${YELLOW}[6/8]${NC} Checking browser status..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if pgrep -f chromium &> /dev/null; then
    echo "✓ Chromium browser is running"
    echo "  Processes:"
    pgrep -fa chromium | head -3
else
    echo "✗ Chromium browser is NOT running"
fi
ENDSSH
echo ""

# Check desktop shortcut
echo -e "${YELLOW}[7/8]${NC} Checking desktop shortcut..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if [ -f ~/Desktop/"Sap Quantum Learning.desktop" ]; then
    echo "✓ Desktop shortcut exists"
    echo "  Location: ~/Desktop/Sap Quantum Learning.desktop"
else
    echo "✗ Desktop shortcut NOT found"
fi
ENDSSH
echo ""

# Check logs
echo -e "${YELLOW}[8/8]${NC} Checking application logs..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if [ -f /tmp/sap-quantum-app.log ]; then
    echo "✓ Log file exists: /tmp/sap-quantum-app.log"
    echo "  Last 10 lines:"
    echo "  ----------------------------------------"
    tail -10 /tmp/sap-quantum-app.log 2>/dev/null || echo "  (empty or unreadable)"
    echo "  ----------------------------------------"
else
    echo "✗ Log file NOT found"
fi
ENDSSH
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Status Check Complete                                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Clean up SSH control master
ssh -O exit $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" 2>/dev/null || true