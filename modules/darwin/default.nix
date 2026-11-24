{ inputs, username, hosts, hostName, tailnet, ... }:

{
	imports = [
		inputs.home-manager.darwinModules.home-manager
		inputs.nix-homebrew.darwinModules.nix-homebrew
		./nix.nix
		./system.nix
		./shell.nix
		./tailscale.nix
		./homebrew.nix
	];

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		backupFileExtension = "backup";
		extraSpecialArgs = { inherit username hosts hostName tailnet; };
		users.${username} = ../home;
	};
}
