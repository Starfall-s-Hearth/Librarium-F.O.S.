#!/usr/bin/env bash
source "$LIBRARIUM_ROOT/install/install.sh"

log_info "Librarium S.I.D.E. Status"
echo "---------------------------------"

# Check 1: LIBRARIUM_ROOT
if [ -n "$LIBRARIUM_ROOT" ] && [ -d "$LIBRARIUM_ROOT" ]; then
    echo -e "✅ LIBRARIUM_ROOT is set to: $LIBRARIUM_ROOT"
else
    echo -e "❌ LIBRARIUM_ROOT is not set or is invalid."
fi

# Check 2: Nerd Font Visual Test
echo -e "✅ Nerd Font Test:    (should display as icons)"

# Check 3: Summarize managed items
# Use grep to ignore empty/commented lines
PACKAGE_COUNT=$(grep -cvE '^\s*(#|$)' "$LIBRARIUM_ROOT/packages.txt" 2>/dev/null || echo 0)
PLUGIN_COUNT=$(grep -cvE '^\s*(#|$)' "$LIBRARIUM_ROOT/plugins.txt" 2>/dev/null || echo 0)
ALIAS_COUNT=$(grep -c '^alias' "$LIBRARIUM_ROOT/lib/aliases.fish" 2>/dev/null || echo 0)
FUNCTION_COUNT=$(ls -1 "$LIBRARIUM_ROOT/lib/functions/" | wc -l)

echo "✅ Summary:"
echo "  - Packages Managed: $PACKAGE_COUNT"
echo "  - Plugins Managed:  $PLUGIN_COUNT"
echo "  - Aliases Defined:  $ALIAS_COUNT"
echo "  - Functions Loaded: $FUNCTION_COUNT"

echo "---------------------------------"
