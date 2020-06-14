#! /usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo 'Dumping Brewfile...'
brew bundle dump --force --describe --file=$DOTFILES/brew/Brewfile

echo 'Dumping VSCode plugins...'
code --list-extensions > $DOTFILES/vscode/plugins.txt
