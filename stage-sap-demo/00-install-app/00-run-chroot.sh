#!/bin/bash -e
# Stage: Install Node.js, serve, enable systemd service
# Runs INSIDE the chroot

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install serve globally
npm install -g serve

# Fix ownership of app files
chown -R rasqberry:rasqberry /home/rasqberry/rasqberry-sap-demo
chown -R rasqberry:rasqberry /home/rasqberry/Desktop
chown -R rasqberry:rasqberry /home/rasqberry/.local

# Enable the systemd service
systemctl enable sap-quantum-app.service

# Enable SSH
systemctl enable ssh
