#!/usr/bin/env python3

import sys
import os
import subprocess
import json
from pathlib import Path
import datetime
import re

WALLPAPER_DIR = Path.home() / "Pictures" / "Wallpapers"
HYPRPAPER_CONF = Path.home() / ".config" / "hypr" / "hyprpaper.conf"
HYPRLOCK_CONF = Path.home() / ".config" / "hypr" / "hyprlock.conf"

args = sys.argv[1:]
if not args:
    print("Usage: set-wallpaper.py <wallpaper1> [wallpaper2] [...]")
    sys.exit(1)

try:
    result = subprocess.run(["hyprctl", "monitors", "-j"], capture_output=True, text=True, check=True)
    monitors_json = json.loads(result.stdout)
    monitors = [m["name"] for m in monitors_json]
except Exception as e:
    print("Cannot get monitors list: ", e)
    sys.exit(1)

wallpapers = []
for arg in args:
    path = Path(arg)
    if not path.is_absolute():
        path = WALLPAPER_DIR / arg
    if not path.is_file():
        print(f"Wallpaper is not found: {path}")
        sys.exit(2)
    wallpapers.append(str(path))

path = Path(HYPRPAPER_CONF)
if path.is_file():
    with open(HYPRPAPER_CONF, "w") as conf:
        conf.write(f"# Auto generated {datetime.datetime.now()}\n")
        for i, monitor in enumerate(monitors):
            wallpaper = wallpapers[i % len(wallpapers)]
            conf.write(f"preload = {wallpaper}\n")
            conf.write(f"wallpaper = {monitor}, {wallpaper}\n")

    print("hyprpaper.conf is updated!")

    subprocess.run(["pkill", "-f", "hyprpaper"])
    subprocess.Popen(["hyprpaper"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print("hyprpaper is reloaded")

path = Path(HYPRLOCK_CONF)
if path.is_file():
    config_file = Path(HYPRLOCK_CONF).expanduser()
    content = config_file.read_text()

    def replace_wallpaper(match):
        block = match.group(0)
        new_block = re.sub(r'(?m)^\s*path\s*=\s*.*$', f'    path = {wallpapers[0]}', block)
        return new_block
    
    new_content = re.sub(
        r'(?ms)background\s*{.*?}',
        replace_wallpaper,
        content
    )

    config_file.write_text(new_content)
    print("hyprlock.conf is updated!")