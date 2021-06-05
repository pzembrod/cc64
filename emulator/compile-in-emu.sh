#!/bin/bash
set -e

program="${1}"

test -n "${CC64HOST}" || export CC64HOST=c64
test -n "${OUTFILES}" || export OUTFILES="${program} ${program}.log"

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${emulatordir}/basedir.shlib"
hostfiles="$(realpath --relative-to="$PWD" "${basedir}/${CC64HOST}files")"

rm -f "${hostfiles}/${program}.log"
keybuf="logfile ${program}.log\ncc ${program}.c\nlogclose\ndos s0:notdone"

export CBMFILES="${hostfiles}"
"${emulatordir}/run-in-${CC64HOST}emu.sh" cc64 "${keybuf}"
