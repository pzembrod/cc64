#!/bin/bash
# This script runs VICE in the foreground so that the VICE monitor
# works which doesn't work if VICE runs in the background.
set -e

test -n "$PLATFORM" || export PLATFORM=c64
emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
autostartdir="$(realpath --relative-to="$PWD" "${basedir}/autostart-${PLATFORM}")"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${PLATFORM}files")"

emulator="$("${emulatordir}/which-vice.sh" "${PLATFORM}")"

autostart=""
if [ -n "$1" ]
then
  autostart="-autostart ${autostartdir}/${1}.T64"
fi

${emulator} \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${basedir}/${cbmfiles}" \
  $autostart
