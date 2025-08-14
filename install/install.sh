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
FISH_CONFIG_DIR="$HOME/.config/fish"
BIN_DIR="$PREFIX/bin" 

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

# We now create conf.d as well
mkdir -p "$FISH_CONFIG_DIR/conf.d"
mkdir -p "$BIN_DIR"

# Link configuration files from etc/
log_info "Linking configuration files..."
for file in "$(pwd)"/etc/*; do
    ln -s "$file" "$FISH_CONFIG_DIR/$(basename "$file")"
    log_info "-> Linked $(basename "$file")"
done

# Link executable scripts from bin/
log_info "Linking executable scripts..."
for file in "$(pwd)"/bin/*; do
    filename=$(basename "$file")
    chmod +x "$file"
    rm -f "$BIN_DIR/$filename"
    ln -s "$file" "$BIN_DIR/$filename"
    log_info "-> Linked $filename"
done

# --- CORRECTED PATH DEFINITION ---
# Place the path file in conf.d so Fish loads it automatically.
# Naming it 000- ensures it loads first.
CONF_D_FILE="$FISH_CONFIG_DIR/conf.d/000-librarium-root.fish"
echo "set -gx LIBRARIUM_ROOT '$(pwd)'" > "$CONF_D_FILE"
log_info "Wrote LIBRARIUM_ROOT path to $CONF_D_FILE"


log_success "Setup complete! Please restart your shell."
