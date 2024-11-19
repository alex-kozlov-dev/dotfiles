# Dotfiles

Install xcode CLI tools:

```bash
xcode-select --install
```

Install nix:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Pull the repo:

```bash
nix-shell -p git --run 'git clone -b nix https://github.com/alex-kozlov-dev/dotfiles.git ~/.dotfiles'
```

Activate config:

```bash
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/.dotfiles#mac
```
