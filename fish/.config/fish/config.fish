if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Show fastfetch instead of the welcome message, only directly in Ghostty
# (TERM_PROGRAM is "tmux" inside tmux, so new panes stay quiet)
function fish_greeting
    if test "$TERM_PROGRAM" = ghostty; and command -q fastfetch
        fastfetch
    end
end

fish_config theme choose "Rosé Pine"

# Starship prompt, with transient prompt showing only the prompt character
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience
