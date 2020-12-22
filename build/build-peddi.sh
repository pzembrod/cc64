#!/bin/bash
set -e

platform="$1"

builddir="$(dirname "${BASH_SOURCE[0]}")"
basedir="$(realpath --relative-to="$PWD" "${builddir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${platform}files")"
logfile="${cbmfiles}/peddi.log"

rm -f "${cbmfiles}/peddi"
rm -f "${logfile}"

keybuf="include peddi-main.fth\nsaveall peddi\ndos s0:notdone\n"

export OUTFILES="peddi peddi.log"
"${emulatordir}/run-in-${platform}emu.sh" "vf-build-base" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep -F 'compile successful' || \
  (echo "check logfile ${logfile}" && exit 1)
