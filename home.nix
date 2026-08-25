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
	home.file.".config/ghostty/config" = {
		text = ''
			font-family = "FiraCode Nerd Font Mono"
			quick-terminal-animation-duration = 0
			quick-terminal-screen = macos-menu-bar
			quick-terminal-size = 100%
			keybind = global:ctrl+§=toggle_quick_terminal
			keybind = global:ctrl+~=toggle_quick_terminal
			keybind = global:ctrl+`=toggle_quick_terminal
			keybind = shift+enter=text:\n
			theme = Flexoki Dark
			background = #000000
			background-opacity = 0.9
		'';
	};

	# worktrunk (wt) config — copy-ignored on post-start brings node_modules,
	# the repo's .vscode/ folder, and .claude/settings.local.json into each new
	# worktree (reflink copy, so it's cheap).
	home.file.".config/worktrunk/config.toml".source = ./config/worktrunk/config.toml;

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
				set -U NVM_DIR "$HOME/.nvm"

				any-nix-shell fish --info-right | source
				zoxide init fish | source

				# Add a newline to the end of each command
				function add_newline --on-event fish_postexec
					echo
				end

				# Activate mise
				mise activate fish | source

				# Enable .nvmrc
				mise settings add idiomatic_version_file_enable_tools node

				# fish_add_path "/Users/alex/.bun/bin"

				set -u pure_enable_aws_profile false

				# Source private fish configuration if it exists
				if test -f ~/.config/fish/private.fish
					source ~/.config/fish/private.fish
				end

				# https://github.com/qu8n/herdr-automatic-rename
				# Auto rename hook
				for _f in $HOME/.config/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.fish
					test -r "$_f"; and source "$_f"; and break
				end
		'';
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
