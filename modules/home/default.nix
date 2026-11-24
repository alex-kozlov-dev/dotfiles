{ username, ... }:

{
	imports = [
		./packages.nix
		./shell.nix
		./git.nix
		./ssh.nix
		./dotfiles.nix
	];

	home.username = username;
	home.homeDirectory = "/Users/${username}";

	# The Home Manager release this config was written against. Leave it alone when
	# updating; read the release notes before changing it.
	home.stateVersion = "24.05";

	programs.home-manager.enable = true;
}
