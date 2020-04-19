#!/bin/bash
set -e

basedir="$(dirname "${BASH_SOURCE[0]}")"

keybuf=""
if [ -n "$1" ]
then
  keybuf="${1}dos s0:notdone\n"
  ascii2petscii "${basedir}/notdone" "${basedir}/c64files/notdone"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -drive10type 1541 \
  -drive11type 1541 \
  -fs8 "${basedir}/c64files" \
  -9 "${basedir}//src/cc64src1.d64" \
  -10 "${basedir}//src/cc64src2.d64" \
  -11 "${basedir}//src/peddi_src.d64" \
  -autostart "${basedir}/uf-build-base.T64" \
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
