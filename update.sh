#!/bin/bash
#
# Factorio server binary update script
#
# Uses Factorio latest binary link, parses redirect for latest version, downloads if neccessary.
#
# TODO: support downloads of specific versions
#
fullurl="$(curl -I https://factorio.com/get-download/latest/headless/linux64 | grep -oP '^location: \K.*')"
file="$(basename "${fullurl%%\?*}")"
_suffix="${file##factorio_headless_x64_}"
version="${_suffix%%.tar.xz}"

echo >&2 "Factorio latest version: $version"

outdir="/usr/local/factorio/versions/$version"
if [[ ! -d "$outdir" ]]; then
    mkdir -p "$outdir"
    pushd "$outdir" || exit 1
    curl -L  "$fullurl" | tar --strip 1 -xJvf -
    echo >&2 "version $version installed to $outdir"
    popd || exit 1
fi

ln -sf "$outdir" /usr/local/factorio/versions/latest
