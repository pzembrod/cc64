#!/bin/bash
set -e

x16filesdir="${CBMFILES}"
x16rom="${X16ROM}"

executable="${1}"
keybuf="${2}"

echo executable = $executable
echo keybuf = $keybuf

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${emulatordir}/basedir.shlib"
test -n "${x16filesdir}" || \
  x16filesdir="$(realpath --relative-to="$PWD" "${basedir}/x16files")"
test -n "${x16rom}" || \
  x16rom="${emulatordir}/x16-c-rom.bin"
x16script="${basedir}/tmp/x16script"

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
  # The following could also just be a cp.
  ascii2petscii "${emulatordir}/notdone" "${x16filesdir}/notdone"
  warp="-warp"
else
  scale="-scale 2"
  debug="-debug"
fi

rom=""
if [ -s "${x16rom}" ]
then
  rom="-rom ${x16rom}"
fi

x16emu \
  -keymap de \
  -fsroot "${x16filesdir}" \
  $rom \
  $autostart \
  $script \
  $warp \
  $scale \
  $debug \
  &


if [ -n "$script" ]
then
  while [ -f "${x16filesdir}/notdone" ]
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
  if [ "${x16filesdir}/${sdfile}" != "${x16filesdir}/${outfile}" ]
  then
    mv "${x16filesdir}/${sdfile}" "${x16filesdir}/${outfile}"
  fi
  # Timestamps on the sdcard from x16emu seem to not be reliable.
  # Touch the outfiles so make's dependency analysis works.
  touch "${x16filesdir}/${outfile}"
done
