{ lib, username, ... }:

# Homebrew is for GUI apps (casks) and CLI tools that aren't in nixpkgs.
# Everything else goes in modules/home/packages.nix.
{
	nix-homebrew = {
		enable = true;
		# Apple Silicon only: also install Homebrew under the Intel prefix for Rosetta 2.
		enableRosetta = true;
		user = username;
	};

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
			"worktrunk"
			"herdr"
			"moshi-hook"
			"mosh"
			"eugenioenko/ttt/ttt"
			"beads"
			"rust"
		];

		casks = [
			"figma"
			"licecap"
			"tunnelblick"
			"swish"
			"1password"
			"cursor"
			"raycast"
			"sunsama"
			"bartender"
			"herdr-app"
			"google-chrome"
			"claude"
			"macwhisper"
			"docker-desktop"
			"betterdisplay"
			"claude-code@latest"
			"slack"
			"telegram"
			"vibe-island"
			"visual-studio-code"
			"hammerspoon"
		];

		onActivation = {
			# Must stay false: nix-homebrew's `brew` wrapper re-execs itself after
			# auto-updating, and on that second pass it rebuilds HOMEBREW_PATH from
			# the already-sanitized PATH. `mas` then isn't on the path `brew bundle`
			# searches, so it decides mas is missing and every masApps entry dies with
			# "Installing <app> has failed!". `make apply` runs `brew update` instead.
			autoUpdate = false;
			upgrade = true;

			# Remove anything not listed above. Hosts can override this.
			cleanup = lib.mkDefault "zap";
		};
	};
}
