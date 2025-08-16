# lib/functions/fish_prompt.fish
# A custom, Geometry-style prompt for Librarium F.O.S. (Corrected)

function _prompt_segment
    # Helper to draw a full segment.
    # Args: background_color, foreground_color, text
    echo -n -s (set_color -b $argv[1]) (set_color $argv[2]) ' ' $argv[3] ' '
end

function _prompt_separator
    # Helper to draw the separator between segments.
    # Args: prev_background, new_background
    echo -n -s (set_color -b $argv[1]) (set_color $argv[2]) ''
end

function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l last_bg 'normal' # Start with the default background

    # --- Path Segment ---
    set -l path_bg blue
    set -l path_fg white
    _prompt_separator $last_bg $path_bg
    _prompt_segment $path_bg $path_fg (prompt_pwd)
    set last_bg $path_bg

    # --- Git Segment ---
    set -l git_branch (git branch --show-current 2>/dev/null)
    if test -n "$git_branch"
        set -l git_bg
        set -l git_fg black
        # UPDATED THIS LINE with double quotes
        if test -n "(git status --porcelain)"
            set git_bg yellow # Dirty is yellow
        else
            set git_bg green # Clean is green
        end
        _prompt_separator $last_bg $git_bg
        _prompt_segment $git_bg $git_fg " $git_branch"
        set last_bg $git_bg
    end

    # --- Final Prompt Character ---
    if test $last_status -eq 0
        set -l prompt_color green
    else
        set -l prompt_color red
    end
    
    _prompt_separator $last_bg 'normal'
    echo -n -s (set_color $prompt_color) '❯ ' $normal
end
