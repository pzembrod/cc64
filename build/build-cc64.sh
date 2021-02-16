#!/bin/bash
set -e

platform="$1"

builddir="$(dirname "${BASH_SOURCE[0]}")"
basedir="$(realpath --relative-to="$PWD" "${builddir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${platform}files")"
logfile="${cbmfiles}/cc64.log"

rm -f "${cbmfiles}/cc64"
rm -f "${logfile}"

keybuf="include cc64-main.fth\nsaveall cc64\ndos s0:notdone"

export OUTFILES="cc64 cc64.log"
"${emulatordir}/run-in-${platform}emu.sh" "vf-build-base" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep -F 'compile successful' || \
  (echo "check logfile ${logfile}" && exit 1)
