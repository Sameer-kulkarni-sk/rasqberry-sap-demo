# Installation Guide - RasQberry SAP Quantum Learning

## 🚀 Super Easy Installation (Recommended)

### Method 1: One-Command Install from GitHub

On your RasQberry, run these 3 commands:

```bash
# 1. Clone the repository
git clone https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo.git
cd rasqberry-sap-demo

# 2. Run the installer
./install-on-rasqberry.sh
```

That's it! The installer will:
- ✅ Install Node.js (if needed)
- ✅ Install all dependencies
- ✅ Build the application
- ✅ Install serve
- ✅ Create desktop icon
- ✅ Set up everything automatically

**Time:** 5-10 minutes (depending on internet speed)

### Method 2: Manual Installation

If you prefer step-by-step:

```bash
# 1. Clone repository
git clone https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo.git
cd rasqberry-sap-demo

# 2. Install dependencies
npm install

# 3. Build application
npm run build

# 4. Install serve
sudo npm install -g serve

# 5. Setup desktop icon
cp sap-quantum-learning.desktop ~/Desktop/
chmod +x ~/Desktop/sap-quantum-learning.desktop
gio set ~/Desktop/sap-quantum-learning.desktop metadata::trusted true
```

## 📦 Alternative: Transfer from USB/Local

If you have the project on a USB drive or local computer:

### From USB Drive

```bash
# 1. Copy from USB to home directory
cp -r /media/usb/rasqberry-sap-demo ~/
cd ~/rasqberry-sap-demo

# 2. Run installer
./install-on-rasqberry.sh
```

### From Your Computer (via SCP)

```bash
# On your computer
scp -r rasqberry-sap-demo rasqberry@100.67.33.252:~/

# Then SSH into RasQberry
ssh rasqberry@100.67.33.252
cd ~/rasqberry-sap-demo
./install-on-rasqberry.sh
```

## 🎯 Launch the Application

After installation, you have 3 options:

### Option 1: Desktop Icon (Easiest)
Double-click the "SAP Quantum Learning" icon on your desktop!

### Option 2: Command Line
```bash
cd ~/rasqberry-sap-demo
./start-app.sh
```

### Option 3: Manual Start
```bash
cd ~/rasqberry-sap-demo
serve -s build -l 3000
```

Then open browser to: http://localhost:3000

## ✅ Verify Installation

Check if everything is installed correctly:

```bash
cd ~/rasqberry-sap-demo

# Check Node.js
node --version  # Should show v14 or higher

# Check if built
ls build/index.html  # Should exist

# Check serve
which serve  # Should show path

# Check desktop icon
ls ~/Desktop/sap-quantum-learning.desktop  # Should exist
```

## 🔧 Troubleshooting

### Installation Script Fails

```bash
# Make sure script is executable
chmod +x install-on-rasqberry.sh

# Run with sudo if needed
sudo ./install-on-rasqberry.sh
```

### Node.js Not Found

```bash
# Install Node.js manually
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### npm install Fails

```bash
# Clear cache and try again
npm cache clean --force
rm -rf node_modules
npm install
```

### Build Fails

```bash
# Increase memory
NODE_OPTIONS="--max-old-space-size=2048" npm run build
```

### Desktop Icon Doesn't Appear

```bash
# Manually copy and set permissions
cp sap-quantum-learning.desktop ~/Desktop/
chmod +x ~/Desktop/sap-quantum-learning.desktop
gio set ~/Desktop/sap-quantum-learning.desktop metadata::trusted true

# Refresh desktop
pcmanfm --desktop --profile LXDE-pi &
```

## 📊 System Requirements

- **Device:** Raspberry Pi 3/4 (RasQberry)
- **OS:** Raspberry Pi OS (Debian-based)
- **RAM:** 2GB minimum, 4GB recommended
- **Storage:** 2GB free space
- **Network:** Internet connection for initial setup

## 🔄 Update the Application

To update to the latest version:

```bash
cd ~/rasqberry-sap-demo

# Pull latest changes
git pull origin main

# Reinstall and rebuild
npm install
npm run build

# Restart the app
fuser -k 3000/tcp
./start-app.sh
```

## 🗑️ Uninstall

To remove the application:

```bash
# Stop the app
fuser -k 3000/tcp

# Remove files
rm -rf ~/rasqberry-sap-demo
rm ~/Desktop/sap-quantum-learning.desktop

# Optionally remove serve
sudo npm uninstall -g serve
```

## 📚 Next Steps

After installation:
1. Read `README.md` for full documentation
2. Check `QUICKSTART.md` for usage guide
3. Start learning quantum computing!

## 🆘 Need Help?

- Check `README.md` for detailed documentation
- Review `QUICKSTART.md` for quick tips
- Visit [RasQberry.org](https://rasqberry.org/) for community support

---

**Installation should take 5-10 minutes. Enjoy learning quantum computing with SAP! 🚀**