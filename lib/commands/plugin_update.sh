#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

PLUGIN_FILE="$LIBRARIUM_ROOT/plugins.txt"
LOCKS_DIR="$LIBRARIUM_ROOT/var/plugin_lockfiles"
PLUGIN_TO_UPDATE=""
APPLY_CHANGES=false

# --- Argument Parsing ---
for arg in "$@"; do
    if [[ "$arg" == "--apply" ]]; then
        APPLY_CHANGES=true
    else
        # Assume any other argument is the plugin name
        PLUGIN_TO_UPDATE="$arg"
    fi
done

# --- Helper Function ---
update_single_plugin() {
    local plugin=$1
    log_info "-> Checking $plugin..."
    if ! grep -qFx -- "$plugin" "$PLUGIN_FILE"; then log_error "Plugin '$plugin' is not in plugins.txt."; fi
    
    local sanitized_name=$(echo "$plugin" | tr '/' '-')
    local lock_file="$LOCKS_DIR/$sanitized_name.lock"
    local latest_hash=$(git ls-remote "https://github.com/$plugin.git" HEAD | cut -f1)

    if [ -z "$latest_hash" ]; then log_error "Could not fetch commit for $plugin."; fi
    
    echo "$latest_hash" > "$lock_file"
    log_info "  - Locked $plugin to latest version: ${latest_hash:0:7}"
}

# --- Main Logic ---
if [ -n "$PLUGIN_TO_UPDATE" ]; then
    log_info "Updating a single plugin..."
    update_single_plugin "$PLUGIN_TO_UPDATE"
else
    log_info "Checking for all plugin updates..."
    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        update_single_plugin "$plugin"
    done < "$PLUGIN_FILE"
fi

log_success "Plugin lockfiles updated."

# --- Apply Changes if Flag is Present ---
if [[ "$APPLY_CHANGES" == "true" ]]; then
    log_info "Applying changes..."
    "$LIBRARIUM_ROOT/bin/side_interface.sh" apply
else
    log_info "Run 'side-apply' to apply changes."
fi
