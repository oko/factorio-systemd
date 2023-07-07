#!/bin/bash
#
# Factorio server binary update script
#
# Uses Factorio latest binary link, parses redirect for latest version, downloads if neccessary.
#
# TODO: support downloads of specific versions
#
version="${1:-""}"
if [[ -z "$version" ]]; then
	url="https://factorio.com/get-download/latest/headless/linux64"
else
	url="https://www.factorio.com/get-download/$version/headless/linux64"
fi
fullurl="$(curl -I "$url" | grep -oP '^location: \K.*' | python -c 'import sys; print(sys.stdin.read().strip())')"
echo >&2 "full url: $fullurl"
file="$(basename "${fullurl%%\?*}")"
_suffix="${file##factorio_headless_x64_}"
version="${_suffix%%.tar.xz}"

echo >&2 "Factorio latest version: $version"
echo >&2 "Download URL: '$fullurl'"

[[ -n "$version" ]] || exit 1

outdir="/usr/local/factorio/versions/$version"
if [[ ! -d "$outdir" ]]; then
    mkdir -p "$outdir"
    pushd "$outdir" || exit 1
    if ! curl -L  "$fullurl" | tar --strip 1 -xJvf -; then
			echo >&2 "version $version failed"
			rm -rf "$outdir"
		fi
    echo >&2 "version $version installed to $outdir"
    popd || exit 1
fi

oldver="$(basename $(readlink /usr/local/factorio/versions/latest))"
if [[ "$oldver" != "$version" ]]; then
	ln -sfT "$outdir" /usr/local/factorio/versions/latest
	systemctl restart 'factorio@*.service'
fi
