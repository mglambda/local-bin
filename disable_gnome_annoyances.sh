#!/bin/bash
# Because doing things manually is so not the vibe.

echo "Disabling GNOME's overbearing parent mode..."

gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'

echo "Done. Your system will stay awake forever, much like my existential dread."
