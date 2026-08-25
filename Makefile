.PHONY: apply cleanup

apply:
	# homebrew.onActivation.autoUpdate is off (see flake.nix), so refresh here.
	-brew update
	sudo darwin-rebuild switch --flake .#mac

cleanup:
	sudo nix-collect-garbage
