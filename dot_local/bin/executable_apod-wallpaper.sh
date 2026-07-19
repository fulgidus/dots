#!/bin/bash
set -euo pipefail

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/apod-wallpapers"
INDEX="$CACHE/index.json"
CURRENT="$CACHE/current.jpg"
SDDM_SYMLINK="/usr/share/sddm/themes/caelestia/assets/background"
RETENTION_AGE=$((7 * 86400))
NASA_API_KEY="${NASA_API_KEY:-}"
FETCH_COUNT=5

mkdir -p "$CACHE"

cmd_fetch() {
    [ -z "$NASA_API_KEY" ] && { echo "NASA_API_KEY not set" >&2; exit 1; }
    [ ! -f "$INDEX" ] && echo '{}' > "$INDEX"

    local response
    response=$(curl -s --connect-timeout 5 --max-time 30 \
        "https://api.nasa.gov/planetary/apod?api_key=$NASA_API_KEY&count=$FETCH_COUNT&thumbs=true") || return 0

    echo "$response" | jq -c '.[]' 2>/dev/null | while read -r item; do
        local media_type date hdurl title explanation copyright
        media_type=$(echo "$item" | jq -r '.media_type // ""')
        [ "$media_type" != "image" ] && continue

        date=$(echo "$item" | jq -r '.date // ""')
        hdurl=$(echo "$item" | jq -r '.hdurl // .url // ""')
        title=$(echo "$item" | jq -r '.title // ""')
        explanation=$(echo "$item" | jq -r '.explanation // ""')
        copyright=$(echo "$item" | jq -r '.copyright // ""')
        [ -z "$hdurl" ] && continue

        local tmpfile hash ext filename
        tmpfile=$(mktemp)
        curl -sL --max-time 60 -o "$tmpfile" "$hdurl" || { rm -f "$tmpfile"; continue; }

        hash=$(sha256sum "$tmpfile" | cut -d' ' -f1)
        ext="${hdurl##*.}"; ext="${ext,,}"
        case "$ext" in jpg|jpeg|png|webp|gif) ;; *) ext="jpg" ;; esac
        filename="apod_${date}_${hash:0:12}.$ext"

        jq -e ".\"sha256:$hash\"" "$INDEX" >/dev/null 2>&1 && { rm -f "$tmpfile"; continue; }
        [ -f "$CACHE/$filename" ] && { rm -f "$tmpfile"; continue; }

        mv "$tmpfile" "$CACHE/$filename"
        local filesize; filesize=$(stat -c%s "$CACHE/$filename" 2>/dev/null || echo 0)
        local now; now=$(date +%s)

        jq --arg key "sha256:$hash" \
           --arg date "$date" --arg title "$title" \
           --arg explanation "$explanation" --arg copyright "$copyright" \
           --arg hdurl "$hdurl" --arg filename "$filename" \
           --argjson fetched_at "$now" --argjson size "$filesize" \
           '.[$key] = {date: $date, title: $title, explanation: $explanation, copyright: $copyright, hdurl: $hdurl, media_type: "image", filename: $filename, fetched_at: $fetched_at, size: $size}' \
           "$INDEX" > "${INDEX}.tmp" && mv "${INDEX}.tmp" "$INDEX"
    done
}

cmd_rotate() {
    [ ! -f "$INDEX" ] && { echo "No index found" >&2; exit 1; }

    local now cutoff chosen
    now=$(date +%s)
    cutoff=$((now - RETENTION_AGE))

    chosen=$(jq -r --argjson cutoff "$cutoff" '
        [to_entries[] | select(.value.fetched_at > $cutoff)]
        | if length == 0 then empty
          else .[(now | floor) % length]
          | .value.filename
          end' "$INDEX")

    if [ -z "$chosen" ] || [ ! -f "$CACHE/$chosen" ]; then
        chosen=$(find "$CACHE" -maxdepth 1 -type f \( -name 'apod_*.jpg' -o -name 'apod_*.png' \) \
            ! -name 'current.jpg' -mtime -$((RETENTION_AGE / 86400)) 2>/dev/null | shuf -n1)
        chosen=$(basename "${chosen:-}" 2>/dev/null || echo "")
    fi

    if [ -n "$chosen" ] && [ -f "$CACHE/$chosen" ]; then
        cp "$CACHE/$chosen" "$CURRENT"
        command -v caelestia &>/dev/null && caelestia wallpaper -f "$CURRENT"
    fi

    # cleanup expired index entries
    jq --argjson cutoff "$cutoff" '
        [to_entries[] | select(.value.fetched_at > $cutoff)]
        | from_entries' "$INDEX" > "${INDEX}.tmp" && mv "${INDEX}.tmp" "$INDEX"

    # cleanup expired files
    find "$CACHE" -maxdepth 1 -type f -name 'apod_*' ! -name 'current.jpg' \
        -mtime +$((RETENTION_AGE / 86400)) -delete 2>/dev/null || true
}

cmd_sddm_symlink() {
    if [ -L "$SDDM_SYMLINK" ] && [ "$(readlink "$SDDM_SYMLINK")" = "$CURRENT" ]; then
        echo "SDDM symlink OK"
        return 0
    fi
    echo "SDDM symlink missing or wrong. Run:"
    echo "  sudo rm -f /usr/share/sddm/themes/caelestia-sddm-locklike/assets/background.png"
    echo "  sudo ln -sf $CURRENT $SDDM_SYMLINK"
}

case "${1:-}" in
    fetch) cmd_fetch ;;
    rotate) cmd_rotate ;;
    sddm-symlink) cmd_sddm_symlink ;;
    *) echo "Usage: $0 {fetch|rotate|sddm-symlink}" >&2; exit 1 ;;
esac
