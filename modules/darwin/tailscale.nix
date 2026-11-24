{ config, lib, ... }:

let
	tailscale = "${config.services.tailscale.package}/bin/tailscale";
in
{
	# The open-source tailscaled daemon (CLI only, no menu bar app). On macOS only
	# this variant can be a Tailscale SSH server; the App Store/standalone app can't.
	# Sign in once per Mac with `sudo tailscale up --ssh`.
	services.tailscale.enable = true;

	# tailscaled writes /etc/resolver/ts.net itself. nix-darwin's copy is a symlink,
	# which tailscaled refuses to write through ("path escapes from parent"), so it
	# reports a DNS health warning. Let tailscaled own the file.
	environment.etc."resolver/ts.net".enable = false;

	# Tailscale SSH: other devices on the tailnet log in as `<user>@<this Mac>` with no
	# SSH keys; who may connect is set by the "ssh" rules in the tailnet policy.
	# tailscaled remembers this setting; reapplying it on every switch keeps it declared.
	system.activationScripts.postActivation.text = lib.mkAfter ''
		ok=
		for _ in 1 2 3 4 5; do
			if ${tailscale} set --ssh >/dev/null 2>&1; then ok=1; break; fi
			sleep 1
		done
		[ -n "$ok" ] || echo "warning: couldn't enable Tailscale SSH. Run: sudo tailscale up --ssh" >&2
	'';
}
