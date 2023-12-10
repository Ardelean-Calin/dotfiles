if status is-interactive
    set -U fish_greeting
    # Commands to run in interactive sessions can go here
    starship init fish | source
    zoxide init fish | source
end
