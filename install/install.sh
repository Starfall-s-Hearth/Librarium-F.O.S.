#!/usr/bin/env bash
# A simple script to set up the core Librarium config.

# Exit if any command fails
set -e

FISH_CONFIG_DIR="$HOME/.config/fish"

# Backup existing configuration
if [ -e "$FISH_CONFIG_DIR" ]; then
    BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Found existing configuration. Backing it up to:"
    echo "  $BACKUP_DIR"
    mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
fi

# Create the target directory
mkdir -p "$FISH_CONFIG_DIR"

# --- NEW: Loop through all files in 'etc' and link them ---
echo "Linking configuration files..."
for file in "$(pwd)"/etc/*; do
    # Get just the filename from the full path
    filename=$(basename "$file")
    
    # Create the symbolic link in the fish config directory
    ln -s "$file" "$FISH_CONFIG_DIR/$filename"
    echo "-> Linked $filename"
done
# --- END NEW ---

echo "Successfully linked all configs."
echo "Please restart your shell."

