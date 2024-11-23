#!/bin/bash

# Set keyboard repeat interval and delay
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

# Change GNOME theme to dark. Default is 'Yaru-dark', Adwaita
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'
