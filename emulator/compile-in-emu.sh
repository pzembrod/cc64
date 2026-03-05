#!/bin/bash
set -e

program="${1}"
cc64="${2}"
test -n "${cc64}" || cc64="cc64"

test -n "${CC64HOST}" || export CC64HOST=c64
test -n "${OUTFILES}" || export OUTFILES="${program} ${program}.log"

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${emulatordir}/basedir.shlib"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${CC64HOST}files")"
test -n "${CBMFILES}" || export CBMFILES="${cbmfiles}"

logfile="${CBMFILES}/${program}.log"
rm -f "${logfile}"
keybuf="logfile ${program}.log\ncc ${program}.c\nlogclose\ndos s0:notdone"

"${emulatordir}/run-in-${CC64HOST}emu.sh" "${cc64}" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep '^done$' || \
  (echo "Compile did not complete: ${logfile}" && exit 1)

petscii2ascii "${logfile}" | \
  grep -F 'error(s) occured' && \
  echo "Compilation error(s): ${logfile}" && exit 1 || true
