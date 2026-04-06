#!/bin/bash

# SSH Key Setup Script for RasQberry
# This eliminates password prompts during deployment

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
    echo "Usage: ./scripts/setup_ssh_keys.sh YOUR_RASQBERRY_IP [username]"
    echo "Example: ./scripts/setup_ssh_keys.sh 100.67.33.242"
    exit 1
fi

RASQBERRY_IP="$1"
RASQBERRY_USER="${2:-rasqberry}"
KEY_FILE="$HOME/.ssh/rasqberry_key"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  SSH Key Setup for RasQberry                               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Target: ${RASQBERRY_USER}@${RASQBERRY_IP}${NC}"
echo ""

# Check if key already exists
if [ -f "$KEY_FILE" ]; then
    echo -e "${YELLOW}SSH key already exists at: ${KEY_FILE}${NC}"
    read -p "Do you want to use the existing key? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Generating new SSH key...${NC}"
        ssh-keygen -t ed25519 -f "$KEY_FILE" -C "rasqberry-deployment" -N ""
        echo -e "${GREEN}✓ New SSH key generated${NC}"
    fi
else
    echo -e "${YELLOW}Generating SSH key...${NC}"
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -f "$KEY_FILE" -C "rasqberry-deployment" -N ""
    echo -e "${GREEN}✓ SSH key generated${NC}"
fi

echo ""
echo -e "${YELLOW}Copying SSH key to RasQberry...${NC}"
echo -e "${BLUE}You will be prompted for the RasQberry password ONE TIME${NC}"
echo ""

if ssh-copy-id -i "$KEY_FILE" "${RASQBERRY_USER}@${RASQBERRY_IP}"; then
    echo ""
    echo -e "${GREEN}✓ SSH key successfully copied to RasQberry${NC}"
    
    # Add SSH config entry
    SSH_CONFIG="$HOME/.ssh/config"
    if ! grep -q "Host rasqberry" "$SSH_CONFIG" 2>/dev/null; then
        echo ""
        echo -e "${YELLOW}Adding SSH config entry...${NC}"
        cat >> "$SSH_CONFIG" << EOF

# RasQberry Configuration
Host rasqberry
    HostName ${RASQBERRY_IP}
    User ${RASQBERRY_USER}
    IdentityFile ${KEY_FILE}
    ControlMaster auto
    ControlPath ~/.ssh/control-%r@%h:%p
    ControlPersist 10m
EOF
        echo -e "${GREEN}✓ SSH config updated${NC}"
    fi
    
    # Test connection
    echo ""
    echo -e "${YELLOW}Testing passwordless connection...${NC}"
    if ssh -o BatchMode=yes -o StrictHostKeyChecking=no -i "$KEY_FILE" "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Success'" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Passwordless SSH working!${NC}"
        echo ""
        echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${BLUE}║  Setup Complete!                                           ║${NC}"
        echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}You can now run deployment without password prompts:${NC}"
        echo -e "${YELLOW}  ./scripts/deploy_to_rasqberry.sh ${RASQBERRY_IP}${NC}"
        echo ""
    else
        echo -e "${RED}✗ Passwordless connection test failed${NC}"
        echo "Please check the setup and try again"
        exit 1
    fi
else
    echo ""
    echo -e "${RED}✗ Failed to copy SSH key${NC}"
    echo "Please check:"
    echo "  - RasQberry IP address is correct"
    echo "  - RasQberry is powered on and accessible"
    echo "  - SSH is enabled on RasQberry"
    exit 1
fi