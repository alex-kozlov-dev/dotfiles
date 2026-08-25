.PHONY: apply cleanup

USERNAME ?= $(shell id -un)
USER_UID ?= $(shell id -u)

apply:
	sudo env USER=$(USERNAME) NIX_DARWIN_UID=$(USER_UID) darwin-rebuild switch --flake .#mac --impure

cleanup:
	sudo nix-collect-garbage
