{ username, ... }:

# Work Mac (stub). Bootstrap once:
#   sudo nix run nix-darwin -- switch --flake ~/.dotfiles#alex-mbp-work
#
# If IT/MDM resets the hostname later, plain `make apply` won't find this
# config; use `make apply HOST=alex-mbp-work` (which also renames it back).
#
# Tailscale: quit and remove the Tailscale app first if it's installed (cleanup
# below won't remove it), then sign in with `sudo tailscale up --ssh`. If IT runs
# its own Tailscale or VPN on this Mac, check that before switching.
{
	# The account is likely managed by IT/MDM, so nix-darwin doesn't take it over
	# (no users.knownUsers). Set the login shell once by hand:
	#   chsh -s /run/current-system/sw/bin/fish

	# Don't remove Homebrew apps that aren't listed here: IT may have installed some.
	# Switch to "zap" once you know nothing else uses Homebrew on this machine.
	homebrew.onActivation.cleanup = "none";

	home-manager.users.${username} = {
		# TODO: work identity
		# programs.git.settings.user = {
		# 	email = "...";
		# 	signingkey = "/Users/${username}/.ssh/<work key>.pub";
		# };
	};

	# Work-only apps go here, e.g.:
	# homebrew.casks = [ "zoom" ];
}
