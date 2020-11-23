#!/bin/bash
set -e

platform="$1"

builddir="$(dirname "${BASH_SOURCE[0]}")"
basedir="$(realpath --relative-to="$PWD" "${builddir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${platform}files")"

rm -f "${cbmfiles}/cc64"

keybuf="include cc64-main.fth\nsaveall cc64\ndos s0:notdone\n"

"${emulatordir}/run-in-${platform}emu.sh" "vf-build-base" "${keybuf}"
