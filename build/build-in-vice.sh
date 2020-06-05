#!/bin/bash
set -e

builddir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${builddir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"

keybuf=""
if [ -n "$1" ]
then
  keybuf="${1}dos s0:notdone\n"
  # The following could also just be a cp.
  ascii2petscii "${builddir}/notdone" "${basedir}/c64files/notdone"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -drive10type 1541 \
  -drive11type 1541 \
  -fs8 "${basedir}/c64files" \
  -autostart "${emulatordir}/uf-build-base.T64" \
  -keybuf "$keybuf" \
  -warp \
  &


if [ -n "$keybuf" ]
then
  while [ -f "${basedir}/c64files/notdone" ]
    do sleep 1
  done
  sleep 0.5

  kill %1
fi

wait %1 || echo "x64 returned $?"
