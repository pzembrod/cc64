#!/bin/bash
set -e

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
c64files="$(realpath --relative-to="$PWD" "${testdir}/c64files")"

run=""
if [ -n "$1" ]
then
  ascii2petscii "${testdir}/notdone" "${c64files}/notdone"
  keybuf='open1,8,15,"s0:notdone":close1\n'
  autostart="${testdir}/$1.T64"
  run="-autostart $autostart -keybuf $keybuf"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${c64files}" \
  -chargen "${emulatordir}/c-chargen" \
  -symkeymap "${emulatordir}/x11_sym_uf_de.vkm" \
  -keymap 2 \
  $run \
  &

#  -warp \

if [ -n "$keybuf" ]
then
  while [ -f "${c64files}/notdone" ]
    do sleep 1
  done
  sleep 0.5

  kill %1
fi

wait %1 || echo "x64 returned $?"
