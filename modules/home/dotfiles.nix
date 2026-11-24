{ config, pkgs, ... }:

let
	# Symlink straight to the file in this repo (not a copy in the Nix store),
	# so edits take effect immediately without a rebuild.
	link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/${path}";
in
{
	home.file = {
		".config/worktrunk/config.toml".source = link "worktrunk.toml";
		".config/herdr/config.toml".source = link "herdr.toml";
		".config/herdr-automatic-rename/config.sh".source = link "herdr-automatic-rename.config.sh";
		".config/mise/config.toml".source = link "mise.toml";
		".hammerspoon/init.lua".source = link "hammerspoon.lua";
		".config/ttt/settings.json".source = link "ttt/settings.json";
		".config/ttt/plugins.ttt.json".source = link "ttt/plugins.ttt.json";

		# ttt skips symlinked plugin dirs, so link file-by-file into a real dir
		".config/ttt/plugins/markdown-preview" = {
			source = "${pkgs.fetchFromGitHub {
				owner = "eugenioenko";
				repo = "ttt-plugins";
				rev = "c107ee4d84cb0bfcd1ae41992d6b640feb3bcfac";
				hash = "sha256-WdRf+Sp1wYgqNRn+SzD+CLLCympmo6k2UD/qoZ5TLgg=";
			}}/markdown-preview";
			recursive = true;
		};
	};
}
