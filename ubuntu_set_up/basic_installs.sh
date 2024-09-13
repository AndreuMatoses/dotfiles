#!/bin/bash

# Update package lists
sudo apt update

# Install essential packages
sudo apt install -y build-essential git curl wget
# Install common development tools
sudo apt install -y gcc g++ make
# Install text editors
sudo apt install -y vim nano
# Install network tools
sudo apt install -y net-tools
# Install compression tools
sudo apt install -y zip unzip

# Install additional packages as needed

# Clean up
sudo apt autoremove -y
sudo apt autoclean

echo "Basic package installation complete!"