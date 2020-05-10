#!/bin/bash
set -e

basedir="$(dirname "${BASH_SOURCE[0]}")"

run=""
if [ -n "$1" ]
then
  autostart="${basedir}/$1.T64"
  run="-autostart $autostart"
fi

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 "${basedir}/c64files" \
  -chargen "${basedir}/../c-chargen" \
  -symkeymap "${basedir}/../x11_sym_uf_de.vkm" \
  $run
