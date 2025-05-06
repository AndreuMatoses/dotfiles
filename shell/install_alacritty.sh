#!/bin/bash

# Install Alacritty terminal emulator and create a symbolic link to the config file
sudo snap install alacritty --classic
mkdir -p ~/.config/alacritty
ln -sf $(pwd)/alacritty.toml ~/.config/alacritty/alacritty.toml

# Install JetBrains Mono nerd font (if not already installed)
FONT_DIR=~/.local/share/fonts/JetBrainsMono
if [ -d "$FONT_DIR" ] && [ "$(ls -A $FONT_DIR)" ]; then
    echo "JetBrains Mono font is already installed."
else
    mkdir -p ~/.local/share/fonts
    wget -O JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip JetBrainsMono.zip -d ~/.local/share/fonts
    rm JetBrainsMono.zip
    fc-cache -fv
    echo "JetBrains Mono font installed successfully."
fi

echo "Alacritty and font setup complete. Please restart your terminal or run 'fc-cache -fv' to load the new font."