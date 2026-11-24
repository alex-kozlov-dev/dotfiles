{ pkgs, self, username, hostName, ... }:

{
	# Same name as the flake entry, so `make apply` finds this config without a name,
	# and tailscaled registers the Mac on the tailnet under it.
	networking = {
		inherit hostName;
		localHostName = hostName;
	};

	system.primaryUser = username;
	users.users.${username}.home = "/Users/${username}";

	fonts.packages = [ pkgs.nerd-fonts.fira-code ];

	# Touch ID for sudo
	security.pam.services.sudo_local.touchIdAuth = true;

	system.defaults = {
		dock.autohide = true;

		finder = {
			AppleShowAllFiles = true;
			FXPreferredViewStyle = "clmv";
		};

		NSGlobalDomain.AppleICUForce24HourTime = true;

		CustomUserPreferences = {
			# Equivalent of Dock right-click > Options > Assign To: All Desktops.
			# Makes the Herdr window show on the current Space when summoned via
			# the Hammerspoon hotkey instead of switching to its own Space.
			"com.apple.spaces" = {
				"app-bindings" = {
					"dev.herdr.app" = "AllSpaces";
				};
			};
		};
	};

	# Git commit hash for darwin-version.
	system.configurationRevision = self.rev or self.dirtyRev or null;

	# Used for backwards compatibility, please read the changelog before changing.
	# $ darwin-rebuild changelog
	system.stateVersion = 5;
}
