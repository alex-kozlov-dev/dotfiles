#! /usr/bin/env bash

if [ -d "$ZSH" ]; then
  echo "Oh My Zsh is already installed. Skipping.."
else
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
