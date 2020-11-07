#!/bin/bash
set -e

test -n "${CC64TARGET}" || export CC64TARGET=c64

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"

targetfiles="$(realpath --relative-to="$PWD" "${testdir}/${CC64TARGET}files")"
emulator="$("${emulatordir}/which-vice.sh" "${CC64TARGET}")"

run=""
if [ -n "$1" ]
then
  ascii2petscii "${testdir}/notdone" "${targetfiles}/notdone"
  keybuf='open1,8,15,"s0:notdone":close1\n'
  autostart="${targetfiles}/$1.T64"
  run="-autostart $autostart -keybuf $keybuf"
fi

${emulator} \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${targetfiles}" \
  $run \
  &

# Fix inkpot color

if [ -n "$keybuf" ]
then
  while [ -f "${targetfiles}/notdone" ]
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
