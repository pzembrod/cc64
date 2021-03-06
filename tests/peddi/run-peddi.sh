#!/bin/bash
set -e

test -n "$PLATFORM" || export PLATFORM=c64

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/../..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${PLATFORM}")"

cbmfiles="$(realpath --relative-to="$PWD" "${testdir}/${PLATFORM}files")"
emulator="$("${emulatordir}/which-vice.sh" "${PLATFORM}")"

peddi="peddi"
keybuf=""
warp=""
if [ -n "$2" ]
then
  keybuf="${2}dos s0:notdone"
  warp="-warp"
  ascii2petscii "${testdir}/notdone" "${cbmfiles}/notdone"
  # Magic env variable KEEPEMU: Only if not set, send in the final CR.
  if [ -z "${KEEPEMU}" ]; then
    keybuf="${keybuf}\n"
  fi
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
  -keybuf "${keybuf}" \
  $warp \
  &


if [ -n "$keybuf" ]
then
  while [ -f "${cbmfiles}/notdone" ]
    do sleep 1
  done
  sleep 0.5

  kill9log="${basedir}/kill-9.log"
  vicepid=$(jobs -p %1)
  kill %1
  (sleep 20; ps -q "${vicepid}" -f --no-headers && \
      (kill -9 "${vicepid}" ; date)) >> "${kill9log}" 2>&1 &
fi

wait %1 || echo "x64 returned $?"
