#!/bin/bash
set -euxo pipefail
cd "$(dirname "$0")/.."

color="#f37736"

rm -rf /tmp/nextcloud-neon
mkdir -p /tmp/nextcloud-neon

function parse_icons_css() {
    icons_css_url="https://raw.githubusercontent.com/nextcloud/server/master/dist/icons.css"
    icons_css_file="/tmp/icons.css"
    wget "$icons_css_url" -O "$icons_css_file"
    
    icon_mapping=$(awk -F'[()]' '/background-image/ {print $2,$4}' "$icons_css_file")
    
    echo "$icon_mapping" > "/tmp/icon_mapping.txt"
}
function get_svg_url() {
    icon_name="$1"
    icon_svg_url=$(grep "$icon_name" /tmp/icon_mapping.txt | awk '{print $2}')
    echo "$icon_svg_url"
}

function download_icon_svg() {
    icon_name="$1"
    icon_svg_url=$(get_svg_url "$icon_name")
    wget "$icon_svg_url" -O "/tmp/$icon_name.svg"
}


function copy_app_svg() {
  id="$1"
  path="$2"
  target="packages/neon/neon_$id/assets/app.svg"
  if [ -f "$path/img/app.svg" ]; then
    cp "$path/img/app.svg" "$target"
  elif [ -f "$path/img/$id.svg" ]; then
    cp "$path/img/$id.svg" "$target"
  else
    echo "Can not find icon for $id in $path"
    exit 1
  fi
  sed -i "s/fill=\"#[^\"]*\"/fill=\"$color\"/g" "$target"
}

function export_icon() {
    source="$1"
    size="$2"
    destination="$3"
    inkscape "$source" -o "$destination" -w "$size" -h "$size"
}

function export_mipmap_icon() {
    source="$1"
    size="$2"
    name="$3"
    dpi="$4"
    export_icon "$source" "$size" "android/app/src/main/res/mipmap-${dpi}dpi/$name.png"
}

function export_mipmap_icon_all() {
    source="$1"
    name="$2"
    export_mipmap_icon "$source" 72  "$name" h    &
    export_mipmap_icon "$source" 48  "$name" m    &
    export_mipmap_icon "$source" 96  "$name" xh   &
    export_mipmap_icon "$source" 144 "$name" xxh  &
    export_mipmap_icon "$source" 192 "$name" xxxh &
    wait
}

function precompile_assets() {
  fvm dart run vector_graphics_compiler --input-dir assets/
  find assets/ -name "*.svg" -exec rm {} \;
}
parse_icons_css

wget https://raw.githubusercontent.com/Templarian/MaterialDesign/master/svg/cable-data.svg -O assets/logo.svg
sed -i "s/<path /<path fill=\"$color\" /g" assets/logo.svg

wget https://raw.githubusercontent.com/nextcloud/promo/master/nextcloud-logo-inverted.svg -O packages/neon_framework/assets/logo_nextcloud.svg

icons_dir="packages/neon_framework/assets/icons/server/"
rm -rf "$icons_dir"
mkdir -p "$icons_dir"

shopt -s extglob
for file in external/nextcloud-server/{core/img/*,apps/*/img}/!(app|app-dark).svg; do
  name="$(basename "$file" | sed "s/.svg$//" | sed "s/-dark$//" | sed "s/-white$//").svg"
  if ! grep "<image " "$file"; then
    cp -u "$file" "$icons_dir/$name"
  fi
done

(
  cd packages/neon_framework
  precompile_assets
)

copy_app_svg dashboard external/nextcloud-server/apps/dashboard
copy_app_svg files external/nextcloud-server/apps/files
copy_app_svg news external/nextcloud-news
copy_app_svg notes external/nextcloud-notes
copy_app_svg notifications external/nextcloud-notifications
copy_app_svg talk external/nextcloud-spreed

(
  cd packages/app

  cp ../../assets/logo.svg assets/logo.svg

  # Splash screens
  inkscape assets/logo.svg -o img/splash_icon.png -w 768 -h 768 # 768px at xxxhdpi is 192dp
  convert -size 1152x1152 xc:none img/splash_icon.png -gravity center -composite img/splash_icon_android_12.png # 1152px at xxxhdpi is 288dp
  exiftool -overwrite_original -all= img/splash_icon_android_12.png # To remove timestamps

  # Android launcher icons
  export_mipmap_icon_all "assets/logo.svg" "ic_launcher" &
  for path in ../neon/neon_*; do
    export_mipmap_icon_all "$path/assets/app.svg" "app_$(basename "$path" | sed "s/^neon_//")" &
  done
  wait

  export_icon "assets/logo.svg" 192 "web/icons/Icon-192.png"
  export_icon "assets/logo.svg" 512 "web/icons/Icon-512.png"
  export_icon "assets/logo.svg"  16 "web/favicon.png"

  fvm dart run flutter_native_splash:create
  fvm dart run sqflite_common_ffi_web:setup --force

  precompile_assets
  cp ../../assets/logo.svg assets/logo.svg
)

for path in packages/neon/neon_*; do
  (
    cd "$path"
    precompile_assets
  )
done
