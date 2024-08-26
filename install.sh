#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

pacman -S --noconfirm neovim xclip

CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim_backup"

if [ -d "$CONFIG_DIR" ]; then
  rm -rf "$BACKUP_DIR"
  mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

git clone https://github.com/chgara/nvim-config "$CONFIG_DIR"
