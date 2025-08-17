#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

PLUGIN_FILE="$LIBRARIUM_ROOT/plugins.txt"
LOCKS_DIR="$LIBRARIUM_ROOT/var/plugin_lockfiles"
PLUGIN_TO_UPDATE="$1"

update_single_plugin() {
    local plugin=$1
    log_info "-> Checking $plugin..."
    
    # Check that the requested plugin is actually in plugins.txt
    if ! grep -qFx -- "$plugin" "$PLUGIN_FILE"; then
        log_error "Plugin '$plugin' is not listed in your plugins.txt file."
    fi

    local sanitized_name=$(echo "$plugin" | tr '/' '-')
    local lock_file="$LOCKS_DIR/$sanitized_name.lock"
    local latest_hash=$(git ls-remote "https://github.com/$plugin.git" HEAD | cut -f1)

    if [ -z "$latest_hash" ]; then
        log_error "Could not fetch latest commit for $plugin."
    fi

    echo "$latest_hash" > "$lock_file"
    log_info "  - Locked $plugin to latest version: ${latest_hash:0:7}"
}

if [ -n "$PLUGIN_TO_UPDATE" ]; then
    # --- UPDATE A SINGLE PLUGIN ---
    log_info "Updating a single plugin..."
    update_single_plugin "$PLUGIN_TO_UPDATE"
else
    # --- UPDATE ALL PLUGINS ---
    log_info "Checking for all plugin updates..."
    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        update_single_plugin "$plugin"
    done < "$PLUGIN_FILE"
fi

log_success "Plugin lockfiles updated. Run 'update-fos' to apply changes."
