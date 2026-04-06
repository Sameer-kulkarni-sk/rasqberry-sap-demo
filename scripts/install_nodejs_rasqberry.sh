#!/bin/bash

# Install Node.js and npm on RasQberry
# This script installs Node.js LTS using NodeSource repository

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: RasQberry IP address required${NC}"
    echo "Usage: ./scripts/install_nodejs_rasqberry.sh YOUR_RASQBERRY_IP"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Installing Node.js and npm on RasQberry                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Target: ${RASQBERRY_USER}@${RASQBERRY_IP}${NC}"
echo -e "${YELLOW}You will be prompted for the RasQberry password${NC}"
echo ""

echo -e "${YELLOW}[1/4]${NC} Checking current Node.js installation..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
if command -v node &> /dev/null; then
    echo "Node.js is already installed:"
    node --version
    npm --version
else
    echo "Node.js is not installed"
fi
ENDSSH

echo ""
echo -e "${YELLOW}[2/4]${NC} Installing Node.js (this may take a few minutes)..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
set -e
echo "Updating package list..."
sudo apt-get update -qq

echo "Installing Node.js and npm..."
sudo apt-get install -y nodejs npm

echo "Installation complete!"
ENDSSH

echo ""
echo -e "${YELLOW}[3/4]${NC} Verifying installation..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "Node.js version:"
node --version
echo ""
echo "npm version:"
npm --version
echo ""
echo "Installation path:"
which node
which npm
ENDSSH

echo ""
echo -e "${YELLOW}[4/4]${NC} Updating npm to latest version..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
sudo npm install -g npm@latest
echo "npm updated to:"
npm --version
ENDSSH

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Installation Complete!                                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ Node.js and npm are now installed on RasQberry${NC}"
echo ""
echo "Next steps:"
echo "  1. Set up SSH keys (optional but recommended):"
echo -e "     ${YELLOW}./scripts/setup_ssh_keys.sh ${RASQBERRY_IP}${NC}"
echo ""
echo "  2. Deploy your application:"
echo -e "     ${YELLOW}./scripts/deploy_to_rasqberry.sh ${RASQBERRY_IP}${NC}"
echo ""