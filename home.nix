{ config, pkgs, username, ... }:

{
	# Home Manager needs a bit of information about you and the
	# paths it should manage.
	home.username = username;
	home.homeDirectory = "/Users/${username}";

	# Packages that should be installed to the user profile.
	home.packages = [
		pkgs.any-nix-shell
		pkgs.zoxide
		pkgs.fzf
	];

	# This value determines the Home Manager release that your
	# configuration is compatible with. This helps avoid breakage
	# when a new Home Manager release introduces backwards
	# incompatible changes.
	#
	# You can update Home Manager without changing this value. See
	# the Home Manager release notes for a list of state version
	# changes in each release.
	home.stateVersion = "24.05";

	# config.nix
	home.file.".config/nixpkgs/config.nix" = {
		text = "{ allowUnfree = true; }";
	};

	# ghostty
	home.file.".config/ghostty/config".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/ghostty.config";

	# worktrunk
	home.file.".config/worktrunk/config.toml".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/worktrunk.toml";

	# herdr
	home.file.".config/herdr/config.toml".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/herdr.toml";
	
	# herdr-automatic-rename
	home.file.".config/herdr-automatic-rename/config.sh".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/herdr-automatic-rename.config.sh";

	# fish
	home.file.".config/fish/conf.d/config.fish".source =
		config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/config.fish";

	programs.fish = {
		enable = true;
		plugins = [
			{
				name = "pure";
				src = pkgs.fishPlugins.pure.src;
			}
		];
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
