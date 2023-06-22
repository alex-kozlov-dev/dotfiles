#! /usr/bin/env bash

CUSTOM_PATH=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
rm -rf $CUSTOM_PATH/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM_PATH/plugins/zsh-autosuggestions"
rm -rf $CUSTOM_PATH/prompt/pure
git clone https://github.com/sindresorhus/pure.git "$CUSTOM_PATH/prompt/pure"
rm -rf $CUSTOM_PATH/plugins/autoupdate
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "$CUSTOM_PATH/plugins/autoupdate"
