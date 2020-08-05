#!/bin/bash
set -e

test -n "$VICE" || VICE=x64
test -n "$DISK9" || DISK9=empty
test -n "$DISK10" || DISK10=empty
test -n "$DISK11" || DISK11=empty
emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"

autostart=""
if [ -n "$1" ]
then
  autostart="-autostart ${emulatordir}/${1}.T64"
fi

keybuf=""
warp=""
if [ -n "$2" ]
then
  keybuf="${2}" # dos s0:notdone\n"
  # The following could also just be a cp.
  ascii2petscii "${emulatordir}/notdone" "${basedir}/cbmfiles/notdone"
  warp="-warp"
fi

"$VICE" \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -drive10type 1541 \
  -drive11type 1541 \
  -fs8 "${basedir}/cbmfiles" \
  -9 "${basedir}/disks/${DISK9}.d64" \
  -10 "${basedir}/disks/${DISK10}.d64" \
  -11 "${basedir}/disks/${DISK11}.d64" \
  -symkeymap "${emulatordir}/x11_sym_vf_de.vkm" \
  -keymap 2 \
  $autostart \
  -keybuf "$keybuf" \
  $warp \
  &


if [ -n "$keybuf" ]
then
  while [ -f "${basedir}/cbmfiles/notdone" ]
    do sleep 1
  done
  sleep 0.5

  log="${basedir}/killfail.log"
  kill %1
  jobs %1 && sleep 0.1
  jobs %1 && date >> "$log" && sleep 0.5
  jobs %1 && echo "1 sec" >> "$log" && sleep 2
  jobs %1 && echo "3 sec" >> "$log" && sleep 8
  jobs %1 && echo "11 sec: kill -9" >> "$log" && kill -9 %1
fi

wait %1 || echo "x64 returned $?"
