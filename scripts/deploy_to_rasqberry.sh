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

# Set up SSH connection multiplexing for single password prompt
CONTROL_PATH="$HOME/.ssh/control-rasqberry-${RASQBERRY_IP}"
SSH_KEY="$HOME/.ssh/rasqberry_key"
SSH_OPTS="-o ControlMaster=auto -o ControlPath=${CONTROL_PATH} -o ControlPersist=10m"

# Add SSH key if it exists
if [ -f "$SSH_KEY" ]; then
    SSH_OPTS="$SSH_OPTS -i $SSH_KEY"
fi

# Test connection and establish control master
echo -e "${YELLOW}[1/7]${NC} Establishing connection..."
if [ -f "$SSH_KEY" ]; then
    # Try with SSH key first
    if ssh -o ConnectTimeout=5 -o BatchMode=yes $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" 2>/dev/null; then
        echo -e "${GREEN}✓ Connection established (using SSH key)${NC}"
    else
        echo -e "${YELLOW}⚠ SSH key found but not working, using password${NC}"
        echo -e "${BLUE}You will be prompted for password ONCE${NC}"
        echo ""
        # Establish control master with password
        if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" > /dev/null 2>&1; then
            echo -e "${RED}✗ Cannot connect to RasQberry${NC}"
            exit 1
        fi
        echo -e "${GREEN}✓ Connection established (password saved for this session)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ SSH key not configured${NC}"
    echo -e "${BLUE}You will be prompted for password ONCE${NC}"
    echo ""
    echo "Tip: Run './scripts/setup_ssh_keys.sh ${RASQBERRY_IP}' to avoid passwords entirely"
    echo ""
    # Establish control master with password
    if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "echo 'Connected'" > /dev/null 2>&1; then
        echo -e "${RED}✗ Cannot connect to RasQberry${NC}"
        echo "Please check:"
        echo "  - IP address is correct"
        echo "  - RasQberry is powered on"
        echo "  - SSH is enabled on RasQberry"
        exit 1
    fi
    echo -e "${GREEN}✓ Connection established (password saved for this session)${NC}"
fi

# Transfer files
echo -e "${YELLOW}[2/7]${NC} Transferring files..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" "mkdir -p ~/${APP_NAME}"
RSYNC_OPTS="-avz"
if [ -n "$SSH_OPTS" ]; then
    RSYNC_OPTS="$RSYNC_OPTS -e 'ssh $SSH_OPTS'"
fi
if ! eval rsync $RSYNC_OPTS --exclude 'node_modules' --exclude '.git' --exclude 'build' --exclude 'dist' \
    ./ "${RASQBERRY_USER}@${RASQBERRY_IP}:~/${APP_NAME}/"; then
    echo -e "${RED}✗ File transfer failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Files transferred${NC}"

# Diagnose environment first
echo -e "${YELLOW}[3/7]${NC} Checking environment and installing dependencies..."
ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
echo "=== Environment Diagnostic ==="
echo "Shell: $SHELL"
echo "PATH: $PATH"
echo "Home: $HOME"
echo ""
echo "Checking for conda installations:"
ls -la ~/miniconda3/etc/profile.d/conda.sh 2>/dev/null && echo "Found miniconda3" || echo "No miniconda3"
ls -la ~/anaconda3/etc/profile.d/conda.sh 2>/dev/null && echo "Found anaconda3" || echo "No anaconda3"
echo ""
echo "Checking for npm:"
which npm 2>/dev/null || echo "npm not in PATH"
echo ""
echo "Checking .bashrc for conda:"
grep -i conda ~/.bashrc 2>/dev/null | head -5 || echo "No conda in .bashrc"
echo ""
echo "Trying to find npm:"
find ~ -name npm -type f 2>/dev/null | head -5 || echo "npm not found"
ENDSSH

# Now try installation with better environment setup
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
set -e
# Try multiple ways to initialize environment
export PATH="$HOME/miniconda3/bin:$HOME/anaconda3/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Try sourcing conda
for conda_path in ~/miniconda3/etc/profile.d/conda.sh ~/anaconda3/etc/profile.d/conda.sh; do
    if [ -f "$conda_path" ]; then
        source "$conda_path"
        conda activate base 2>/dev/null || true
        break
    fi
done

# Source bashrc
source ~/.bashrc 2>/dev/null || true
source ~/.profile 2>/dev/null || true

cd ~/rasqberry-sap-demo
echo "Current PATH: $PATH"
echo "Installing npm packages..."
npm install --silent
ENDSSH
then
    echo -e "${RED}✗ Dependency installation failed${NC}"
    echo "Check logs on RasQberry for details"
    exit 1
