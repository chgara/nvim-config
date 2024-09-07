#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

if command -v pacman &> /dev/null; then
  pacman -S --noconfirm neovim xclip base-devel
elif command -v apt-get &> /dev/null; then
  apt-get update && apt-get install -y neovim xclip build-essential
else
  echo "Unsupported package manager. Please install neovim, xclip, and build-essential manually."
  exit 1
fi

CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim_backup"

if [ -d "$CONFIG_DIR" ]; then
  rm -rf "$BACKUP_DIR"
  mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

git clone https://github.com/chgara/nvim-config "$CONFIG_DIR"
