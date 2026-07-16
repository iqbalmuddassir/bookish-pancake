#!/usr/bin/env bash
# Capture light/dark Android marketing screenshots from a connected physical device.
# Usage:
#   1. Enable Developer options → USB debugging
#   2. Plug in the phone and accept the RSA prompt
#   3. Install/run the app (debug or release)
#   4. From repo root: bash docs/quran-education-app/android/capture-device-screenshots.sh
set -euo pipefail

OUT="$(cd "$(dirname "$0")" && pwd)/assets"
mkdir -p "$OUT"
REMOTE_CAP=/sdcard/qe_cap.png

# Prefer a physical device over emulator
DEVICE="$(adb devices | awk '/\tdevice$/{print $1}' | rg -v '^emulator-' | head -1 || true)"
if [[ -z "${DEVICE}" ]]; then
  echo "No physical device found. Connected:"
  adb devices -l
  echo
  echo "Connect a phone with USB debugging enabled, then re-run."
  exit 1
fi

ADB=(adb -s "$DEVICE")
echo "Using device: $DEVICE ($("${ADB[@]}" shell getprop ro.product.model | tr -d '\r'))"

# Prefer release package, fall back to debug
if "${ADB[@]}" shell pm path com.mi.alquran >/dev/null 2>&1; then
  PKG=com.mi.alquran
elif "${ADB[@]}" shell pm path com.mi.alquran.debug >/dev/null 2>&1; then
  PKG=com.mi.alquran.debug
else
  echo "App not installed. Install com.mi.alquran (or .debug) on the device first."
  exit 1
fi
echo "Using package: $PKG"

"${ADB[@]}" shell pm grant "$PKG" android.permission.ACCESS_COARSE_LOCATION >/dev/null 2>&1 || true
"${ADB[@]}" shell pm grant "$PKG" android.permission.POST_NOTIFICATIONS >/dev/null 2>&1 || true

validate_png() {
  python3 - "$1" <<'PY'
import sys
from PIL import Image
path = sys.argv[1]
im = Image.open(path)
im.verify()
im = Image.open(path)
print(f"  captured {path.split('/')[-1]} {im.size[0]}x{im.size[1]} ({path})")
PY
}

capture() {
  local name="$1"
  sleep 1.2
  # Pull via device file — more reliable than exec-out on foldables / multi-display
  "${ADB[@]}" shell screencap -d 0 -p "$REMOTE_CAP" 2>/dev/null \
    || "${ADB[@]}" shell screencap -p "$REMOTE_CAP"
  "${ADB[@]}" pull "$REMOTE_CAP" "$OUT/${name}.png" >/dev/null
  validate_png "$OUT/${name}.png"
}

open_home() {
  "${ADB[@]}" shell am start -W -n "$PKG/com.mi.alquran.view.menu.MenuActivity" >/dev/null
  sleep 1.8
}

dump_tap_hints() {
  "${ADB[@]}" shell uiautomator dump /sdcard/ui.xml >/dev/null
  "${ADB[@]}" shell cat /sdcard/ui.xml | python3 -c "
import re,sys
xml=sys.stdin.read()
want=('Quran Player','E-code','Prayer','Qibla')
for m in re.finditer(r'text=\"([^\"]+)\"[^>]*bounds=\"\\[(\\d+),(\\d+)\\]\\[(\\d+),(\\d+)\\]\"', xml):
    t,x1,y1,x2,y2=m.group(1),*map(int,m.groups()[1:])
    if any(w.lower() in t.lower() for w in want):
        print(f\"{t!r} -> tap {(x1+x2)//2} {(y1+y2)//2}\")
"
}

tap_label() {
  local label="$1"
  local coords
  coords="$("${ADB[@]}" shell uiautomator dump /sdcard/ui.xml >/dev/null; "${ADB[@]}" shell cat /sdcard/ui.xml | python3 -c "
import re,sys
label=sys.argv[1].lower()
xml=sys.stdin.read()
for m in re.finditer(r'text=\"([^\"]+)\"[^>]*bounds=\"\\[(\\d+),(\\d+)\\]\\[(\\d+),(\\d+)\\]\"', xml):
    t,x1,y1,x2,y2=m.group(1),*map(int,m.groups()[1:])
    if label in t.lower():
        print((x1+x2)//2, (y1+y2)//2)
        break
" "$label")"
  if [[ -z "$coords" ]]; then
    echo "  WARN: could not find UI label matching '$label'"
    return 1
  fi
  # shellcheck disable=SC2086
  "${ADB[@]}" shell input tap $coords
  return 0
}

capture_flow() {
  local mode="$1" # no | yes
  local suffix="$2" # light | dark
  echo "== $suffix (night=$mode) =="
  "${ADB[@]}" shell cmd uimode night "$mode" >/dev/null
  sleep 1.2
  open_home
  capture "home-${suffix}"

  if tap_label "urdu"; then
    sleep 2
    capture "player-${suffix}"
    "${ADB[@]}" shell input keyevent KEYCODE_BACK
    sleep 1
  fi

  open_home
  if tap_label "e-code"; then
    sleep 2
    capture "ecodes-${suffix}"
    "${ADB[@]}" shell input keyevent KEYCODE_BACK
    sleep 1
  fi

  open_home
  if tap_label "prayer time"; then
    # Allow location / network prayer times to settle
    sleep 5
    capture "prayer-${suffix}"
    "${ADB[@]}" shell input keyevent KEYCODE_BACK
    sleep 1
  fi

  open_home
  if tap_label "qibla"; then
    sleep 3
    capture "qibla-${suffix}"
    "${ADB[@]}" shell input keyevent KEYCODE_BACK
    sleep 1
  else
    echo "  Qibla tile not visible (may be remote-config hidden); skip qibla-${suffix}"
  fi
}

echo "Home UI labels:"
open_home
dump_tap_hints || true

capture_flow no light
capture_flow yes dark

"${ADB[@]}" shell cmd uimode night no >/dev/null || true
"${ADB[@]}" shell rm "$REMOTE_CAP" >/dev/null 2>&1 || true
echo
echo "Done. Files in: $OUT"
ls -la "$OUT"/*.png