fi
echo -e "${GREEN}✓ Dependencies installed${NC}"

echo -e "${YELLOW}[4/7]${NC} Building application..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
set -e
# Initialize conda/miniconda environment
if [ -f ~/miniconda3/etc/profile.d/conda.sh ]; then
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate base
elif [ -f ~/anaconda3/etc/profile.d/conda.sh ]; then
    source ~/anaconda3/etc/profile.d/conda.sh
    conda activate base
fi
source ~/.bashrc 2>/dev/null || true
cd ~/rasqberry-sap-demo
echo "Building React app..."
npm run build
ENDSSH
then
    echo -e "${RED}✗ Build failed${NC}"
    echo "Check logs on RasQberry for details"
    exit 1
fi
echo -e "${GREEN}✓ Application built${NC}"

# Install serve if needed
echo -e "${YELLOW}[5/7]${NC} Setting up server..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
set -e
source ~/.bashrc 2>/dev/null || true
if ! command -v serve &> /dev/null; then
    echo "Installing serve globally (may require sudo)..."
    if sudo npm install -g serve --silent 2>/dev/null; then
        echo "Serve installed globally with sudo"
    else
        echo "Global install failed, installing locally in project..."
        cd ~/rasqberry-sap-demo
        npm install serve --save-dev
        echo "Serve installed locally"
    fi
else
    echo "Serve already installed"
fi
ENDSSH
then
    echo -e "${RED}✗ Server setup failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Server ready${NC}"

# Start application server (but don't launch browser)
echo -e "${YELLOW}[6/7]${NC} Starting application server..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
set -e
source ~/.bashrc 2>/dev/null || true
cd ~/rasqberry-sap-demo

# Stop any existing instance
echo "Stopping any existing instances..."
fuser -k 3000/tcp 2>/dev/null || true
pkill -f chromium 2>/dev/null || true

# Start app in background - try global serve first, then local
echo "Starting application server..."
if command -v serve &> /dev/null; then
    # Use global serve
    nohup serve -s build -l 3000 > /tmp/sap-quantum-app.log 2>&1 &
else
    # Use local serve via npx
    nohup npx serve -s build -l 3000 > /tmp/sap-quantum-app.log 2>&1 &
fi

sleep 2

# Verify server is running
if curl -s http://localhost:3000 > /dev/null; then
    echo "Server is running on port 3000"
else
    echo "Warning: Server may not have started properly"
fi

echo "Server started. Use desktop icon to launch the app."
ENDSSH
then
    echo -e "${RED}✗ Application server start failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Application server started${NC}"

# Create desktop shortcut
echo -e "${YELLOW}[7/7]${NC} Creating desktop shortcut..."
if ! ssh $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" bash << 'ENDSSH'
set -e
# Create desktop directory if it doesn't exist
mkdir -p ~/Desktop

# Create desktop entry
cat > ~/Desktop/"Sap Quantum Learning.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Sap Quantum Learning
Comment=Interactive Quantum Computing Learning Application
Exec=chromium-browser --app=http://localhost:3000
Icon=/home/rasqberry/rasqberry-sap-demo/app-icon.png
Terminal=false
Categories=Education;Science;
StartupNotify=true
EOF

# Make it executable
chmod +x ~/Desktop/"Sap Quantum Learning.desktop"

# Also create in applications menu
mkdir -p ~/.local/share/applications
cp ~/Desktop/"Sap Quantum Learning.desktop" ~/.local/share/applications/

echo "Desktop shortcut created"
ENDSSH
then
    echo -e "${YELLOW}⚠ Desktop shortcut creation failed (non-critical)${NC}"
else
    echo -e "${GREEN}✓ Desktop shortcut created${NC}"
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Deployment Complete!                                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ Server running at: http://${RASQBERRY_IP}:3000${NC}"
echo -e "${GREEN}✓ Desktop shortcut created: 'SAP Quantum Learning'${NC}"
echo ""
echo "To launch the app:"
echo -e "  ${YELLOW}• Double-click 'SAP Quantum Learning' icon on RasQberry desktop${NC}"
echo ""
echo "Alternative access methods:"
echo "  • Web Browser: http://${RASQBERRY_IP}:3000"
echo "  • VNC Viewer: ${RASQBERRY_IP}:5900"
echo ""
echo "The server is running in the background and will start automatically on reboot."
echo ""

# Clean up SSH control master
ssh -O exit $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" 2>/dev/null || true

# Clean up SSH control master
ssh -O exit $SSH_OPTS "${RASQBERRY_USER}@${RASQBERRY_IP}" 2>/dev/null || true