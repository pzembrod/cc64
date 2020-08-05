#!/bin/bash
# This script runs VICE in the foreground so that the VICE monitor
# works which doesn't work if VICE runs in the background.
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
  $autostart
