#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

THEMES_DIR="$LIBRARIUM_ROOT/share/themes"

log_info "Available themes:"
for theme in "$THEMES_DIR"/*.properties; do
    if [ -f "$theme" ]; then
        echo "  - $(basename "$theme" .properties)"
    fi
done
