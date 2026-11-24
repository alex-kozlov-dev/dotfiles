# Sourced at the end of ~/.config/fish/config.fish (see modules/home/shell.nix).
# Edits apply to new shells without a rebuild.

set -gx EDITOR ttt

set -g pure_enable_aws_profile false

# Add a newline to the end of each command
function add_newline --on-event fish_postexec
    echo
end

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

# https://github.com/qu8n/herdr-automatic-rename
# Auto rename hook
for _f in $HOME/.config/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.fish
    test -r "$_f"; and source "$_f"; and break
end

# Private config (not in git)
if test -f ~/.dotfiles/config/private/private.fish
    source ~/.dotfiles/config/private/private.fish
end
