# 🤝 Sharing Guide: How to Deploy on Another RasQberry

This guide explains how to share this SAP Quantum Learning Platform with friends and deploy it on their RasQberry devices.

## 📋 Table of Contents
- [Method 1: Direct Clone (Recommended)](#method-1-direct-clone-recommended)
- [Method 2: USB Transfer](#method-2-usb-transfer)
- [Method 3: SCP Transfer](#method-3-scp-transfer)
- [Comparison Table](#comparison-table)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Method 1: Direct Clone (Recommended)

**Best for:** Most users, easiest method  
**Requirements:** RasQberry with internet connection

### Steps:

1. **Connect to RasQberry**
   - Connect keyboard, mouse, and monitor to RasQberry
   - OR connect via SSH: `ssh rasqberry@<RASQBERRY_IP>`

2. **Open Terminal on RasQberry**

3. **Clone and Install**
   ```bash
   # Clone the repository
   git clone https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo.git
   
   # Navigate to the project
   cd rasqberry-sap-demo
   
   # Run the installer (does everything automatically)
   ./install-on-rasqberry.sh
   ```

4. **Launch the App**
   - Double-click the "SAP Quantum Learning" icon on desktop
   - OR run: `./start-app.sh`

### ✅ Advantages:
- No file transfer needed
- Always gets the latest version
- Simplest method (just 3 commands)
- Works from anywhere with internet

---

## 💾 Method 2: USB Transfer

**Best for:** RasQberry without internet connection  
**Requirements:** USB drive, computer with internet

### Steps:

#### On Your Computer:

1. **Download the Project**
   - Go to: https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo
   - Click the green "Code" button
   - Select "Download ZIP"
   - Extract the ZIP file

2. **Copy to USB Drive**
   ```bash
   # Copy the extracted folder to USB
   cp -r rasqberry-sap-demo /Volumes/USB_DRIVE/
   # (On Windows: just drag and drop to USB drive)
   ```

#### On RasQberry:

3. **Insert USB Drive**
   - Wait for it to mount (usually at `/media/pi/` or `/media/rasqberry/`)

4. **Copy from USB to Home Directory**
   ```bash
   # Find USB mount point
   ls /media/pi/
   # or
   ls /media/rasqberry/
   
   # Copy to home directory
   cp -r /media/pi/USB_DRIVE/rasqberry-sap-demo ~/
   # or
   cp -r /media/rasqberry/USB_DRIVE/rasqberry-sap-demo ~/
   ```

5. **Install and Run**
   ```bash
   cd ~/rasqberry-sap-demo
   ./install-on-rasqberry.sh
   ```

### ✅ Advantages:
- Works without internet on RasQberry
- Can share with multiple people via USB
- Good for offline environments

---

## 🌐 Method 3: SCP Transfer

**Best for:** Tech-savvy users, local network transfer  
**Requirements:** Computer and RasQberry on same network

### Steps:

#### On Your Computer:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo.git
   cd rasqberry-sap-demo
   ```

2. **Find RasQberry IP Address**
   - On RasQberry, run: `hostname -I`
   - OR check your router's connected devices

3. **Transfer via SCP**
   ```bash
   # Transfer the entire project folder
   scp -r rasqberry-sap-demo rasqberry@<RASQBERRY_IP>:~/
   
   # Example:
   # scp -r rasqberry-sap-demo rasqberry@192.168.1.100:~/
   ```
   - Default password is usually: `Qoffee42`

#### On RasQberry:

4. **SSH into RasQberry**
   ```bash
   ssh rasqberry@<RASQBERRY_IP>
   ```

5. **Install and Run**
   ```bash
   cd ~/rasqberry-sap-demo
   ./install-on-rasqberry.sh
   ```

### ✅ Advantages:
- Fast transfer over local network
- Can customize files before transferring
- Good for development/testing

---

## 📊 Comparison Table

| Method | Internet on RasQberry | Complexity | Transfer Speed | Best For |
|--------|----------------------|------------|----------------|----------|
| **Direct Clone** | ✅ Required | ⭐ Easiest | Fast | Most users |
| **USB Transfer** | ❌ Not needed | ⭐⭐ Easy | Medium | Offline setups |
| **SCP Transfer** | ❌ Not needed | ⭐⭐⭐ Medium | Very Fast | Tech users |

---

## 🔧 Troubleshooting

### Problem: "Permission denied" when running install script

**Solution:**
```bash
chmod +x install-on-rasqberry.sh
./install-on-rasqberry.sh
```

### Problem: "git: command not found"

**Solution:**
```bash
sudo apt-get update
sudo apt-get install git
```

### Problem: USB drive not detected

**Solution:**
```bash
# Check if USB is mounted
lsblk

# Manually mount if needed
sudo mount /dev/sda1 /mnt
cp -r /mnt/rasqberry-sap-demo ~/
```

### Problem: SCP connection refused

**Solution:**
```bash
# On RasQberry, ensure SSH is enabled
sudo systemctl start ssh
sudo systemctl enable ssh

# Check if SSH is running
sudo systemctl status ssh
```

### Problem: Port 3000 already in use

**Solution:**
```bash
# Kill existing process on port 3000
fuser -k 3000/tcp

# Or find and kill manually
lsof -i :3000
kill -9 <PID>
```

### Problem: Desktop icon doesn't appear

**Solution:**
```bash
# Refresh desktop
killall pcmanfm

# Or manually copy desktop file
cp sap-quantum-learning.desktop ~/Desktop/
chmod +x ~/Desktop/sap-quantum-learning.desktop
```

---

## 📝 What Your Friend Needs to Know

Share this checklist with your friend:

### ✅ Pre-Installation Checklist:
- [ ] RasQberry is powered on and running
- [ ] (Method 1) RasQberry has internet connection
- [ ] (Method 2) USB drive with project files
- [ ] (Method 3) Computer and RasQberry on same network
- [ ] Know the RasQberry password (default: `Qoffee42`)

### ✅ Post-Installation:
- [ ] Desktop icon appears: "SAP Quantum Learning"
- [ ] App opens in browser at http://localhost:3000
- [ ] All quantum concepts are accessible
- [ ] Interactive circuit composer works

---

## 🚀 Quick Reference Commands

### For Direct Clone (Method 1):
```bash
git clone https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo.git
cd rasqberry-sap-demo
./install-on-rasqberry.sh
```

### For USB Transfer (Method 2):
```bash
cp -r /media/pi/USB_DRIVE/rasqberry-sap-demo ~/
cd ~/rasqberry-sap-demo
./install-on-rasqberry.sh
```

### For SCP Transfer (Method 3):
```bash
# On computer:
scp -r rasqberry-sap-demo rasqberry@<IP>:~/

# On RasQberry:
cd ~/rasqberry-sap-demo
./install-on-rasqberry.sh
```

---

## 📞 Support

If your friend encounters issues:

1. **Check the logs:**
   ```bash
   cd ~/rasqberry-sap-demo
   cat install.log
   ```

2. **Verify installation:**
   ```bash
   node --version  # Should show v18.x or higher
   npm --version   # Should show 9.x or higher
   which serve     # Should show /usr/local/bin/serve
   ```

3. **Manual start:**
   ```bash
   cd ~/rasqberry-sap-demo
   ./start-app.sh
   ```

---

## 🎓 Additional Resources

- **Main README:** See `README.md` for project overview
- **Quick Start:** See `QUICKSTART.md` for 5-minute setup
- **Installation Details:** See `INSTALL.md` for detailed installation guide
- **Security Notes:** See `SECURITY_NOTES.md` for security considerations

---

**Happy Quantum Learning! 🎉**