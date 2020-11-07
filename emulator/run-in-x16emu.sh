#!/bin/bash
set -e

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
x16filesdir="$(realpath --relative-to="$PWD" "${basedir}/x16files")"
sdcard="${emulatordir}/sdcard.img"

mformat -i "${sdcard}" -F
for asciifile in  $(cd "${x16filesdir}" && ls *)
do
  # Convert filename to PETSCII, remove trailing CR.
  petsciifile="$(echo ${asciifile} | ascii2petscii - |tr -d '\r')"
  mcopy -i "${sdcard}" "${x16filesdir}/$asciifile" "::${petsciifile}"
done

autostart=""
if [ -n "$1" ]
then
  autostart="-prg ${x16filesdir}/${1} -run"
fi

keybuf=""
warp=""
scale=""
debug=""
if [ -n "$2" ]
then
  keybuf="$(echo ${2}|sed 's/\\n/\\x0d/g'|tr '[:upper:][:lower:]' '[:lower:][:upper:]')"
  mcopy -i "${sdcard}" "${emulatordir}/notdone" "::NOTDONE"
  warp="-warp"
else
  scale="-scale 2"
  debug="-debug"
fi

x16emu \
  -keymap de \
  -sdcard "${sdcard}" \
  $autostart \
  -keybuf "$keybuf" \
  $warp \
  $scale \
  $debug \
  &

if [ -n "$keybuf" ]
then
  while mtype -i "${sdcard}" "::NOTDONE" > /dev/null
    do sleep 1
  done
  sleep 0.5

  kill9log="${basedir}/kill-9.log"
  x16emupid="$(jobs -p %1)"
  kill %1
  (sleep 20; ps -q "${x16emupid}" -f --no-headers && \
      (kill -9 "${x16emupid}" ; date)) >> "${kill9log}" 2>&1 &
fi

wait %1 || echo "x16emu returned $?"
