#!/bin/bash
set -e

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
HOSTFILES="$(realpath --relative-to="$PWD" "${testdir}/${CC64HOST}files")"
export HOSTFILES

"${emulatordir}/compile-in-emu.sh" "$@"
