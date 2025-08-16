# lib/aliases.fish
#
# This file contains all the standard aliases for Librarium F.O.S.

# Navigation
alias ..="cd .."
alias ...="cd ../.."

# A better 'ls'
alias ls="ls --color=auto -F"
alias la="ls -la" # List all files, long format

# Clear the screen
alias c="clear"

# System & Package Management
alias grep="grep --color=auto"
alias pacu="pacman -Syu"   # Update all packages
alias pacs="pacman -Ss"    # Search for a package
alias pacr="pacman -Rns"   # Remove a package and its dependencies

# Git Shortcuts
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
