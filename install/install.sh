#!/usr/bin/env bash
# Librarium F.O.S. Installation Script

# Exit if any command fails
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
LIBRARIUM_ROOT="$(pwd)"
FISH_CONFIG_DIR="$HOME/.config/fish"
FISH_FUNCTIONS_DIR="$FISH_CONFIG_DIR/functions"
BIN_DIR="$PREFIX/bin"
PLUGIN_INSTALL_DIR="$FISH_CONFIG_DIR/librarium-plugins"

# --- Plugin Management Function ---
install_plugins() {
    log_info "Processing plugins..."
    local plugin_file="$LIBRARIUM_ROOT/plugins.txt"
    local locks_dir="$LIBRARIUM_ROOT/var/plugin_lockfiles"
    
    if [ ! -f "$plugin_file" ]; then
        log_info "-> No plugins.txt found, skipping."
        return
    fi
    
    mkdir -p "$PLUGIN_INSTALL_DIR"
    mkdir -p "$locks_dir"

    # Used to track and skip duplicate plugins in a single run
    declare -A processed_plugins

    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
        [[ -z "$plugin" || "$plugin" == \#* ]] && continue

        # Duplicate check
        if [[ -n "${processed_plugins[$plugin]}" ]]; then
            log_info "-> Skipping duplicate plugin: $plugin"
            continue
        fi
        processed_plugins[$plugin]=1
        
        log_info "-> Processing plugin: $plugin"

        # Per-plugin lockfile logic
        local sanitized_name=$(echo "$plugin" | tr '/' '-')
        local lock_file="$locks_dir/$sanitized_name.lock"
        local commit_hash=""

        if [ -f "$lock_file" ]; then
            commit_hash=$(cat "$lock_file")
            log_info "  - Found lockfile. Version pinned to $commit_hash"
        else
            log_info "  - No lockfile found. Fetching latest version from GitHub..."
            commit_hash=$(git ls-remote "https://github.com/$plugin.git" HEAD | cut -f1)
            
            if [ -z "$commit_hash" ]; then
                log_error "Could not fetch latest commit for $plugin. Please check the repository name."
            fi
            
            echo "$commit_hash" > "$lock_file"
            log_info "  - Locked $plugin to version $commit_hash"
        fi

        # TODO: Add logic for cache and installation using the commit_hash
    done < "$plugin_file"
}

# --- Main Logic ---
log_info "Starting Librarium F.O.S. setup..."

# Dependency Check
log_info "Checking for dependencies..."
for cmd in git fish; do
    if ! command -v "$cmd" &> /dev/null; then
        log_error "'$cmd' is not installed. Please run 'pacman -Syu $cmd' and try again."
    fi
done

# Backup existing configuration
if [ -e "$FISH_CONFIG_DIR" ]; then
    BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    log_info "Found existing config. Backing it up to $BACKUP_DIR"
    mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
fi

# Create all target directories
mkdir -p "$FISH_CONFIG_DIR/conf.d"
mkdir -p "$FISH_FUNCTIONS_DIR"
mkdir -p "$BIN_DIR"

# Link configuration files from etc/
log_info "Linking configuration files..."
for file in "$LIBRARIUM_ROOT"/etc/*; do
    if [ -f "$file" ]; then
        ln -s "$file" "$FISH_CONFIG_DIR/$(basename "$file")"
        log_info "-> Linked $(basename "$file")"
    fi
done

# Link executable scripts from bin/
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

# Link autoloadable functions from lib/functions
log_info "Linking autoloadable functions..."
for file in "$LIBRARIUM_ROOT"/lib/functions/*.fish; do
    if [ -f "$file" ]; then
        ln -s "$file" "$FISH_FUNCTIONS_DIR/$(basename "$file")"
        log_info "-> Linked $(basename "$file")"
    fi
done

# Set the LIBRARIUM_ROOT path for the shell to use
CONF_D_FILE="$FISH_CONFIG_DIR/conf.d/000-librarium-root.fish"
echo "set -gx LIBRARIUM_ROOT '$LIBRARIUM_ROOT'" > "$CONF_D_FILE"
log_info "Wrote LIBRARIUM_ROOT path to $CONF_D_FILE"

# Install plugins
install_plugins

log_success "Setup complete! Please restart your shell."
