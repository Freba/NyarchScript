#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

echo "Retrieving primary key..."
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

echo "Installing chaotic-keyring..."
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'

echo "Installing chaotic-mirrorlist..."
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

echo "Configuring pacman.conf..."
# Check if chaotic-aur is already in pacman.conf
if grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
    echo "The [chaotic-aur] repository is already present in /etc/pacman.conf. Skipping append."
else
    echo "Adding [chaotic-aur] repository to /etc/pacman.conf..."
    cat >> /etc/pacman.conf <<EOF

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
fi

echo "Running full system update..."
pacman -Syu --noconfirm

echo "Done!"
