#!/bin/bash
set -e

test -n "${CC64HOST}" || export CC64HOST=c64
test -n "${OUTFILES}" || export OUTFILES=""

testname="${1}"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
hostfiles="$(realpath --relative-to="$PWD" "${testdir}/${CC64HOST}files")"

rm -f "${hostfiles}/${testname}.log"
keybuf="logfile ${testname}.log\ncc ${testname}.c\nlogclose\ndos s0:notdone"

export CBMFILES="${hostfiles}"
"${emulatordir}/run-in-${CC64HOST}emu.sh" cc64 "${keybuf}"
