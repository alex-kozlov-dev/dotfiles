{ ... }:

{
	# Put Homebrew on PATH for every shell, interactive or not. Previously it was only
	# added by `brew shellenv` in interactive fish, after conf.d had already run.
	environment.systemPath = [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ];

	# System-level enables register the shells in /etc/shells and load the Nix
	# environment. Fish user config lives in modules/home/shell.nix.
	programs.fish.enable = true;

	# zsh isn't managed by home-manager (Claude Code and other tools use it).
	programs.zsh = {
		enable = true;
		loginShellInit = ''
			eval "$(mise activate zsh)"
			eval "$(wt config shell init zsh)"
		'';
	};
}
