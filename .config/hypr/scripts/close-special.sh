#!/bin/bash

ACTIVE_WS=$(hyprctl activewindow -j | jq -r '.workspace.name')

if [[ "$ACTIVE_WS" == special:* ]]; then
  ws_name="${ACTIVE_WS#special:}"
  hyprctl dispatch togglespecialworkspace "$ws_name"
fi
