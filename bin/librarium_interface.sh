#!/usr/bin/env bash
#
# Librarium F.O.S. - Main CLI Tool

set -e

# Ensure we have access to LIBRARIUM_ROOT
if [ -z "$LIBRARIUM_ROOT" ]; then
    echo "ERROR: LIBRARIUM_ROOT is not set. Please ensure your shell is configured correctly."
    exit 1
fi

# Source the installer script to get access to its logging functions
source "$LIBRARIUM_ROOT/install/install.sh"

# --- HELPER FUNCTIONS ---
show_main_help() {
    echo "Librarium F.O.S. Management Interface"
    echo ""
    echo "Usage: librarium_interface <command> [subcommand] [args...]"
    echo ""
    echo "Available commands:"
    echo "  plugin    - Manage shell plugins."
    echo "  help      - Show help for a command."
}

show_plugin_help() {
    echo "Usage: librarium_interface plugin <subcommand>"
    echo ""
    echo "Available subcommands:"
    echo "  list              - List the plugins in your plugins.txt file."
    echo "  add <user/repo>   - Add a new plugin to plugins.txt."
    echo "  remove <user/repo>- Remove a plugin from plugins.txt."
    echo "  update            - Update all plugin lockfiles to their latest versions."
}

# --- COMMAND ROUTING ---
COMMAND="$1"
SUBCOMMAND="$2"
ARGUMENT="$3"
PLUGIN_FILE="$LIBRARIUM_ROOT/plugins.txt"

case "$COMMAND" in
    plugin)
        case "$SUBCOMMAND" in
            list)
                log_info "Listing plugins from plugins.txt..."
                if [ -s "$PLUGIN_FILE" ]; then
                    nl --body-numbering=t --separator=': ' "$PLUGIN_FILE"
                else
                    echo "No plugins are currently listed."
                fi
                ;;
            add)
                if [ -z "$ARGUMENT" ]; then log_error "No plugin name provided. Usage: ... plugin add <user/repo>"; fi
                if grep -qFx -- "$ARGUMENT" "$PLUGIN_FILE"; then log_error "Plugin '$ARGUMENT' already exists."; fi
                log_info "Adding '$ARGUMENT' to plugins.txt..."
                echo "$ARGUMENT" >> "$PLUGIN_FILE"
                log_success "Plugin added. Run 'update-fos' to install."
                ;;
            remove)
                if [ -z "$ARGUMENT" ]; then log_error "No plugin name provided. Usage: ... plugin remove <user/repo>"; fi
                if ! grep -qFx -- "$ARGUMENT" "$PLUGIN_FILE"; then log_error "Plugin '$ARGUMENT' not found."; fi
                log_info "Removing '$ARGUMENT' from plugins.txt..."
                grep -vFx -- "$ARGUMENT" "$PLUGIN_FILE" > "$PLUGIN_FILE.tmp" && mv "$PLUGIN_FILE.tmp" "$PLUGIN_FILE"
                log_success "Plugin removed. Run 'update-fos' to apply changes."
                ;;
            update)
                local locks_dir="$LIBRARIUM_ROOT/var/plugin_lockfiles"
                log_info "Checking for plugin updates..."
                while IFS= read -r plugin || [[ -n "$plugin" ]]; do
                    [[ -z "$plugin" || "$plugin" == \#* ]] && continue
                    log_info "-> Checking $plugin..."
                    local sanitized_name=$(echo "$plugin" | tr '/' '-')
                    local lock_file="$locks_dir/$sanitized_name.lock"
                    local latest_hash=$(git ls-remote "https://github.com/$plugin.git" HEAD | cut -f1)
                    if [ -z "$latest_hash" ]; then log_error "Could not fetch latest commit for $plugin."; fi
                    echo "$latest_hash" > "$lock_file"
                    log_info "  - Locked $plugin to latest version: ${latest_hash:0:7}"
                done < "$PLUGIN_FILE"
                log_success "All plugin lockfiles updated. Run 'update-fos' to apply changes."
                ;;
            "" | "-h" | "--help")
                show_plugin_help
                ;;
            *)
                log_error "Unknown plugin command: '$SUBCOMMAND'"
                show_plugin_help
                exit 1
                ;;
        esac
        ;;
    help)
        case "$SUBCOMMAND" in
            plugin) show_plugin_help ;;
            *) show_main_help ;;
        esac
        ;;
    "" | "-h" | "--help")
        show_main_help
        ;;
    *)
        log_error "Unknown command: '$COMMAND'"
        show_main_help
        exit 1
        ;;
esac
