#!/bin/bash
set -e

test -n "${CC64HOST}" || export CC64HOST=c64

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/../..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${CC64HOST}")"
c64files="$(realpath --relative-to="$PWD" "${testdir}/c64files")"

peddi="peddi"
keybuf=""
warp=""
if [ -n "$2" ]
then
  # keybuf="$1"
  keybuf="${2}dos s0:notdone\n"
  warp="-warp"
  ascii2petscii "${testdir}/notdone" "${c64files}/notdone"
fi

if [ -n "$1" ]
then
  peddi="$1"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${c64files}" \
  -chargen "${emulatordir}/c-chargen" \
  -symkeymap "${emulatordir}/x11_sym_uf_de.vkm" \
  -keymap 2 \
  -autostart "${autostartdir}/${peddi}.T64" \
  -keybuf "$keybuf" \
  $warp \
  &


if [ -n "$keybuf" ]
then
  while [ -f "${c64files}/notdone" ]
    do sleep 1
  done
  sleep 0.5

  kill %1
fi

wait %1 || echo "x64 returned $?"
