#!/bin/bash
set -e

basedir="$(dirname "${BASH_SOURCE[0]}")"

run=""
if [ -n "$1" ]
then
  ascii2petscii "${basedir}/../notdone" "${basedir}/c64files/notdone"
  keybuf='open1,8,15,"s0:notdone":close1\n'
  autostart="${basedir}/$1.T64"
  run="-autostart $autostart -keybuf $keybuf"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${basedir}/c64files" \
  -chargen "${basedir}/../c-chargen" \
  -symkeymap "${basedir}/../x11_sym_uf_de.vkm" \
  $run \
  &

#  -warp \

if [ -n "$keybuf" ]
then
  while [ -f "${basedir}/c64files/notdone" ]
    do sleep 1
  done
  sleep 0.5

  kill %1
fi

wait %1 || echo "x64 returned $?"
