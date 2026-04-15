#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi

echo "Retrieving primary key..."
pacman-key --recv-key 7E44EFACDAFCB870DF9A243F05E4F10D5DF66AEE --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 7E44EFACDAFCB870DF9A243F05E4F10D5DF66AEE

echo "Installing nyarch-keyring..."
pacman -U --noconfirm 'https://de-pkgmirror.nyarchlinux.moe/x86_64/repo/nyarch-keyring.pkg.tar.zst'

echo "Installing nyarch-mirrorlist..."
pacman -U --noconfirm 'https://de-pkgmirror.nyarchlinux.moe/x86_64/repo/nyarch-mirrorlist.pkg.tar.zst'

echo "Configuring pacman.conf..."
# Check if nyarch is already in pacman.conf
if grep -q "^\[nyarch-repo\]" /etc/pacman.conf; then
    echo "The [nyarch-repo] repository is already present in /etc/pacman.conf. Skipping append."
else
    echo "Adding [nyarch-repo] repository to /etc/pacman.conf..."
    cat >> /etc/pacman.conf <<EOF

[nyarch-repo]
Include = /etc/pacman.d/nyarch-mirrorlist
EOF
fi

echo "Running full system update..."
pacman -Syu --noconfirm

echo "Done!"
