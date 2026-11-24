{ lib, hosts, hostName, tailnet, ... }:

let
	otherMacs = lib.filterAttrs (name: _: name != hostName) hosts;
in
{
	programs.ssh = {
		enable = true;
		enableDefaultConfig = false;

		# Each attribute is a `Host` block; keys are OpenSSH directives as written in ssh_config.
		settings = {
			"github.com" = {
				AddKeysToAgent = "yes";
				IdentityFile = "~/.ssh/id_ed25519";
			};
			"github.com-preply" = {
				HostName = "github.com";
				User = "git";
				AddKeysToAgent = "yes";
				IdentityFile = "~/.ssh/id_ed25519_preply";
				IdentitiesOnly = "yes";
			};
		}
		# The other Macs, over Tailscale SSH. Named hosts here are what herdr's
		# "Add machine" picker lists.
		// lib.mapAttrs (name: host: {
			HostName = "${name}.${tailnet}";
			User = host.username;
			# Tailscale authenticates by tailnet identity: don't offer SSH keys.
			PubkeyAuthentication = "no";
			# The tailnet already verified the machine; trust its SSH host key on first use.
			StrictHostKeyChecking = "accept-new";
		}) otherMacs;
	};
}
