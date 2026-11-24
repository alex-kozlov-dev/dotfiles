{
	description = "Alex's macOS machines (nix-darwin + home-manager)";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin = {
			url = "github:LnL7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, nix-darwin, ... }:
	let
		# Every Mac. The name is used as its flake entry, its hostname and its
		# Tailscale name, and every other Mac gets an SSH entry for it.
		hosts = {
			alex-mbp-personal = {
				username = "alex";
				module = ./hosts/personal.nix;
			};
			alex-mbp-work = {
				username = "alex"; # TODO: the work Mac's username
				module = ./hosts/work.nix;
			};
		};

		# The tailnet's MagicDNS suffix (Tailscale admin console > DNS).
		tailnet = "snares-wahoo.ts.net";

		mkDarwin = hostName: host: nix-darwin.lib.darwinSystem {
			specialArgs = {
				inherit inputs self hosts hostName tailnet;
				inherit (host) username;
			};
			modules = [ ./modules/darwin host.module ];
		};
	in
	{
		# Shared base (modules/) + one host file with what's specific to that machine.
		# `darwin-rebuild switch --flake .` picks the entry matching the Mac's hostname;
		# only the very first switch on a new machine needs `--flake .#<name>`.
		darwinConfigurations = builtins.mapAttrs mkDarwin hosts;
	};
}
