#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
home_dir="${HOME:?HOME is not set}"
assets="$repo_root/assets"
firefox_profile="${FIREFOX_PROFILE:-default}"

rsync_excludes=(
  --exclude='.cache/'
  --exclude='Cache/'
  --exclude='cache2/'
  --exclude='startupCache/'
  --exclude='storage/'
  --exclude='storage-sync-v2/'
  --exclude='cookies.sqlite*'
  --exclude='logins.json'
  --exclude='key4.db'
  --exclude='cert9.db'
  --exclude='places.sqlite*'
  --exclude='favicons.sqlite*'
  --exclude='formhistory.sqlite*'
  --exclude='permissions.sqlite*'
  --exclude='sessionstore*'
  --exclude='webappsstore.sqlite*'
  --exclude='*.log'
  --exclude='*.lock'
  --exclude='*.tmp'
)

sync_dir() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  rsync -a --delete "${rsync_excludes[@]}" "$src" "$dst"
}

sync_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
}

sync_file "$home_dir/.gtkrc-2.0" "$assets/home/gtkrc-2.0"

sync_dir "$home_dir/.config/gtk-3.0/" "$assets/config/gtk-3.0/"
sync_dir "$home_dir/.config/gtk-4.0/" "$assets/config/gtk-4.0/"
sync_dir "$home_dir/.config/kitty/" "$assets/config/kitty/"
sync_dir "$home_dir/.config/mozilla/firefox/$firefox_profile/chrome/" \
  "$assets/config/mozilla/firefox/default/chrome/"

for file in \
  gtkrc \
  gtkrc-2.0 \
  kdeglobals \
  kded6rc \
  kiorc \
  ksplashrc \
  kwinrc \
  plasmashellrc \
  Trolltech.conf
do
  sync_file "$home_dir/.config/$file" "$assets/config/$file"
done

sync_dir "$home_dir/.config/kdedefaults/" "$assets/config/kdedefaults/"
sync_dir "$home_dir/.config/xsettingsd/" "$assets/config/xsettingsd/"

sync_dir "$home_dir/.local/share/plasma/desktoptheme/" "$assets/local/share/plasma/desktoptheme/"
sync_dir "$home_dir/.local/share/plasma/look-and-feel/" "$assets/local/share/plasma/look-and-feel/"
sync_dir "$home_dir/.local/share/aurorae/themes/Colorful-Dark-Aurorae-6/" \
  "$assets/local/share/aurorae/themes/Colorful-Dark-Aurorae-6/"
sync_dir "$home_dir/.local/share/aurorae/themes/Colorful-Dark-Color-Aurorae-6/" \
  "$assets/local/share/aurorae/themes/Colorful-Dark-Color-Aurorae-6/"
sync_dir "$home_dir/.local/share/aurorae/themes/Colorful-Blur-Dark-Aurorae-6/" \
  "$assets/local/share/aurorae/themes/Colorful-Blur-Dark-Aurorae-6/"
sync_dir "$home_dir/.local/share/color-schemes/" "$assets/local/share/color-schemes/"
sync_dir "$home_dir/.local/share/wallpapers/HermesCode/" "$assets/local/share/wallpapers/HermesCode/"

if find "$assets" -iregex '.*\(cookies\.sqlite.*\|logins\.json\|key4\.db\|cert9\.db\|places\.sqlite.*\|favicons\.sqlite.*\|formhistory\.sqlite.*\|permissions\.sqlite.*\|sessionstore.*\|webappsstore\.sqlite.*\)' -print -quit | grep -q .; then
  echo "Refusing to finish: synced assets contain browser/runtime state files." >&2
  exit 1
fi

echo "Updated theme assets in $repo_root"
