#!/usr/bin/env bash
#
# Librarium S.I.D.E. - Main CLI Tool (Router)

set -e

if [ -z "$LIBRARIUM_ROOT" ]; then
    echo "ERROR: LIBRARIUM_ROOT is not set." >&2
    exit 1
fi

# Source the installer script to get its functions, like main() and log_*
source "$LIBRARIUM_ROOT/install/install.sh"

# --- HELPER FUNCTIONS ---
show_main_help() {
    echo "Librarium S.I.D.E. Management Interface"
    echo ""
    echo "Usage: side <command> [subcommand] [args...]"
    echo ""
    echo "Available commands:"
    echo "  apply     - Applies all configurations by running the installer."
    echo "  plugin    - Manage shell extensions."
    echo "  theme     - Manage terminal themes."
    echo "  status    - Display a diagnostic summary of the environment."
    echo "  help      - Show help for a command."
}

show_plugin_help() {
    echo "Usage: side plugin <subcommand>"
    echo "Aliases: p-list, p-add, p-remove, p-update, p-compile"
    echo ""
    echo "Available subcommands:"
    echo "  list              - List the plugins in your plugins.txt file."
    echo "  add <user/repo>   - Add a new plugin."
    echo "  remove <user/repo>- Remove an existing plugin."
    echo "  update [user/repo] [--apply] - Update lockfiles and optionally apply changes."
    echo "  compile           - Compile plugins into optimized packs."
}

show_theme_help() {
    echo "Usage: side theme <subcommand>"
    echo "Aliases: t-list, t-set"
    echo ""
    echo "Available subcommands:"
    echo "  list              - List available themes."
    echo "  set <theme_name>  - Apply a theme."
}

# --- COMMAND ROUTING ---
COMMAND="$1"
SUBCOMMAND="$2"
ARGUMENT="$3"

case "$COMMAND" in
    apply)
        main
        ;;
    status)
        exec "$LIBRARIUM_ROOT/lib/commands/status.sh"
        ;;
    plugin | theme)
        # REMOVED 'local' from the next line
        SUBCOMMAND_SCRIPT_PATH="$LIBRARIUM_ROOT/lib/commands/${COMMAND}_${SUBCOMMAND}.sh"
        if [ -f "$SUBCOMMAND_SCRIPT_PATH" ]; then
            exec "$SUBCOMMAND_SCRIPT_PATH" "${@:3}"
        else
            case "$SUBCOMMAND" in
                "" | "-h" | "--help")
                    "show_${COMMAND}_help"
                    ;;
                *)
                    log_error "Unknown subcommand '$SUBCOMMAND' for '$COMMAND'."
                    "show_${COMMAND}_help"
                    exit 1
                    ;;
            esac
        fi
        ;;
    help)
        case "$SUBCOMMAND" in
            plugin) show_plugin_help ;;
            theme) show_theme_help ;;
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
