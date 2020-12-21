#!/bin/bash
set -e

platform="$1"

builddir="$(dirname "${BASH_SOURCE[0]}")"
basedir="$(realpath --relative-to="$PWD" "${builddir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${platform}files")"
logfile="${cbmfiles}/cc64pe.log"

rm -f "${cbmfiles}/cc64pe"
rm -f "${logfile}"

keybuf="include cc64pe-main.fth\nsaveall cc64pe\ndos s0:notdone\n"

PLATFORM="${platform}" \
  "${emulatordir}/run-in-vice.sh" "vf-build-base" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep -F 'compile successful' || \
  (echo "check logfile ${logfile}" && exit 1)
