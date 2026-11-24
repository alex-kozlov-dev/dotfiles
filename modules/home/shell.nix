{ config, lib, pkgs, ... }:

{
	home.sessionVariables = {
		LANG = "en_US.UTF-8";
		LC_MESSAGES = "en_US.UTF-8";
	};

	programs.fish = {
		enable = true;
		plugins = [
			{ name = "pure"; src = pkgs.fishPlugins.pure.src; }
			{ name = "bass"; src = pkgs.fishPlugins.bass.src; }
		];
		interactiveShellInit = lib.mkMerge [
			''
				set -g fish_greeting
				any-nix-shell fish --info-right | source
				wt config shell init fish | source
			''
			# Everything else is in an editable file, so changes don't need a rebuild.
			(lib.mkAfter ''
				source ${config.home.homeDirectory}/.dotfiles/config/config.fish
			'')
		];
	};

	# These add their own shell hooks (`zoxide init`, `mise activate`).
	programs.zoxide.enable = true;
	programs.mise.enable = true;
}
