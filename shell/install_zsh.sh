#!/bin/bash

# Install zsh
sudo apt install zsh -y

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions and zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# # Install Dracula theme for ZSH
# git clone https://github.com/dracula/zsh.git ${ZSH:-~/.oh-my-zsh}/themes/dracula
# ln -s ${ZSH:-~/.oh-my-zsh}/themes/dracula/dracula.zsh-theme ${ZSH:-~/.oh-my-zsh}/themes/dracula.zsh-theme
# # Modify the theme to show full path of current working directory
# sed -i 's/DRACULA_DISPLAY_FULL_CWD=${DRACULA_DISPLAY_FULL_CWD:-0}/DRACULA_DISPLAY_FULL_CWD=${DRACULA_DISPLAY_FULL_CWD:-1}/' ${ZSH:-~/.oh-my-zsh}/themes/dracula/dracula.zsh-theme

# Install Starship (prompt)
curl -sS https://starship.rs/install.sh | sh

# Install tmux
sudo apt install tmux -y
# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Create symlinks for configuration files
ln -sf "$(pwd)/.zshrc" ~/.zshrc
ln -sf "$(pwd)/.tmux.conf" ~/.tmux.conf

# Set zsh as the default shell
chsh -s $(which zsh)

# say what to do to load the new shell and plugins
echo "Please restart your terminal or run 'source ~/.zshrc' to load the new shell and plugins."
echo "To install the tmux plugins, run 'tmux' and then press 'prefix + I' (default prefix is Ctrl + b)."
