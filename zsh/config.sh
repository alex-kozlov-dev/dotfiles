#! /usr/bin/env bash

rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

rm -rf $HOME/.zprofile
ln -s $HOME/.dotfiles/zsh/.zprofile $HOME/.zprofile
