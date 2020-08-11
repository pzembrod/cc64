#!/bin/bash
set -e

test -n "$PLATFORM" || export PLATFORM=c64

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/../..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${PLATFORM}")"

cbmfiles="$(realpath --relative-to="$PWD" "${testdir}/${PLATFORM}files")"
emulator="$("${emulatordir}/which-emulator.sh" "${PLATFORM}")"

peddi="peddi"
keybuf=""
warp=""
if [ -n "$2" ]
then
  # keybuf="$1"
  keybuf="${2}dos s0:notdone\n"
  warp="-warp"
  ascii2petscii "${testdir}/notdone" "${cbmfiles}/notdone"
fi

if [ -n "$1" ]
then
  peddi="$1"
fi

${emulator} \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${cbmfiles}" \
  -autostart "${autostartdir}/${peddi}.T64" \
  -keybuf "$keybuf" \
  $warp \
  &


if [ -n "$keybuf" ]
then
  while [ -f "${cbmfiles}/notdone" ]
    do sleep 1
  done
  sleep 0.5

  kill %1
fi

wait %1 || echo "x64 returned $?"
