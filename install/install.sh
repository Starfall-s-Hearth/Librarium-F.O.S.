#!/usr/bin/env bash
# Librarium F.O.S. Installation Script

set -e

# --- Logging functions ---
BLUE='\033[34m'
GREEN='\033[32m'
RED='\033[31m'
RESET='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
log_error() { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }

# --- Variables ---
# Get the directory of this script, then find its parent (the project root).
# This is a robust method that works regardless of where the script is called from.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LIBRARIUM_ROOT=$( dirname -- "$SCRIPT_DIR" )

FISH_CONFIG_DIR="$HOME/.config/fish"
FISH_FUNCTIONS_DIR="$FISH_CONFIG_DIR/functions"
BIN_DIR="$PREFIX/bin"
PLUGIN_INSTALL_DIR="$FISH_CONFIG_DIR/librarium-plugins"

# --- Main Functions ---

install_system_packages() {
    log_info "Checking for system packages..."
    local package_file="$LIBRARIUM_ROOT/packages.txt"
    if [ ! -f "$package_file" ]; then
        log_info "-> No packages.txt found, skipping."
        return
    fi

    while IFS= read -r pkg_line || [[ -n "$pkg_line" ]]; do
        [[ -z "$pkg_line" || "$pkg_line" == \#* ]] && continue
        
        local pkg_name pkg_version
        read -r pkg_name pkg_version <<< "$pkg_line"

        if [[ -z "$pkg_version" ]]; then
            if ! pacman -Q "$pkg_name" &> /dev/null; then
                log_info "-> Installing latest '$pkg_name' with pacman..."
                pacman -Syu --noconfirm "$pkg_name"
            else
                log_info "-> Package '$pkg_name' is already installed."
            fi
        else
            if ! pacman -Q "$pkg_name" &> /dev/null; then
                log_info "-> Package '$pkg_name' not found. Installing specific version ($pkg_version)..."
                pacman -Syu --noconfirm "${pkg_name}=${pkg_version}"
            else
                local current_version=$(pacman -Q "$pkg_name" | cut -d' ' -f2)
                if [[ "$current_version" == "$pkg_version" ]]; then
                    log_info "-> Correct version of '$pkg_name' ($pkg_version) is installed."
                else
                    log_error "Version mismatch for '$pkg_name'. Expected '$pkg_version' but found '$current_version'."
                fi
            fi
        fi
    done < "$package_file"
}

install_plugins() {
    log_info "Processing plugins..."
    local plugin_file="$LIBRARIUM_ROOT/plugins.txt"
    local locks_dir="$LIBRARIUM_ROOT/var/plugin_lockfiles"
    local cache_dir="$HOME/.cache/librarium/plugins"
    
    if [ ! -f "$plugin_file" ]; then
        log_info "-> No plugins.txt found, skipping."
        return
    fi
    
    mkdir -p "$PLUGIN_INSTALL_DIR" "$locks_dir" "$cache_dir"
    declare -A processed_plugins

    declare -A desired_plugins
    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        desired_plugins[$(echo "$plugin" | tr '/' '-')]=""
    done < "$plugin_file"
    
    for installed_plugin_path in "$PLUGIN_INSTALL_DIR"/*; do
        if [ -d "$installed_plugin_path" ]; then
            local installed_plugin_name=$(basename "$installed_plugin_path")
            if [[ ! -v "desired_plugins[$installed_plugin_name]" ]]; then
                log_info "-> Pruning removed plugin: $installed_plugin_name"
                rm -rf "$installed_plugin_path"
            fi
        fi
    done

    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue
        if [[ -n "${processed_plugins[$plugin]}" ]]; then
            log_info "-> Skipping duplicate plugin: $plugin"
            continue
        fi
        processed_plugins[$plugin]=1
        log_info "-> Processing plugin: $plugin"

        local sanitized_name=$(echo "$plugin" | tr '/' '-')
        local lock_file="$locks_dir/$sanitized_name.lock"
        local commit_hash=""

        if [ -f "$lock_file" ]; then
            commit_hash=$(cat "$lock_file")
            log_info "  - Found lockfile. Version pinned to ${commit_hash:0:7}"
        else
            log_info "  - No lockfile found. Fetching latest version..."
            commit_hash=$(git ls-remote "https://github.com/$plugin.git" HEAD | cut -f1)
            if [ -z "$commit_hash" ]; then log_error "Could not fetch latest commit for $plugin."; fi
            echo "$commit_hash" > "$lock_file"
            log_info "  - Locked $plugin to version ${commit_hash:0:7}"
        fi

        local plugin_cache_path="$cache_dir/$sanitized_name/$commit_hash"
        if [ ! -d "$plugin_cache_path" ]; then
            log_info "  - Caching version ${commit_hash:0:7}..."
            local temp_clone_path=$(mktemp -d)
            git clone --quiet "https://github.com/$plugin.git" "$temp_clone_path"
            (cd "$temp_clone_path" && git checkout --quiet "$commit_hash")
            mv "$temp_clone_path" "$plugin_cache_path"
        else
            log_info "  - Using cached version ${commit_hash:0:7}"
        fi

        local install_path="$PLUGIN_INSTALL_DIR/$sanitized_name"
        rm -rf "$install_path"
        ln -s "$plugin_cache_path" "$install_path"
        log_info "  - Installed to $install_path"
    done < "$plugin_file"
}

generate_plugin_loader() {
    log_info "Generating plugin loader script..."
    local loader_file="$FISH_CONFIG_DIR/conf.d/100-librarium-plugins.fish"

    cat > "$loader_file" << 'EOF'
# This file is auto-generated by the Librarium F.O.S. installer.
# It loads all installed plugins. Do not edit manually.

for plugin_dir in $HOME/.config/fish/librarium-plugins/*
    if test -d "$plugin_dir"
        for fish_file in "$plugin_dir"/*.fish
            if test -f "$fish_file"
                source "$fish_file"
            end
        end
    end
end
EOF
    log_info "-> Created plugin loader at $loader_file"
}

main() {
    log_info "Starting Librarium F.O.S. setup..."

    log_info "Checking for dependencies..."
    for cmd in git fish; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "'$cmd' is not installed. Please run 'pacman -Syu $cmd' and try again."
        fi
    done

    install_system_packages

    if [ -e "$FISH_CONFIG_DIR" ]; then
        BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date "+%Y%m%d%H%M%S")"
        log_info "Found existing config. Backing it up to $BACKUP_DIR"
        mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
    fi

    mkdir -p "$FISH_CONFIG_DIR/conf.d" "$FISH_FUNCTIONS_DIR" "$BIN_DIR"

    log_info "Linking configuration files..."
    for file in "$LIBRARIUM_ROOT"/etc/*; do
        if [ -f "$file" ]; then
            ln -s "$file" "$FISH_CONFIG_DIR/$(basename "$file")"
            log_info "-> Linked $(basename "$file")"
        fi
    done

    log_info "Linking executable scripts..."
    for file in "$LIBRARIUM_ROOT"/bin/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            chmod +x "$file"
            rm -f "$BIN_DIR/$filename"
            ln -s "$file" "$BIN_DIR/$filename"
            log_info "-> Linked $filename"
        fi
    done

    log_info "Linking autoloadable functions..."
    for file in "$LIBRARIUM_ROOT"/lib/functions/*.fish; do
        if [ -f "$file" ]; then
            ln -s "$file" "$FISH_FUNCTIONS_DIR/$(basename "$file")"
            log_info "-> Linked $(basename "$file")"
        fi
    done

    CONF_D_FILE="$FISH_CONFIG_DIR/conf.d/000-librarium-root.fish"
    echo "set -gx LIBRARIUM_ROOT '$LIBRARIUM_ROOT'" > "$CONF_D_FILE"
    log_info "Wrote LIBRARIUM_ROOT path to $CONF_D_FILE"

    install_plugins
    generate_plugin_loader

    log_success "Setup complete! Please restart your shell."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
