# lib/aliases.fish
#
# A straightforward and memorable alias library for Librarium F.O.S.

# --- Navigation & System ---
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias grep="grep --color=auto"
alias ping="ping -c 5"
alias df="df -h"
alias du="du -h"

# --- File System ---
alias ls="ls -la --color=auto -F"

# --- Package Management (pacman) ---
alias pac-update="pacman -Syu"
alias pac-install="pacman -S"
alias pac-search="pacman -Ss"
alias pac-remove="pacman -Rns"
alias pac-query="pacman -Q"

# --- Git ---
alias g-status="git status"
alias g-add="git add"
alias g-commit="git commit -m"
alias g-push="git push"
alias g-log="git log --oneline --graph --decorate --all"

# --- Librarium F.O.S. Management ---
alias fos="$LIBRARIUM_ROOT/bin/librarium_interface.sh"
alias update-fos='set -l start_dir (pwd); and cd $LIBRARIUM_ROOT; and ./install/install.sh; and cd $start_dir'

# Plugin Management
alias p-list="$LIBRARIUM_ROOT/bin/librarium_interface.sh plugin list"
alias p-add="$LIBRARIUM_ROOT/bin/librarium_interface.sh plugin add"
alias p-remove="$LIBRARIUM_ROOT/bin/librarium_interface.sh plugin remove"
alias p-update="$LIBRARIUM_ROOT/bin/librarium_interface.sh plugin update"
