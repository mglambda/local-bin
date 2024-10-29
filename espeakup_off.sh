#!/bin/bash

# Switches off espeakup and restarts the pipewire based sound system for a user.
# This needs to happen because sound devices would otherwise be owned by espeakup, leading to pipewire not being able to access them, and causing many weird and hard to diagnose sound bugs.
# It would be nice if this got fixed somehow and espeak could through pipewire, but alas this is at least a workaround.

echo "Shutting off espeakup and restarting pipewire. Be sure to type in the sudo password."
sudo systemctl stop espeakup
systemctl --user restart wireplumber pipewire pipewire-pulse
