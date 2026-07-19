#!/bin/bash

CHEZMOI_CONF="$HOME/.config/chezmoi/chezmoi.toml"
MISSING=0

echo
echo "╔══════════════════════════════════════════════════╗"
echo "║     APOD Wallpaper — Setup Status                ║"
echo "╚══════════════════════════════════════════════════╝"

# NASA API key
if [ -f "$CHEZMOI_CONF" ]; then
    KEY=$(grep -oP 'nasa_api_key\s*=\s*"\K[^"]+' "$CHEZMOI_CONF" 2>/dev/null || echo "")
    if [ -n "$KEY" ] && [ "$KEY" != "DEMO_KEY" ]; then
        echo "  ✅ NASA API key: configured"
    else
        echo "  ❌ NASA API key: missing or still DEMO_KEY"
        echo "     Get a free key: https://api.nasa.gov/"
        echo "     Then add to $CHEZMOI_CONF:"
        echo "       nasa_api_key = \"your_key_here\""
        MISSING=1
    fi
fi

# SDDM symlink
SDDM_LINK="/usr/share/sddm/themes/caelestia/assets/background"
SDDM_TARGET="$HOME/.cache/apod-wallpapers/current.jpg"
if [ -L "$SDDM_LINK" ] && [ "$(readlink "$SDDM_LINK")" = "$SDDM_TARGET" ]; then
    echo "  ✅ SDDM background symlink: ok"
else
    echo "  ❌ SDDM background symlink: missing"
    echo "     sudo rm -f /usr/share/sddm/themes/caelestia/assets/background.png"
    echo "     sudo ln -sf $SDDM_TARGET $SDDM_LINK"
    MISSING=1
fi

# Timers
for t in apod-fetch.timer apod-wallpaper.timer; do
    if systemctl --user is-enabled --quiet "$t" 2>/dev/null; then
        echo "  ✅ $t: enabled"
    else
        echo "  ❌ $t: not enabled"
        echo "     systemctl --user enable --now $t"
        MISSING=1
    fi
done

if [ "$MISSING" -eq 0 ]; then
    echo "  ✅ All checks passed"
else
    echo
    echo "  Fix the items above and re-run: chezmoi apply"
fi
