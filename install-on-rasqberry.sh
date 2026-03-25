#!/bin/bash

# RasQberry SAP Quantum Learning - One-Command Installer
# Run this script ON the RasQberry device after cloning the repository

set -e  # Exit on any error

echo "=========================================="
echo "RasQberry SAP Quantum Learning Installer"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found!"
    echo "Please run this script from the rasqberry-sap-demo directory"
    exit 1
fi

echo "✅ Found project directory"
echo ""

# Step 1: Install Node.js if needed
echo "Step 1: Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

NODE_VERSION=$(node --version)
echo "✅ Node.js installed: $NODE_VERSION"
echo ""

# Step 2: Install dependencies
echo "Step 2: Installing dependencies..."
echo "This may take several minutes..."
npm install
echo "✅ Dependencies installed"
echo ""

# Step 3: Build the application
echo "Step 3: Building application..."
echo "This may take several minutes..."
npm run build
echo "✅ Application built"
echo ""

# Step 4: Install serve
echo "Step 4: Installing serve..."
if ! command -v serve &> /dev/null; then
    sudo npm install -g serve
fi
echo "✅ Serve installed"
echo ""

# Step 5: Install lxterminal
echo "Step 5: Installing lxterminal..."
if ! command -v lxterminal &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y lxterminal
fi
echo "✅ lxterminal installed"
echo ""

# Step 6: Setup desktop icon
echo "Step 6: Setting up desktop icon..."
cp sap-quantum-learning.desktop ~/Desktop/
chmod +x ~/Desktop/sap-quantum-learning.desktop
gio set ~/Desktop/sap-quantum-learning.desktop metadata::trusted true 2>/dev/null || true
echo "✅ Desktop icon created"
echo ""

# Step 7: Make scripts executable
echo "Step 7: Making scripts executable..."
chmod +x start-app.sh
chmod +x deploy-interactive.sh
echo "✅ Scripts ready"
echo ""

echo "=========================================="
echo "✅ Installation Complete!"
echo "=========================================="
echo ""
echo "🎉 SAP Quantum Learning Platform is ready!"
echo ""
echo "To start the application:"
echo "  1. Double-click the desktop icon, OR"
echo "  2. Run: ./start-app.sh"
echo ""
echo "The app will open at: http://localhost:3000"
echo ""
echo "📚 Documentation:"
echo "  - README.md - Full documentation"
echo "  - QUICKSTART.md - Quick start guide"
echo ""
echo "🆘 Troubleshooting:"
echo "  - Stop server: fuser -k 3000/tcp"
echo "  - View logs: tail -f app.log"
echo "  - Rebuild: npm run build"
echo ""
echo "Happy Learning! 🚀"
echo ""