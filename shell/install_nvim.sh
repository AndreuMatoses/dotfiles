#!/bin/bash

# Install new version of Neovim and the kickstart configuration: https://github.com/nvim-lua/kickstart.nvim

# Check if Neovim is already installed. If  so, remove as it is not the latest version
if command -v nvim &> /dev/null
then
    echo "Neovim is already installed. Removing old version..."
    sudo apt remove neovim -y
fi
# Install Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim -y

# Clone the kickstart configuration repository
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

echo "Neovim and kickstart configuration installed successfully!"
echo "Please run 'nvim' to start Neovim. Check the kickstart configuration at ~/.config/nvim/init.lua"