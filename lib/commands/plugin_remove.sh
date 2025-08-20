#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

PLUGIN_NAME="$1"
PLUGIN_FILE="$LIBRARIUM_ROOT/plugins.txt"

if [ -z "$PLUGIN_NAME" ]; then
    log_error "No plugin name provided. Usage: ... plugin remove <user/repo>"
fi

if ! grep -qFx -- "$PLUGIN_NAME" "$PLUGIN_FILE"; then
    log_error "Plugin '$PLUGIN_NAME' not found in plugins.txt."
fi

log_info "Removing '$PLUGIN_NAME' from plugins.txt..."
grep -vFx -- "$PLUGIN_NAME" "$PLUGIN_FILE" > "$PLUGIN_FILE.tmp" && mv "$PLUGIN_FILE.tmp" "$PLUGIN_FILE"
log_success "Plugin removed. Run 'side-apply' to apply changes."
