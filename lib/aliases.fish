# lib/aliases.fish
#
# A straightforward and memorable alias library for Librarium S.I.D.E.

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

# --- Librarium S.I.D.E. Management ---
alias side="side_interface.sh"
alias side-apply="side_interface.sh apply"

# Plugin Management
alias p-list="side_interface.sh plugin list"
alias p-add="side_interface.sh plugin add"
alias p-remove="side_interface.sh plugin remove"
alias p-update="side_interface.sh plugin update"
alias p-compile="side_interface.sh plugin compile"

# Theme Management
alias t-list="side_interface.sh theme list"
alias t-set="side_interface.sh theme set"
