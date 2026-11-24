{ config, ... }:

# Shared git settings. Identity (email, signing key) is set per host in hosts/.
{
	programs.git = {
		enable = true;
		settings = {
			user.name = "Alex Kozlov";
			init.defaultBranch = "main";

			# Sign commits with an SSH key
			gpg.format = "ssh";
			commit.gpgsign = true;
			gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
		};
		ignores = [ "**/.claude/settings.local.json" ];
		# Signing is configured in `settings` above; this stops home-manager from
		# also adding a GnuPG signer.
		signing.format = null;
	};
}
