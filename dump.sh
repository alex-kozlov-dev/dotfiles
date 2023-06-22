#! /usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo 'Dumping Brewfile...'
brew bundle dump --force --describe --file=$DOTFILES/brew/Brewfile

echo "Dump completed 🚀🎉😎"
