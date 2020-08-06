#!/bin/bash
set -e

test -n "${CC64HOST}" || export CC64HOST=c64

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${CC64HOST}")"

hostfiles="$(realpath --relative-to="$PWD" "${testdir}/${CC64HOST}files")"
emulator="$("${emulatordir}/which-emulator.sh" "${CC64HOST}")"

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
  -symkeymap "${emulatordir}/x11_sym_uf_de.vkm" \
  -keymap 2 \
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

  kill %1
fi

wait %1 || echo "x64 returned $?"
