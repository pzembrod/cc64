#!/bin/bash
set -e

test -n "${CC64TARGET}" || export CC64TARGET=c64

testbinary="${1}"
test -n "${testbinary}" || exit 1

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
targetfiles="$(realpath --relative-to="$PWD" "${testdir}/${CC64TARGET}files")"

keybuf='open1,8,15,"s0:notdone":close1'

export OUTFILES="${testbinary}.out"
export CBMFILES="${targetfiles}"
export AUTOSTARTDIR="${targetfiles}"
"${emulatordir}/run-in-${CC64TARGET}emu.sh" "${testbinary}" "${keybuf}"
