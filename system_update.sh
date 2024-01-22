#!/bin/bash



sudo pacman -Syu | tee ~/etc/updates/$(date -I)

