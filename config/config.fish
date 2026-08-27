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

# Source private fish configuration if it exists
if test -f ~/.dotfiles/config/private/private.fish
    source ~/.dotfiles/config/private/private.fish
end

# https://github.com/qu8n/herdr-automatic-rename
# Auto rename hook
for _f in $HOME/.config/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.fish
    test -r "$_f"; and source "$_f"; and break
end
