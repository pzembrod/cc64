#!/bin/bash
set -e

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
c64files="$(realpath --relative-to="$PWD" "${testdir}/c64files")"

run=""
if [ -n "$1" ]
then
  autostart="${testdir}/$1.T64"
  run="-autostart $autostart"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${c64files}" \
  -chargen "${emulatordir}/c-chargen" \
  $run
