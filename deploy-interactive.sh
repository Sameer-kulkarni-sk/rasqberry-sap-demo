#!/bin/bash

# Interactive RasQberry Deployment Script
# This script will prompt for password during deployment

# Configuration
RASQBERRY_IP="100.67.33.252"
RASQBERRY_USER="rasqberry"
PROJECT_NAME="rasqberry-sap-demo"
REMOTE_PATH="/home/$RASQBERRY_USER/$PROJECT_NAME"

echo "=========================================="
echo "RasQberry SAP Demo - Interactive Deployment"
echo "=========================================="
echo "Target: $RASQBERRY_USER@$RASQBERRY_IP"
echo "Remote Path: $REMOTE_PATH"
echo ""
echo "⚠️  You will be prompted for the SSH password multiple times"
echo "   Password: Qiskit1!"
echo ""

read -p "Press Enter to continue or Ctrl+C to cancel..."

# Test SSH connection
echo ""
echo "Step 1: Testing SSH connection..."
ssh -o ConnectTimeout=10 $RASQBERRY_USER@$RASQBERRY_IP "echo '✅ SSH connection successful' && uname -a"

if [ $? -ne 0 ]; then
    echo "❌ SSH connection failed. Please check:"
    echo "  - RasQberry is powered on"
    echo "  - IP address is correct: $RASQBERRY_IP"
    echo "  - Password is correct: Qiskit1!"
    exit 1
fi

# Check Node.js
echo ""
echo "Step 2: Checking Node.js installation..."
ssh $RASQBERRY_USER@$RASQBERRY_IP "node --version && npm --version" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "⚠️  Node.js not found or version check failed"
    echo "Installing Node.js on RasQberry..."
    ssh $RASQBERRY_USER@$RASQBERRY_IP "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
fi

# Create remote directory
echo ""
echo "Step 3: Creating remote directory..."
ssh $RASQBERRY_USER@$RASQBERRY_IP "mkdir -p $REMOTE_PATH"

# Transfer files
echo ""
echo "Step 4: Transferring project files..."
echo "This may take a few minutes..."
rsync -avz --progress \
    --exclude 'node_modules' \
    --exclude 'build' \
    --exclude '.git' \
    --exclude '.DS_Store' \
    --exclude '*.log' \
    ./ $RASQBERRY_USER@$RASQBERRY_IP:$REMOTE_PATH/

if [ $? -ne 0 ]; then
    echo "❌ File transfer failed"
    exit 1
fi

echo "✅ Files transferred successfully"

# Install dependencies
echo ""
echo "Step 5: Installing dependencies on RasQberry..."
echo "This may take several minutes..."
ssh $RASQBERRY_USER@$RASQBERRY_IP "cd $REMOTE_PATH && npm install"

if [ $? -ne 0 ]; then
    echo "❌ npm install failed"
    echo "Trying with --legacy-peer-deps..."
    ssh $RASQBERRY_USER@$RASQBERRY_IP "cd $REMOTE_PATH && npm install --legacy-peer-deps"
fi

# Build application
echo ""
echo "Step 6: Building the application..."
echo "This may take several minutes..."
ssh $RASQBERRY_USER@$RASQBERRY_IP "cd $REMOTE_PATH && npm run build"

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    echo "Trying with increased memory..."
    ssh $RASQBERRY_USER@$RASQBERRY_IP "cd $REMOTE_PATH && NODE_OPTIONS='--max-old-space-size=2048' npm run build"
fi

echo ""
echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
echo ""
echo "To start the application, run:"
echo ""
echo "  ssh $RASQBERRY_USER@$RASQBERRY_IP"
echo "  cd $REMOTE_PATH"
echo ""
echo "Then choose one of these options:"
echo ""
echo "Option 1 - Development mode:"
echo "  npm start"
echo ""
echo "Option 2 - Production mode (recommended):"
echo "  npm install -g serve"
echo "  serve -s build -l 3000"
echo ""
echo "Option 3 - Background mode:"
echo "  nohup serve -s build -l 3000 > app.log 2>&1 &"
echo ""
echo "Access the app at: http://$RASQBERRY_IP:3000"
echo ""