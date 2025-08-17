#!/usr/bin/env bash
#
# Librarium F.O.S. - Main CLI Tool (Router)

set -e

if [ -z "$LIBRARIUM_ROOT" ]; then
    echo "ERROR: LIBRARIUM_ROOT is not set."
    exit 1
fi

# NOTE: The 'source' line has been removed from here.

# --- Main Logic ---
COMMAND="$1"
SUBCOMMAND="$2"

SUBCOMMAND_SCRIPT_PATH="$LIBRARIUM_ROOT/lib/commands/${COMMAND}_${SUBCOMMAND}.sh"

if [ -f "$SUBCOMMAND_SCRIPT_PATH" ]; then
    exec "$SUBCOMMAND_SCRIPT_PATH" "${@:3}"
else
    # We can't use log_error here anymore, so we use a standard echo.
    echo "ERROR: Unknown command: '$COMMAND $SUBCOMMAND'" >&2
    echo "Usage: librarium_interface <command> <subcommand> [args...]"
    exit 1
fi
