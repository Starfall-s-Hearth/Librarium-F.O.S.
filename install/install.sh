#!/usr/bin/env bash
# Librarium F.O.S. Installation Script

# Exit if any command fails
set -e

# --- Logging functions ---
BLUE='\033[34m'
GREEN='\033[32m'
RED='\033[31m' # New color for errors
RESET='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

# --- NEW: Error logging function ---
log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
    # Exit with a non-zero status code to indicate failure
    exit 1
}
# --- END NEW ---

# --- Variables ---
FISH_CONFIG_DIR="$HOME/.config/fish"
BIN_DIR="$PREFIX/bin" 

# --- Main Logic ---
log_info "Starting Librarium F.O.S. setup..."

# --- NEW: Dependency Check ---
log_info "Checking for dependencies..."
for cmd in git fish; do
    if ! command -v "$cmd" &> /dev/null; then
        log_error "'$cmd' is not installed. Please run 'pacman -Syu $cmd' and try again."
    fi
done
# --- END NEW ---

# Backup existing configuration
if [ -e "$FISH_CONFIG_DIR" ]; then
    BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    log_info "Found existing config. Backing it up to $BACKUP_DIR"
    mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
fi

# Create the target directories
mkdir -p "$FISH_CONFIG_DIR"
mkdir -p "$BIN_DIR"

# Link configuration files
log_info "Linking configuration files..."
for file in "$(pwd)"/etc/*; do
    filename=$(basename "$file")
    ln -s "$file" "$FISH_CONFIG_DIR/$filename"
    log_info "-> Linked $filename"
done

# Link executable scripts
log_info "Linking executable scripts..."
for file in "$(pwd)"/bin/*; do
    filename=$(basename "$file")
    chmod +x "$file"
    ln -s "$file" "$BIN_DIR/$filename"
    log_info "-> Linked $filename"
done

log_success "Setup complete! Please restart your shell."
