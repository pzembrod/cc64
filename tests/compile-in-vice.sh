#!/bin/bash
set -e

test -n "${CC64HOST}" || export CC64HOST=c64

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${CC64HOST}")"

hostfiles="$(realpath --relative-to="$PWD" "${testdir}/${CC64HOST}files")"
emulator="$("${emulatordir}/which-vice.sh" "${CC64HOST}")"

keybuf="$1"
cc64="$2"

test -n "${cc64}" || cc64="cc64"

warp=""
if [ -n "${keybuf}" ]
then
  warp="-warp"
  ascii2petscii "${testdir}/notdone" "${hostfiles}/notdone"
fi

${emulator} \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${hostfiles}" \
  -autostart "${autostartdir}/${cc64}.T64" \
  -keybuf "$keybuf" \
  $warp \
  &

if [ -n "$keybuf" ]
then
  while [ -f "${hostfiles}/notdone" ]
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
