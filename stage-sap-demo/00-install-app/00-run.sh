#!/bin/bash -e
# Stage: Install SAP Quantum Learning App
# Runs OUTSIDE the chroot (on the build host)

# Copy the pre-built app into the image rootfs
install -d "${ROOTFS_DIR}/home/rasqberry/rasqberry-sap-demo"
cp -r "${STAGE_DIR}/00-install-app/files/build"   "${ROOTFS_DIR}/home/rasqberry/rasqberry-sap-demo/build"
cp    "${STAGE_DIR}/00-install-app/files/app-icon.png" "${ROOTFS_DIR}/home/rasqberry/rasqberry-sap-demo/app-icon.png"

# Create the server-wait launcher script
cat > "${ROOTFS_DIR}/home/rasqberry/rasqberry-sap-demo/launch.sh" << 'LAUNCH'
#!/bin/bash
# Wait up to 30 s for the serve process to be ready before opening Chromium
for i in $(seq 1 30); do
    curl -s http://localhost:3000 > /dev/null 2>&1 && break
    sleep 1
done
exec chromium-browser --app=http://localhost:3000 --no-sandbox
LAUNCH
chmod +x "${ROOTFS_DIR}/home/rasqberry/rasqberry-sap-demo/launch.sh"

# Desktop shortcut
install -d "${ROOTFS_DIR}/home/rasqberry/Desktop"
cat > "${ROOTFS_DIR}/home/rasqberry/Desktop/SAP Quantum Learning.desktop" << 'DESKTOP'
[Desktop Entry]
Version=1.0
Type=Application
Name=SAP Quantum Learning
Comment=Interactive Quantum Computing Learning Application
Exec=/home/rasqberry/rasqberry-sap-demo/launch.sh
Icon=/home/rasqberry/rasqberry-sap-demo/app-icon.png
Terminal=false
Categories=Education;Science;
StartupNotify=true
DESKTOP
chmod +x "${ROOTFS_DIR}/home/rasqberry/Desktop/SAP Quantum Learning.desktop"

install -d "${ROOTFS_DIR}/home/rasqberry/.local/share/applications"
cp "${ROOTFS_DIR}/home/rasqberry/Desktop/SAP Quantum Learning.desktop" \
   "${ROOTFS_DIR}/home/rasqberry/.local/share/applications/"

# systemd service unit
cat > "${ROOTFS_DIR}/etc/systemd/system/sap-quantum-app.service" << 'SERVICE'
[Unit]
Description=SAP Quantum Learning App
After=network.target

[Service]
Type=simple
User=rasqberry
WorkingDirectory=/home/rasqberry/rasqberry-sap-demo
Environment=PATH=/usr/local/bin:/usr/bin:/bin
ExecStart=/usr/local/bin/serve -s build -l 3000
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
SERVICE
