#!/bin/bash
# Install Rofi, set the shortcuts (ubuntu): windows key + space to rofi drun, alt + tab to rofi window switcher
sudo apt install rofi -y

# Set the shortcuts for rofi (by hand, going to Settings > Keyboard Shortcuts)
# "rofi -show drun" "<Super>space"
# "rofi -show window" "<Alt>Tab"

# Do a symbolic link to the rofi config file from this folder
mkdir -p ~/.config/rofi
ln -sf "$(pwd)/config.rasi" ~/.config/rofi/config.rasi

# Set the catppuccin theme for rofi
git clone https://github.com/catppuccin/rofi.git ~/.config/rofi/catppuccin-themes
# copy the catppuccin-default.rasi and catppuccin-mocha.rasi theme to the rofi config folder
cp ~/.config/rofi/catppuccin-themes/catppuccin-default.rasi ~/.config/rofi/
cp ~/.config/rofi/catppuccin-themes/catppuccin-mocha.rasi ~/.config/rofi/

