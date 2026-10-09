if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Disable the welcome message
set -g fish_greeting

fish_config theme choose "Rosé Pine"

# Starship prompt, with transient prompt showing only the prompt character
function starship_transient_prompt_func
    starship module character
end
starship init fish | source
enable_transience
