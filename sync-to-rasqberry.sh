#!/bin/bash

# Automated sync script for RasQberry at 100.67.33.252
# This script transfers changed files and rebuilds the app

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RASQBERRY_IP="100.67.33.252"
RASQBERRY_USER="rasqberry"
RASQBERRY_PATH="~/rasqberry-sap-demo"
LOCAL_PATH="/Users/sameerkulkarni/Desktop/rasqberry-sap-demo"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}RasQberry Sync Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Step 1: Transfer changed files
echo -e "${GREEN}Step 1: Transferring changed files...${NC}"
echo "Files to transfer:"
echo "  - src/App.tsx (updated SAP logo)"
echo "  - public/sap-logo-new.png (new SAP logo)"
echo "  - package.json"
echo "  - SHARING_GUIDE.md"
echo "  - DEPLOY_TO_RASQBERRY.md"
echo "  - SYNC_CHANGES.md"
echo ""

scp "${LOCAL_PATH}/src/App.tsx" \
    "${RASQBERRY_USER}@${RASQBERRY_IP}:${RASQBERRY_PATH}/src/"

scp "${LOCAL_PATH}/public/sap-logo-new.png" \
    "${RASQBERRY_USER}@${RASQBERRY_IP}:${RASQBERRY_PATH}/public/"

scp "${LOCAL_PATH}/package.json" \
    "${LOCAL_PATH}/SHARING_GUIDE.md" \
    "${LOCAL_PATH}/DEPLOY_TO_RASQBERRY.md" \
    "${LOCAL_PATH}/SYNC_CHANGES.md" \
    "${RASQBERRY_USER}@${RASQBERRY_IP}:${RASQBERRY_PATH}/"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Files transferred successfully${NC}"
else
    echo -e "${RED}✗ File transfer failed${NC}"
    exit 1
fi

echo ""

# Step 2: Rebuild on RasQberry
echo -e "${GREEN}Step 2: Rebuilding app on RasQberry...${NC}"
echo "This will:"
echo "  - Reinstall npm dependencies"
echo "  - Rebuild the React app"
echo "  - Restart the application"
echo ""

ssh "${RASQBERRY_USER}@${RASQBERRY_IP}" << 'ENDSSH'
    set -e
    cd ~/rasqberry-sap-demo
    
    echo "→ Installing dependencies..."
    npm install
    
    echo "→ Building React app..."
    npm run build
    
    echo "→ Stopping any running instances..."
    fuser -k 3000/tcp 2>/dev/null || true
    
    echo "→ Starting the app..."
    nohup serve -s build -l 3000 > /dev/null 2>&1 &
    
    echo "✓ App rebuilt and restarted successfully!"
ENDSSH

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Rebuild completed successfully${NC}"
else
    echo -e "${RED}✗ Rebuild failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}✓ Sync Complete!${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""
echo "The app is now running on RasQberry at:"
echo "  http://100.67.33.252:3000"
echo ""
echo "You can also access it from RasQberry's browser at:"
echo "  http://localhost:3000"
echo ""
echo -e "${GREEN}All changes have been applied!${NC}"