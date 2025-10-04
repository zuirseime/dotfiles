#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $0 <app> <special workspace>"
  exit 1
fi

APP_CMD="$1"
WORKSPACE="$2"

APP_PROC=$(basename "$APP_CMD")

if ! pgrep -x "$APP_PROC" > /dev/null; then
  $APP_CMD &
  sleep 1
fi

hyprctl dispatch togglespecialworkspace "$WORKSPACE"
