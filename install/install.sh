#!/usr/bin/env bash
# A simple script to set up the core Librarium config.

# Exit if any command fails
set -e

# The directory where configs will be linked
FISH_CONFIG_DIR="$HOME/.config/fish"

# Create the target directory if it doesn't exist
mkdir -p "$FISH_CONFIG_DIR"

# Create the symbolic link
# "$(pwd)" ensures we use the full, absolute path to the repo
ln -s "$(pwd)/etc/config.fish" "$FISH_CONFIG_DIR/config.fish"

echo "Successfully linked config.fish."
echo "Please restart your shell."
