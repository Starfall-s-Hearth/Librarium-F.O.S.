#!/usr/bin/env bash
# A simple script to set up the core Librarium config.

# Exit if any command fails
set -e

FISH_CONFIG_DIR="$HOME/.config/fish"

# --- NEW: Backup existing configuration ---
if [ -e "$FISH_CONFIG_DIR" ]; then
    BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Found existing configuration. Backing it up to:"
    echo "  $BACKUP_DIR"
    mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
fi
# --- END NEW ---

# Create the target directory
mkdir -p "$FISH_CONFIG_DIR"

# Create the symbolic link
ln -s "$(pwd)/etc/config.fish" "$FISH_CONFIG_DIR/config.fish"

echo "Successfully linked config.fish."
echo "Please restart your shell."


