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
		username = "alex.k";

		configuration = { pkgs, ... }: {

			nixpkgs.config.allowUnfree = true;

			# List packages installed in system profile. To search by name, run:
			# $ nix-env -qaP | grep wget
			environment.systemPackages =
				[
					pkgs.micro
					pkgs.git
					pkgs.gh
					pkgs.google-chrome
					pkgs.jq
					pkgs.slack
					pkgs.vscode
					pkgs.rancher
					pkgs.fishPlugins.bass
				];
			
			fonts.packages = [
				pkgs.nerd-fonts.fira-code
			];

			# Homebrew
			homebrew = {
				enable = true;

				brews = [
					"mas"
					"thefuck"
					"codex"
				
					"awscli"

					"watchman"
				];

				casks = [
					"figma"
					"licecap"
					"tunnelblick"
					"zoom"
					"betterdisplay"
					"proxy-audio-device"
					"swish"
					"1password"
					"cursor"
					"raycast"
					"ollama"
					# "notion"
					"ghostty"
					# "rancher"

					"zulu@17"
					# "android-studio"
				];

				masApps = {
				  "1Password for Safari" = 1569813296;
				  "Numbers" = 409203825;
				  "Pages" = 409201541;
				  "Spark" = 1176895641;
				  "Velja" = 1607635845;
				  "Telegram" = 747648890;
				};

				onActivation = {
					autoUpdate = true;
					upgrade = true;

					# cleanup = "zap";
					cleanup = "none";
				};
			};

			# Necessary for using flakes on this system.
			nix.settings.experimental-features = "nix-command flakes";

			# Enable alternative shell support in nix-darwin.
			programs.fish = {
				enable = true;
				interactiveShellInit = ''
					set -gx LANG en_US.UTF-8
					set -gx LC_MESSAGES en_US.UTF-8
					set -U fish_greeting
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
				configuration
				home-manager.darwinModules.home-manager
				{
					users.users.${username}.home = "/Users/${username}";
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
