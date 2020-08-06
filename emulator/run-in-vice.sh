#!/bin/bash
set -e

test -n "$PLATFORM" || PLATFORM=c64
emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${PLATFORM}")"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${PLATFORM}files")"

emulator="$("${emulatordir}/which-emulator.sh" "${PLATFORM}")"

autostart=""
if [ -n "$1" ]
then
  autostart="-autostart ${autostartdir}/${1}.T64"
fi

keybuf=""
warp=""
if [ -n "$2" ]
then
  keybuf="${2}" # dos s0:notdone\n"
  # The following could also just be a cp.
  ascii2petscii "${emulatordir}/notdone" "${basedir}/${cbmfiles}/notdone"
  warp="-warp"
fi

${emulator} \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${basedir}/${cbmfiles}" \
  -symkeymap "${emulatordir}/x11_sym_vf_de.vkm" \
  -keymap 2 \
  $autostart \
  -keybuf "$keybuf" \
  $warp \
  &


if [ -n "$keybuf" ]
then
  while [ -f "${basedir}/${cbmfiles}/notdone" ]
    do sleep 1
  done
  sleep 0.5

  log="${basedir}/killfail.log"
  kill %1
  #set +e
  #jobs %1 2>/dev/null && sleep 0.2
  #jobs %1 2>/dev/null && date >> "$log" && sleep 0.5
  #jobs %1 2>/dev/null && echo "1 sec" >> "$log" && sleep 2
  #jobs %1 2>/dev/null && echo "3 sec" >> "$log" && sleep 8
  #jobs %1 2>/dev/null && echo "11 sec: kill -9" >> "$log" && kill -9 %1
  #set -e
fi

wait %1 || echo "$VICE returned $?"
