# ==================================================
# Librarium F.O.S. - Core Configuration
# ==================================================
# This file's main purpose is to load all the components
# from the lib/ directory.

# The LIBRARIUM_ROOT variable is set by the installer.
# We use it to reliably find our library files.
if test -d "$LIBRARIUM_ROOT/lib"
    for file in $LIBRARIUM_ROOT/lib/*.fish
        source $file
    end
end
