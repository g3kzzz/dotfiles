#!/bin/bash
# ===============================================
#   Arch Linux VMware Fullscreen Setup Script
# ===============================================

set -e

echo "[+] Updating system..."
sudo pacman -Syu --noconfirm

echo "[+] Installing VMware tools..."
sudo pacman -S --noconfirm open-vm-tools xf86-video-vmware

echo "[+] Enabling VMware services..."
sudo systemctl enable --now vmtoolsd
sudo systemctl enable --now vgauthd

echo "[+] Creating Xorg config for VMware..."
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo tee /etc/X11/xorg.conf.d/10-vmware.conf > /dev/null <<EOF
Section "Device"
    Identifier  "VMware SVGA"
    Driver      "vmware"
EndSection
EOF

echo "[+] Reloading X server (may log you out)..."
if command -v systemctl &> /dev/null && systemctl is-active display-manager &> /dev/null; then
    sudo systemctl restart display-manager
else
    echo "[!] Please log out and log back in to apply changes."
fi

echo "[+] Configuration complete! You should now be able to use fullscreen (Ctrl+Alt+Enter in VMware)."
