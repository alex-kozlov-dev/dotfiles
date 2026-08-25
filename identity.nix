# Requires `--impure` (see `make apply`). sudo would otherwise set USER=root.
let
	username =
		let u = builtins.getEnv "USER";
		in if u == "" || u == "root"
			then throw "Set USER to the macOS account (use `make apply`)"
			else u;
	uid =
		let raw = builtins.getEnv "NIX_DARWIN_UID";
		in if raw == ""
			then throw "Set NIX_DARWIN_UID (use `make apply`)"
			else builtins.fromJSON raw;
in
{
	inherit username uid;

	module = { pkgs, ... }: {
		users.knownUsers = [ username ];
		users.users.${username} = {
			uid = uid;
			home = "/Users/${username}";
			shell = pkgs.fish;
		};
		system.primaryUser = username;
	};
}
