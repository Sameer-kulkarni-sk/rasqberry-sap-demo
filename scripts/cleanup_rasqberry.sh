#!/bin/bash

# RasQberry SAP Quantum Demo Cleanup Script
# This script removes all deployed files and processes from RasQberry

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: RasQberry IP address required${NC}"
    echo "Usage: ./scripts/cleanup_rasqberry.sh YOUR_RASQBERRY_IP"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RasQberry SAP Quantum Demo - Cleanup                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Target: ${RASQBERRY_USER}@${RASQBERRY_IP}${NC}"
echo -e "${YELLOW}This will remove all SAP Quantum Demo files and processes${NC}"
echo ""

# Set up SSH connection multiplexing
CONTROL_PATH="$HOME/.ssh/control-rasqberry-${RASQBERRY_IP}"
SSH_KEY="$HOME/.ssh/rasqberry_key"
SSH_OPTS="-o ControlMaster=auto -o ControlPath=${CONTROL_PATH} -o ControlPersist=10m"

if [ -f "$SSH_KEY" ]; then
    SSH_OPTS="$SSH_OPTS -i $SSH_KEY"
fi

# Establish connection
echo -e "${YELLOW}[1/5]${NC} Establishing connection..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" > /dev/null 2>&1; then
    echo -e "${RED}✗ Cannot connect to RasQberry${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Connected${NC}"

# Stop running processes
echo -e "${YELLOW}[2/5]${NC} Stopping application processes..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
# Stop server on port 3000
echo "Stopping server..."
fuser -k 3000/tcp 2>/dev/null || true

# Kill any chromium instances
echo "Closing browser..."
pkill -f chromium 2>/dev/null || true

# Kill any serve processes
pkill -f "serve -s build" 2>/dev/null || true

echo "Processes stopped"
ENDSSH
echo -e "${GREEN}✓ Processes stopped${NC}"

# Remove application files
echo -e "${YELLOW}[3/5]${NC} Removing application files..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
# Remove application directory
if [ -d ~/rasqberry-sap-demo ]; then
    echo "Removing ~/rasqberry-sap-demo..."
    rm -rf ~/rasqberry-sap-demo
    echo "Application directory removed"
else
    echo "Application directory not found"
fi

# Remove log file
if [ -f /tmp/sap-quantum-app.log ]; then
    echo "Removing log file..."
    rm -f /tmp/sap-quantum-app.log
fi
ENDSSH
echo -e "${GREEN}✓ Application files removed${NC}"

# Remove desktop shortcut
echo -e "${YELLOW}[4/5]${NC} Removing desktop shortcut..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
# Remove desktop shortcut
if [ -f ~/Desktop/"Sap Quantum Learning.desktop" ]; then
    echo "Removing desktop shortcut..."
    rm -f ~/Desktop/"Sap Quantum Learning.desktop"
    echo "Desktop shortcut removed"
else
    echo "Desktop shortcut not found"
fi

# Remove from applications menu
if [ -f ~/.local/share/applications/"Sap Quantum Learning.desktop" ]; then
    rm -f ~/.local/share/applications/"Sap Quantum Learning.desktop"
    echo "Application menu entry removed"
fi
ENDSSH
echo -e "${GREEN}✓ Desktop shortcut removed${NC}"

# Optional: Remove Node.js (ask user)
echo ""
echo -e "${YELLOW}[5/5]${NC} Node.js cleanup..."
echo -e "${BLUE}Do you want to remove Node.js and npm? (y/n)${NC}"
read -p "Remove Node.js? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
    echo "Removing Node.js and npm..."
    sudo apt-get remove -y nodejs npm 2>/dev/null || true
    sudo apt-get autoremove -y 2>/dev/null || true
    echo "Node.js removed"
ENDSSH
    echo -e "${GREEN}✓ Node.js removed${NC}"
else
    echo -e "${YELLOW}⊘ Node.js kept (skipped)${NC}"
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Cleanup Complete!                                         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ All SAP Quantum Demo files and processes removed${NC}"
echo ""
echo "RasQberry is now clean and ready for fresh deployment."
echo ""

# Clean up SSH control master
ssh -O exit $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" 2>/dev/null || true