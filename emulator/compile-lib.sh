#!/bin/bash
set -e

lib="${1}"

test -n "${CC64HOST}" || export CC64HOST=c64

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${emulatordir}/basedir.shlib"
runtimedir="$(realpath --relative-to="$PWD" "${basedir}/runtime")"
libdir="$(realpath --relative-to="$PWD" "${basedir}/lib")"
cbmfiles="$(realpath --relative-to="$PWD" "${libdir}/cbmfiles")"

test -d "${cbmfiles}" || mkdir "${cbmfiles}"
rm -f "${cbmfiles}/${lib}.log" "${cbmfiles}/${lib}".[hio]
for f in "${runtimedir}"/* "${libdir}/${lib}.c"; do
  "${emulatordir}/copy-to-emu.sh" "${f}" "${cbmfiles}/$(basename "${f}")"
done

keybuf="logfile ${lib}.log\ncc ${lib}.c\nlogclose\ndos s0:notdone"

export CBMFILES="${cbmfiles}"
export OUTFILES="${lib}.h ${lib}.i ${lib}.o"
"${emulatordir}/run-in-${CC64HOST}emu.sh" cc64 "${keybuf}"
for f in ${OUTFILES}; do
  "${emulatordir}/copy-from-emu.sh" "${cbmfiles}/${f}" "${libdir}/${f}"
done
