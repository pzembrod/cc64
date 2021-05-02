#!/bin/bash
set -e

x16filesdir="${CBMFILES}"
x16rom="${X16ROM}"

executable="${1}"
keybuf="${2}"

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
test -n "${x16filesdir}" || \
  x16filesdir="$(realpath --relative-to="$PWD" "${basedir}/x16files")"
test -n "${x16rom}" || \
  x16rom="${emulatordir}/x16-c-rom.bin"
sdcard="${emulatordir}/sdcard.img"
x16script="${basedir}/tmp/x16script"

make -C "${emulatordir}" sdcard.img
mformat -i "${sdcard}" -F
for asciifile in  $(cd "${x16filesdir}" && ls *)
do
  # Convert filename to PETSCII, remove trailing CR.
  petsciifile="$(echo ${asciifile} | ascii2petscii - |tr -d '\r')"
  mcopy -i "${sdcard}" "${x16filesdir}/${asciifile}" "::${petsciifile}"
done

autostart=""
script=""
if [ -n "${executable}" ]
then
  autostart="-prg ${x16filesdir}/${executable} -run"
fi

script=""
warp=""
scale=""
debug=""
if [ -n "${keybuf}" ]
then
  test -d tmp || mkdir tmp
  rm -f "${x16script}".*
  # Magic env variable KEEPEMU: If set, remove the final CR.
  if [ -n "${KEEPEMU}" ]; then
    tr_remove='\n'
  else
    tr_remove=''
  fi
  echo "load\"${executable}\"\nrun\n${keybuf}" | tr -d "${tr_remove}" \
      | sed 's/\\n/\n/g' > "${x16script}".ascii
  ascii2petscii "${x16script}.ascii" "${x16script}.petscii"
  script="-bas ${x16script}.petscii"
  autostart=""
  mcopy -i "${sdcard}" "${emulatordir}/notdone" "::NOTDONE"
  warp="-warp"
else
  scale="-scale 2"
  debug="-debug"
fi

x16emu \
  -keymap de \
  -sdcard "${sdcard}" \
  -rom "${x16rom}" \
  $autostart \
  $script \
  $warp \
  $scale \
  $debug \
  &


if [ -n "$script" ]
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

for outfile in ${OUTFILES}
do
  sdfile="$(echo "${outfile}"|ascii2petscii - |tr -d '\r')"
  mcopy -i "${sdcard}" "::${sdfile}" "${x16filesdir}/${outfile}"
  # Timestamps on the sdcard from x16emu seem to not be reliable.
  # Touch the outfiles so make's dependency analysis works.
  touch "${x16filesdir}/${outfile}"
done
