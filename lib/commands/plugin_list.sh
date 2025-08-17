#!/usr/bin/env bash
#
# Subcommand to list plugins.

# Source the main installer to get access to logging functions and variables
source "$LIBRARIUM_ROOT/install/install.sh"

log_info "Listing plugins from plugins.txt..."

if [ -s "$LIBRARIUM_ROOT/plugins.txt" ]; then
    nl --body-numbering=t --separator=': ' "$LIBRARIUM_ROOT/plugins.txt"
else
    echo "No plugins are currently listed."
fi
