#!/bin/bash
set -e

test -n "${PLATFORM}" || exit 1
cbmfiles="${CBMFILES}"
autostartdir="${AUTOSTARTDIR}"

executable="${1}"
keybuf="${2}"

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
test -n "${autostartdir}" || \
  autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${PLATFORM}")"
test -n "${cbmfiles}" || \
  cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${PLATFORM}files")"

emulator="$("${emulatordir}/which-vice.sh" "${PLATFORM}")"

autostart=""
if [ -n "${executable}" ]
then
  autostart="-autostart ${autostartdir}/${executable}.T64"
fi

warp=""
if [ -n "${keybuf}" ]
then
  # The following could also just be a cp.
  ascii2petscii "${emulatordir}/notdone" "${cbmfiles}/notdone"
  warp="-warp"
fi

${emulator} \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${cbmfiles}" \
  $autostart \
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

wait %1 || echo "$VICE returned $?"
