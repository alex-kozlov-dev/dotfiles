set -U NVM_DIR "$HOME/.nvm"

any-nix-shell fish --info-right | source
zoxide init fish | source

# Add a newline to the end of each command
function add_newline --on-event fish_postexec
    echo
end

# Activate mise
mise activate fish | source

# Enable .nvmrc
mise settings add idiomatic_version_file_enable_tools node

set -u pure_enable_aws_profile false

# Quick question: ask Claude and print the answer, e.g. `qq how do I undo a git commit?`
function qq --description "Ask Claude a quick question"
    if test (count $argv) -eq 0
        echo "Usage: qq <question>" >&2
        return 1
    end
    claude -p --model sonnet --tools "" --no-session-persistence \
        --append-system-prompt "You are answering a quick one-off question asked from the terminal. Answer directly and concisely, in a few lines at most. No preamble, no follow-up questions." \
        "$argv"
end

# Source private fish configuration if it exists
if test -f ~/.dotfiles/config/private/private.fish
    source ~/.dotfiles/config/private/private.fish
end

# https://github.com/qu8n/herdr-automatic-rename
# Auto rename hook
for _f in $HOME/.config/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.fish
    test -r "$_f"; and source "$_f"; and break
end
