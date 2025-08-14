#!/usr/bin/env bash
# A simple script to set up the core Librarium config.

# Exit if any command fails
set -e

FISH_CONFIG_DIR="$HOME/.config/fish"
# This is the standard Termux location for user commands
BIN_DIR="$PREFIX/bin" 

# Backup existing configuration
if [ -e "$FISH_CONFIG_DIR" ]; then
    BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Found existing configuration. Backing it up to:"
    echo "  $BACKUP_DIR"
    mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
fi

# Create the target directories if they don't exist
mkdir -p "$FISH_CONFIG_DIR"
mkdir -p "$BIN_DIR"

# Link configuration files
echo "Linking configuration files..."
for file in "$(pwd)"/etc/*; do
    filename=$(basename "$file")
    ln -s "$file" "$FISH_CONFIG_DIR/$filename"
    echo "-> Linked $filename"
done

# --- NEW: Link executable scripts from 'bin' directory ---
echo "Linking executable scripts..."
for file in "$(pwd)"/bin/*; do
    filename=$(basename "$file")
    
    # First, ensure the script is executable
    chmod +x "$file"

    # Now, create the symbolic link
    ln -s "$file" "$BIN_DIR/$filename"
    echo "-> Linked $filename"
done
# --- END NEW ---

echo "Successfully linked all configs and scripts."
echo "Please restart your shell."
