{
	description = "My nix-darwin system flake";

	inputs = {
		nixpkgs = {
			url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		};
		nix-darwin = {
			url = "github:LnL7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-homebrew = {
			url = "github:zhaofengli-wip/nix-homebrew";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs, nix-homebrew }:
	let
		identity = import ./identity.nix;
		inherit (identity) username;

		configuration = { pkgs, ... }: {

			nixpkgs.config.allowUnfree = true;

			# List packages installed in system profile. To search by name, run:
			# $ nix-env -qaP | grep wget
			environment.systemPackages =
				[
					pkgs.micro
					pkgs.git
					pkgs.gh
					pkgs.jq
					pkgs.rancher
					pkgs.fishPlugins.bass
				];
			
			fonts.packages = [
				pkgs.nerd-fonts.fira-code
			];

			# Homebrew
			homebrew = {
				enable = true;

				taps = [
					{
						name = "rjyo/moshi";
						trusted = true;
					}
				];

				brews = [
					"mas"
					"thefuck"
					"uv"
					"mise"
					"worktrunk"
					"herdr"
					"ripgrep"
					"mdcat"
					"moshi-hook"
					"mosh"
					"fresh-editor"
				];

				casks = [
					"figma"
					"licecap"
					"tunnelblick"
					# "zoom"
					"swish"
					"1password"
					"cursor"
					"raycast"
					"sunsama"
					"bartender"
					# "boring-notch"
					"ghostty"
					"google-chrome"
					"claude"
					"macwhisper"
					"docker-desktop"
					"betterdisplay"
					"tailscale-app"
					"claude-code@latest"
					"slack"
					"telegram"
					"vibe-island"
					"visual-studio-code"
				];

				onActivation = {
					# Must stay false: nix-homebrew's `brew` wrapper re-execs itself after
					# auto-updating, and on that second pass it rebuilds HOMEBREW_PATH from
					# the already-sanitized PATH. `mas` then isn't on the path `brew bundle`
					# searches, so it decides mas is missing and every masApps entry dies with
					# "Installing <app> has failed!". `make apply` runs `brew update` instead.
					autoUpdate = false;
					upgrade = true;

					cleanup = "zap";
				};
			};

			# Necessary for using flakes on this system.
			nix.settings.experimental-features = "nix-command flakes";

			programs.zsh = {
				enable = true;
				loginShellInit = ''
					eval "$(mise activate zsh)"
					mise settings add idiomatic_version_file_enable_tools node

					eval "$(wt config shell init zsh)"
				'';
			};

			# Enable alternative shell support in nix-darwin.
			programs.fish = {
				enable = true;
				interactiveShellInit = ''
					set -gx LANG en_US.UTF-8
					set -gx LC_MESSAGES en_US.UTF-8
					set -U fish_greeting

					wt config shell init fish | source
				'';
			};

			system = {
				# Set Git commit hash for darwin-version.
				configurationRevision = self.rev or self.dirtyRev or null;

				# Used for backwards compatibility, please read the changelog before changing.
				# $ darwin-rebuild changelog
				stateVersion = 5;

				defaults = {
					dock.autohide = true;

					finder = {
						AppleShowAllFiles = true;
						FXPreferredViewStyle = "clmv";
					};

					NSGlobalDomain.AppleICUForce24HourTime = true;
				};
			};

			# Enable Touch ID for sudo authentication
			security.pam.services.sudo_local.touchIdAuth = true;

			# The platform the configuration will be used on.
			nixpkgs.hostPlatform = "aarch64-darwin";
		};
	in
	{
		# Build darwin flake using:
		# $ darwin-rebuild build --flake .#mac
		darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
			modules = [
				identity.module
				configuration
				home-manager.darwinModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = "backup";
						users.${username} = import ./home.nix;
						extraSpecialArgs = {
							inherit username;
						};
					};
				}
				nix-homebrew.darwinModules.nix-homebrew
				{
					nix-homebrew = {
						# Install Homebrew under the default prefix
						enable = true;

						# Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
						enableRosetta = true;

						# User owning the Homebrew prefix
						user = username;
					};
				}
			];
		};

		# Expose the package set, including overlays, for convenience.
		darwinPackages = self.darwinConfigurations."mac".pkgs;
	};
}
