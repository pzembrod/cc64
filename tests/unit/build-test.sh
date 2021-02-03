#!/bin/bash
set -e

platform="c64"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.sh"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
cbmfiles="$(realpath --relative-to="$PWD" "${testdir}/${platform}files")"
logfile="${cbmfiles}/cc64-test.log"

rm -f "${logfile}"

keybuf="include cc64-test.fth\ndos s0:notdone\n"

export OUTFILES="cc64-test.log"
export CBMFILES="${cbmfiles}"
"${emulatordir}/run-in-${platform}emu.sh" "vf-build-base" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep -F 'test successful' || \
  (echo "check logfile ${logfile}" && exit 1)
