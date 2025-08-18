#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

THEME_NAME="$1"
THEMES_DIR="$LIBRARIUM_ROOT/share/themes"
TERMUX_CONFIG_DIR="$HOME/.termux"
TARGET_FILE="$TERMUX_CONFIG_DIR/colors.properties"

if [ -z "$THEME_NAME" ]; then
    log_error "No theme name provided. Usage: side theme set <theme_name>"
fi

SOURCE_FILE="$THEMES_DIR/$THEME_NAME.properties"

if [ ! -f "$SOURCE_FILE" ]; then
    log_error "Theme '$THEME_NAME' not found in '$THEMES_DIR'"
fi

log_info "Setting theme to '$THEME_NAME'..."
mkdir -p "$TERMUX_CONFIG_DIR"
cp "$SOURCE_FILE" "$TARGET_FILE"
termux-reload-settings

log_success "Theme updated successfully."
