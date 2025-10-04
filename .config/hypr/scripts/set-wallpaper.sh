#!/bin/zsh

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

monitors=($(hyprctl monitors -j | jq -r '.[].name'))
monitor_count=${#monitors[@]}
argument_count=$#

if [ "$argument_count" -lt 1 ]; then
    echo "Usage: $0 <wallpaper1> [wallpaper2] [...]"
    exit 1
fi

wallpapers=()
for wallpaper in "$@"; do
    [[ "$wallpaper" != /* ]] && wallpaper="$WALLPAPER_DIR/$wallpaper"e
    if [ ! -f "$wallpaper" ]; then
        echo "Wallpaper [$wallpaper] is not found"
        exit 2
    fi
    wallpapers+=("$wallpaper")
done

echo "# Auto generated $(date)" > "$HYPRPAPER_CONF"

for i in "${!monitors[@]}"; do
    monitor="${monitors[$i]}"
    idx=$(( i % ${#wallpapers[@]} ))
    wallpaper="${wallpapers[$idx]}"

    echo "preload = $wallpaper" >> "$HYPRPAPER_CONF"
    echo "wallpaper = $monitor, $wallpaper" >> "$HYPRPAPER_CONF"
done

pkill -f hyprpaper && hyprpaper & disown
echo "Wallpapers are updated"