#!/bin/bash
set -euxo pipefail
instance="$1"
version="${FACTORIO_VERSION:-latest}"

if ! id -un factorio; then
  useradd -r factorio
fi

idir="/var/lib/factorio/$instance"
cdir="/etc/factorio/$instance"
vdir="/usr/local/factorio/versions/$version"

if [[ ! -d "$vdir" ]]; then
  echo >&2 "ERROR: version $version not installed to $vdir"
  exit 2
fi

mkdir -p "$idir" "$cdir"

mapgencfg="$cdir/map-gen-settings.json"
if [[ ! -f "$mapgencfg" ]]; then
  cp "$vdir/data/map-gen-settings.example.json" "$mapgencfg"
fi

mapcfg="$cdir/map-settings.json"
if [[ ! -f "$mapcfg" ]]; then
  cp "$vdir/data/map-settings.example.json" "$mapcfg"
fi

servercfg="$cdir/server-settings.json"
if [[ ! -f "$servercfg" ]]; then
  cp "$vdir/data/server-settings.example.json" "$servercfg"
fi

config="$cdir/config.ini"
if [[ ! -f "$config" ]]; then
  cp "$vdir/config/config.ini" "$config"
  sed -i 's/write-data=.*/write-data=data/' "$config"
fi

admins="$cdir/server-adminlist.json"
if [[ -f "$admins" ]]; then
  cp "$admins" "$idir/data/server-adminlist.json"
fi

pushd "$idir"
if [[ ! -f "$idir/game.zip" ]]; then
  /usr/local/factorio/versions/latest/bin/x64/factorio \
    --config "$cdir/config.ini" \
    --map-gen-settings "$mapgencfg" \
    --map-settings "$mapcfg" \
    --server-settings "$servercfg" \
    --create ./game.zip
fi
popd

chown -R factorio:factorio "$idir"
