#!/usr/bin/env python3
import requests
import json

GEOIP_URL = "https://ipinfo.io/json"
ALERTS_URL = "https://sirens.in.ua/api/v1/state"

def normalize(region):
    """Нормалізує назву регіону: робить lowercase і прибирає апострофи"""
    return region.lower().replace("'", "")

def get_region_name():
    try:
        geo = requests.get(GEOIP_URL, timeout=5).json()
        return geo.get("region")  # e.g., "Dnipropetrovsk"
    except:
        return None

def get_alert(region_en_name):
    try:
        data = requests.get(ALERTS_URL, timeout=5).json()
        normalized_target = normalize(region_en_name)
        for r in data["regions"]:
            if normalize(r["name"]) == normalized_target:
                return r["alarm"], r["name"]
        return None, None
    except:
        return None, None

def main():
    region = get_region_name()
    if not region:
        print(json.dumps({"text": "🌐 Регіон?", "class": "warning"}))
        return

    alarm, region_display = get_alert(region)
    if region_display is None:
        print(json.dumps({"text": f"{region} ❓", "class": "warning"}))
    elif alarm:
        print(json.dumps({"text": f"🚨 {region_display}", "class": "alert"}))
    else:
        print(json.dumps({"text": f"✅ {region_display}", "class": "normal"}))

if __name__ == "__main__":
    main()
