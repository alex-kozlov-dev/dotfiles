#! /usr/bin/env bash

# https://www.peerlator.com/blog/MyDotfilesPart5/
while read EXTENSION
do
  echo_info "Install VSCode Extension: $EXTENSION"
  code --install-extension $EXTENSION
done < $HOME/.dotfiles/vscode/plugins.txt
