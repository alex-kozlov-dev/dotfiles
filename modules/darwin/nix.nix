{ lib, ... }:

{
	nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
	nixpkgs.config.allowUnfree = true;

	nix.settings.experimental-features = "nix-command flakes";

	# Weekly: delete generations older than 30 days, then dedupe the store.
	nix.gc = {
		automatic = true;
		options = "--delete-older-than 30d";
	};
	nix.optimise.automatic = true;
}
