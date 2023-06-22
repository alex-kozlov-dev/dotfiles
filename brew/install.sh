#! /usr/bin/env bash

sudo -v

# Install Homebrew
which -s brew
if [[ $? != 0 ]] ; then
  echo 'Homebrew not found. Installing...'
  echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo 'Homebrew already installed. Updating...'
  brew update
fi

brew install mas

# Ensure App Store login for mas
until (mas account > /dev/null);
do
  echo 'Open App Store app and sign in'

  until (mas account > /dev/null);
  do
    sleep 3
  done

  echo 'Thanks'
done

/usr/local/bin/brew bundle --no-upgrade --no-lock --file=$HOME/.dotfiles/brew/Brewfile
