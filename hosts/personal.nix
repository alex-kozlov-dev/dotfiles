{ pkgs, username, ... }:

{
	# Let nix-darwin own this account so it can set the login shell.
	users.knownUsers = [ username ];
	users.users.${username} = {
		uid = 501;
		shell = pkgs.fish;
	};

	home-manager.users.${username} = {
		programs.git.settings.user = {
			email = "mediumespresso@gmail.com";
			signingkey = "/Users/${username}/.ssh/id_ed25519_preply.pub";
		};
	};

	# Personal-only apps go here, e.g.:
	# homebrew.casks = [ "telegram" ];
}
