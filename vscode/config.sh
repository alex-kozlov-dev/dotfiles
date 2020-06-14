#! /usr/bin/env bash

rm -rf "$HOME/Library/Application Support/Code/User/settings.json"
ln -sf "$HOME/.dotfiles/vscode/config/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
