#!/usr/bin/env bash
#
# Librarium F.O.S. Theme Manager

# Use the LIBRARIUM_ROOT variable set by your shell environment
# to find the themes directory within the project structure.
THEMES_DIR="$LIBRARIUM_ROOT/share/themes"
TERMUX_CONFIG_DIR="$HOME/.termux"
TARGET_FILE="$TERMUX_CONFIG_DIR/colors.properties"

# Ensure the .termux directory exists
mkdir -p "$TERMUX_CONFIG_DIR"

# Handle the 'list' subcommand
if [ "$1" = "list" ]; then
    echo "Available themes:"
    for theme in "$THEMES_DIR"/*.properties; do
        if [ -f "$theme" ]; then
            echo "  - $(basename "$theme" .properties)"
        fi
    done
    exit 0
fi

# Handle incorrect usage
if [ -z "$1" ]; then
    echo "Usage: theme <theme_name> | list"
    exit 1
fi

THEME_NAME="$1"
SOURCE_FILE="$THEMES_DIR/$THEME_NAME.properties"

# Check if the requested theme file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Theme '$THEME_NAME' not found in '$THEMES_DIR'"
    exit 1
fi

echo "Setting theme to '$THEME_NAME'..."
cp "$SOURCE_FILE" "$TARGET_FILE"
termux-reload-settings

echo "Theme updated successfully."
