.PHONY: apply build update cleanup

# Without HOST, darwin-rebuild picks the configuration matching this Mac's
# LocalHostName. Pass it explicitly otherwise: `make apply HOST=alex-mbp-work`.
HOST ?=
HASH := \#
FLAKE := .$(if $(HOST),$(HASH)$(HOST))

apply:
	brew update
	sudo darwin-rebuild switch --flake $(FLAKE)

# Build without activating (sanity check).
build:
	darwin-rebuild build --flake $(FLAKE)

# Bump all flake inputs (nixpkgs, nix-darwin, home-manager, ...).
update:
	nix flake update

# Old generations are also collected weekly (see modules/darwin/nix.nix).
cleanup:
	sudo nix-collect-garbage --delete-older-than 30d
