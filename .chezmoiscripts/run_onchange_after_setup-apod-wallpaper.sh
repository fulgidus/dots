#!/bin/bash

# SDDM theme
SDDM_CONF="/etc/sddm.conf.d/caelestia-sddm.conf"
if [ ! -f "$SDDM_CONF" ]; then
    printf '[Theme]\nCurrent=caelestia\n' | sudo tee "$SDDM_CONF" >/dev/null
fi

# Caelestia: fixed tokyo-night scheme
if command -v caelestia &>/dev/null; then
    caelestia scheme set -n tokyonight -f medium -m dark
fi

# Enable timers
systemctl --user daemon-reload
systemctl --user enable --now apod-fetch.timer
systemctl --user enable --now apod-wallpaper.timer
