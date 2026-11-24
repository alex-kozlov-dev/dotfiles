# Dotfiles

nix-darwin + home-manager config for my Macs.

```
flake.nix            # one entry per Mac (named after its LocalHostName)
hosts/               # what's specific to each machine (identity, extra apps)
modules/darwin/      # shared system config: Homebrew, macOS defaults, shells
modules/home/        # shared user config: packages, fish, git, dotfile links
config/              # raw config files, symlinked into place (edit without rebuilding)
```

## Installation

Install Xcode CLI tools:

```bash
xcode-select --install
```

Install Nix:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Pull the repo:

```bash
nix-shell -p git --run 'git clone https://github.com/alex-kozlov-dev/dotfiles.git ~/.dotfiles'
```

Add the machine: create `hosts/<name>.nix` and an entry `<name>` in `flake.nix`. Set `networking.hostName` and `networking.localHostName` to `<name>` in the host file so later runs find it automatically. Then activate:

```bash
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ~/.dotfiles#<name>
```

## Commands

| | |
|---|---|
| `make apply` | Update Homebrew and apply the config (`HOST=<name>` if the hostname doesn't match) |
| `make build` | Build without applying (same `HOST=`) |
| `make update` | Update flake inputs |
| `make cleanup` | Delete old Nix generations |
