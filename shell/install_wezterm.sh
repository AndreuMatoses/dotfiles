#!/bin/bash
# Install WezTerm terminal emulator and create a symbolic link to the config file

# add the APT repository for WezTerm
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

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

# Update the package list and install WezTerm
sudo apt update
sudo apt install wezterm -y

# Create the configuration directory if it doesn't exist and a symbolic link to the config file
mkdir -p ~/.config/wezterm
ln -sf $(pwd)/wezterm.lua ~/.config/wezterm/wezterm.lua
echo "WezTerm configuration file link has been created at ~/.config/wezterm/wezterm.lua."

# Change the default keyboard shortcut to open wezterm instead
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal ''
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Launch WezTerm'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'wezterm'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control><Alt>t'
