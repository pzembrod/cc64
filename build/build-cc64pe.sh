#!/bin/bash
set -e

builddir="$(dirname "${BASH_SOURCE[0]}")"
basedir="$(realpath --relative-to="$PWD" "${builddir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"

platform="$1"

# test -n "$target" && rm -f "${basedir}/cbmfiles/${target}"

keybuf="include cc64pe-main.fth\nsaveall cc64pe\ndos s0:notdone\n"

PLATFORM="${platform}" \
  "${emulatordir}/run-in-vice.sh" "vf-build-base" "${keybuf}"
