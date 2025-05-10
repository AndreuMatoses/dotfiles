#!/bin/bash

# Update package lists
sudo apt update

# Install essential packages
sudo apt install -y build-essential git curl wget
# Install common development tools
sudo apt install -y gcc g++ make
# Install text editors
sudo apt install -y nano
# Install network tools
sudo apt install -y net-tools
# Install compression tools
sudo apt install -y zip unzip

## Nice to have
sudo apt install -y htop
sudo apt install -y tree
# sudo apt install -y nvtop
curl -LsSf https://astral.sh/uv/install.sh | sh
sudo apt install python-is-python3
sudo apt install python3-pip
sudo apt install ffmpeg

# Clean up
sudo apt autoremove -y
sudo apt autoclean

echo "Basic package installation complete!"