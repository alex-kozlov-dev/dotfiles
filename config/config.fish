set -U NVM_DIR "$HOME/.nvm"

any-nix-shell fish --info-right | source
zoxide init fish | source

# Add a newline to the end of each command
function add_newline --on-event fish_postexec
    echo
end

# conf.d is sourced before /etc/fish/config.fish runs `brew shellenv`,
# so Homebrew (and mise) aren't on PATH yet at this point
if test -d /opt/homebrew/bin; and not contains /opt/homebrew/bin $PATH
    set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
end

# Activate mise
mise activate fish | source

set -u pure_enable_aws_profile false

set -U EDITOR fresh

# Quick question: ask Claude and print the answer, e.g. `qq how do I undo a git commit?`
function qq --description "Ask Claude a quick question"
    if test (count $argv) -eq 0
        echo "Usage: qq <question>" >&2
        return 1
    end
    # --safe-mode skips hooks so Vibe Island doesn't pick qq up as an agent
    # session; unlike --bare it still reads OAuth auth from the keychain
    claude -p --safe-mode --model sonnet --no-session-persistence \
        --tools "Read,Glob,Grep,WebSearch,WebFetch" \
        --allowedTools "Read,Glob,Grep,WebSearch,WebFetch" \
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
