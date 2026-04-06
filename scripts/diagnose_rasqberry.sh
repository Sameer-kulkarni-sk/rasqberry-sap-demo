#!/bin/bash

# RasQberry Environment Diagnostic Script
# Run this manually in your terminal to diagnose the npm PATH issue

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: RasQberry IP address required${NC}"
    echo "Usage: ./scripts/diagnose_rasqberry.sh YOUR_RASQBERRY_IP"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RasQberry Environment Diagnostic                          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Target: ${RASQBERRY_USER}@${RASQBERRY_IP}${NC}"
echo -e "${YELLOW}You will be prompted for the RasQberry password${NC}"
echo ""

echo -e "${YELLOW}[1/5]${NC} Testing basic connection..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connection successful'"
echo ""

echo -e "${YELLOW}[2/5]${NC} Checking shell and environment..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "=== Basic Environment ==="
echo "Shell: $SHELL"
echo "Home: $HOME"
echo "User: $USER"
echo ""
ENDSSH

echo -e "${YELLOW}[3/5]${NC} Looking for conda installations..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "=== Conda Installations ==="
if [ -d ~/miniconda3 ]; then
    echo "✓ Found miniconda3 at: ~/miniconda3"
    ls -la ~/miniconda3/etc/profile.d/conda.sh 2>/dev/null || echo "  (conda.sh not found)"
fi
if [ -d ~/anaconda3 ]; then
    echo "✓ Found anaconda3 at: ~/anaconda3"
    ls -la ~/anaconda3/etc/profile.d/conda.sh 2>/dev/null || echo "  (conda.sh not found)"
fi
if [ -d ~/miniforge3 ]; then
    echo "✓ Found miniforge3 at: ~/miniforge3"
fi
echo ""
ENDSSH

echo -e "${YELLOW}[4/5]${NC} Searching for npm..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "=== NPM Locations ==="
echo "Searching for npm (this may take a moment)..."
find ~ -name npm -type f 2>/dev/null | head -10 || echo "npm not found in home directory"
echo ""
echo "Checking common locations:"
ls -la /usr/bin/npm 2>/dev/null && echo "✓ Found at /usr/bin/npm" || echo "✗ Not at /usr/bin/npm"
ls -la /usr/local/bin/npm 2>/dev/null && echo "✓ Found at /usr/local/bin/npm" || echo "✗ Not at /usr/local/bin/npm"
echo ""
ENDSSH

echo -e "${YELLOW}[5/5]${NC} Checking .bashrc configuration..."
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "=== .bashrc Content (conda-related) ==="
if [ -f ~/.bashrc ]; then
    echo "Conda initialization in .bashrc:"
    grep -A 10 "conda initialize" ~/.bashrc 2>/dev/null || echo "No conda initialization found"
else
    echo "No .bashrc file found"
fi
echo ""
ENDSSH

echo -e "${YELLOW}Testing with sourced .bashrc...${NC}"
ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "=== Testing with .bashrc sourced ==="
source ~/.bashrc 2>/dev/null || true
echo "PATH after sourcing .bashrc:"
echo "$PATH"
echo ""
echo "Can we find npm now?"
which npm 2>/dev/null || echo "npm still not found"
echo ""
echo "Node version (if available):"
node --version 2>/dev/null || echo "node not found"
echo ""
echo "NPM version (if available):"
npm --version 2>/dev/null || echo "npm not found"
ENDSSH

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Diagnostic Complete                                       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Please share the output above so we can fix the deployment script${NC}"