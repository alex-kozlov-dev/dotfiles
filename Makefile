.PHONY: apply cleanup

apply:
	darwin-rebuild switch --flake .#mac

cleanup:
	sudo nix-collect-garbage
