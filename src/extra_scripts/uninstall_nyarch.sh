#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

echo "Removing [nyarch-repo] from /etc/pacman.conf..."
sed -i '/^\[nyarch-repo\]/d' /etc/pacman.conf
sed -i '\|^Include = /etc/pacman.d/nyarch-mirrorlist|d' /etc/pacman.conf

echo "Uninstalling nyarch-keyring and nyarch-mirrorlist..."
if pacman -Qs nyarch-mirrorlist > /dev/null; then
    pacman -Rns --noconfirm nyarch-keyring nyarch-mirrorlist
else
    echo "Packages already removed or not installed."
fi

echo "Removing the repository key from pacman keyring..."
pacman-key --delete 05E4F10D5DF66AEE 2>/dev/null || echo "Key not found or already removed."

echo "Updating pacman databases..."
pacman -Sy

echo "Uninstallation complete!"
