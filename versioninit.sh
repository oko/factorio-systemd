#!/bin/bash
set -euxo pipefail
version="${1:-latest}"

if ! id -un factorio; then
	useradd -r factorio
fi

vdir="/usr/local/factorio/versions/$version"

if [[ ! -d "$vdir" ]]; then
	echo >&2 "ERROR: version $version not installed to $vdir"
	exit 2
fi

if [[ ! -f "$vdir/config/config.ini" ]]; then
	td="$(mktemp -d)"
	pushd "$td"
	"$vdir/bin/x64/factorio" --create test.zip
	popd "$td"
fi
