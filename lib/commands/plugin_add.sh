#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

PLUGIN_NAME="$1"
PLUGIN_FILE="$LIBRARIUM_ROOT/plugins.txt"

if [ -z "$PLUGIN_NAME" ]; then
    log_error "No plugin name provided. Usage: ... plugin add <user/repo>"
fi

# Ensure the plugin file exists before reading it
touch "$PLUGIN_FILE"

if grep -qFx -- "$PLUGIN_NAME" "$PLUGIN_FILE"; then
    log_error "Plugin '$PLUGIN_NAME' already exists in plugins.txt."
fi

log_info "Adding '$PLUGIN_NAME' to plugins.txt..."
echo "$PLUGIN_NAME" >> "$PLUGIN_FILE"
log_success "Plugin added. Run 'side-apply' to install."
