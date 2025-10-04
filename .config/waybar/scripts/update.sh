#!/bin/bash

echo "Updating Arch Linux system..."
sudo pacman -Syu --noconfirm
echo "Updating AUR packages..."
if command -v paru &>/dev/null; then
  paru -Syu --noconfirm
elif command -v yay &>/dev/null; then
  yay -Syu --noconfirm
else
  echo "Missing AUR Helper. Try installing yay or paru"
fi
if command -v flatpak &>/dev/null; then
  echo "Updating Flatpak packages..."
  flatpak update -y
fi
echo "Done with Arch & AUR updates."

echo "Press any key to exit..."
read -n 1
