#!/bin/bash
set -e

sdcard_img="$1"
shift
x16dir_files=$@

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
x16filesdir="$(realpath --relative-to="$PWD" "${basedir}/x16files")"

for asciifile in ${x16dir_files}; do
  # Convert base filename to PETSCII, remove trailing CR.
  asciibasename="$(basename "${asciifile}")"
  petsciifile="$(echo ${asciibasename} | ascii2petscii - |tr -d '\r')"
  mcopy -i "${sdcard_img}" "${asciifile}" "::${petsciifile}"
done
