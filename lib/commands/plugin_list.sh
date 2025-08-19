#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

log_info "Listing plugins from plugins.txt..."

if [ -s "$LIBRARIUM_ROOT/plugins.txt" ]; then
    # Use the more portable '-s' flag for the separator
    nl -s ': ' -w 3 -n rz "$LIBRARIUM_ROOT/plugins.txt"
else
    echo "No plugins are currently listed."
fi
