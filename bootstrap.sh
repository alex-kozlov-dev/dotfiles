#! /usr/bin/env bash

DOTFILES=$HOME/.dotfiles

function prompt_to_continue() {
  local input=""
  until [[ "$input" == "done" ]]
  do
    read -p "Enter \"done\" to continue: " input
  done
}

# https://stackoverflow.com/a/30547074
function start_sudo() {
  sudo -v
  ( while true; do sudo -v; sleep 50; done; ) &
  SUDO_PID="$!"
  trap stopsudo SIGINT SIGTERM
}
function stop_sudo() {
  kill "$SUDO_PID"
  trap - SIGINT SIGTERM
  sudo -k
}

start_sudo

# Install xcode cli tools
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
   test -d "${xpath}" && test -x "${xpath}" ; then
   echo 'Xcode CLT already installed'
else
  echo 'Install Xcode CLT in opened window'
  xcode-select --install
  sleep 1
  prompt_to_continue
fi

# Init Github SSH
if [[ -f "$HOME/.ssh/id_rsa" ]]; then
  echo 'SSH key already exists'
else
  echo 'Generating SSH key...'
  ssh-keygen -t rsa -b 4096 -C "info@alexkozlov.dev" -f "$HOME/.ssh/id_rsa" -P ""
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_rsa"
fi

pbcopy < "$HOME/.ssh/id_rsa.pub"
echo "Public SSH key copied to clipboard"
echo "Open https://github.com/settings/keys and add key to profile"
prompt_to_continue

# Clone dotfiles repo
if [ -d $DOTFILES ] 
then
    echo "Dotfiles directory already exist, pulling"
    cd $DOTFILES
    git pull
    cd ~
else
    echo "Dotfiles do not exist, cloning"
    git clone git@github.com:alex-kozlov-dev/dotfiles.git $DOTFILES
fi

# Homebrew
source $DOTFILES/brew/install.sh
source $DOTFILES/brew/postinstall.sh

# Oh-My-Zsh
source $DOTFILES/zsh/install.sh
source $DOTFILES/zsh/custom.sh
source $DOTFILES/zsh/config.sh

exec zsh

# Node
source $DOTFILES/node/install.sh

# Python
source $DOTFILES/python/install.sh

stop_sudo

echo "Bootstrap completed 🚀🎉😎"
