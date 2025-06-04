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

	# nvm
	home.file.".nvm" = {
		source = builtins.fetchGit {
			url = "https://github.com/nvm-sh/nvm.git";
			ref = "refs/tags/v0.40.1";
			rev = "179d45050be0a71fd57591b0ed8aedf9b177ba10";
		};
		recursive = true;
	};
	home.file.".nvm/default-packages" = {
		text = "yarn";
	};

	# config.nix
	home.file.".config/nixpkgs/config.nix" = {
		text = "{ allowUnfree = true; }";
	};

	# ghostty
	home.file.".config/ghostty/config" = {
		text = ''
			command = ${pkgs.fish}/bin/fish
			quick-terminal-animation-duration = 0
			quick-terminal-screen = macos-menu-bar
			background-opacity = 0.75
			background-blur-radius = 20
			keybind = global:ctrl+§=toggle_quick_terminal
			keybind = global:ctrl+~=toggle_quick_terminal
			keybind = global:ctrl+`=toggle_quick_terminal
			theme = niji
		'';
	};

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

				# ghostty shell integration
				if set -q GHOSTTY_RESOURCES_DIR
					source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
				end

				# Auto load nvm
				function __load_nvm --on-variable="PWD"
					set -l default_node_version (nvm version default)
					set -l node_version (nvm version)
					set -l nvmrc_path (nvm_find_nvmrc)
					if test -n "$nvmrc_path"
						set -l nvmrc_node_version (nvm version (cat $nvmrc_path))
						if test "$nvmrc_node_version" = "N/A"
							nvm install (cat $nvmrc_path)
						else if test "$nvmrc_node_version" != "$node_version"
							nvm use $nvmrc_node_version
						end
					else if test "$node_version" != "$default_node_version"
						echo "Reverting to default Node version"
						nvm use default
					end
				end

				__load_nvm

				set -gx JAVA_HOME "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
				set -gx ANDROID_HOME "$HOME/Library/Android/sdk"
				set -gx PATH "$PATH:$ANDROID_HOME/emulator"
				set -gx PATH "$PATH:$ANDROID_HOME/platform-tools"

				set -gx PATH "$PATH:$HOME/.rd/bin"

				set -gx AWS_PROFILE "staging"

				set -u pure_enable_aws_profile false
		'';
		plugins = [
			{
				name = "pure";
				src = pkgs.fishPlugins.pure.src;
			}
		];
		functions = {
			nvm = "bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv";
			nvm_find_nvmrc = "bass source ~/.nvm/nvm.sh --no-use ';' nvm_find_nvmrc";
		};
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}