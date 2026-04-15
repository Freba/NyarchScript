#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

echo "Removing [chaotic-aur] from /etc/pacman.conf..."
# Removes the repository header and the specific Include line
sed -i '/^\[chaotic-aur\]/d' /etc/pacman.conf
sed -i '|^Include = /etc/pacman.d/chaotic-mirrorlist|d' /etc/pacman.conf

echo "Uninstalling chaotic-keyring and chaotic-mirrorlist..."
# Remove the packages if they exist
if pacman -Qs chaotic-mirrorlist > /dev/null; then
    pacman -Rns --noconfirm chaotic-keyring chaotic-mirrorlist
else
    echo "Packages already removed or not installed."
fi

echo "Removing the repository key from pacman keyring..."
pacman-key --delete 3056513887B78AEB 2>/dev/null || echo "Key not found or already removed."

echo "Updating pacman databases..."
pacman -Sy

echo "Uninstallation complete!"
