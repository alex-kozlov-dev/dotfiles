{ pkgs, ... }:

# CLI tools from nixpkgs. GUI apps and tools missing from nixpkgs are in
# modules/darwin/homebrew.nix.
{
	home.packages = with pkgs; [
		micro
		gh
		jq
		ripgrep
		fzf
		uv
		mdcat
		rancher
		any-nix-shell

		# Nix language server (+ the formatter it shells out to) for ttt
		nixd
		nixfmt
	];
}
