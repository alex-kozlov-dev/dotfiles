#! /usr/bin/env bash

rm -rf "$HOME/Library/Preferences/com.vladalexa.MagicPrefs.plist"
ln -sf "$HOME/.dotfiles/magicprefs/config/com.vladalexa.MagicPrefs.plist" "$HOME/Library/Preferences/com.vladalexa.MagicPrefs.plist"
