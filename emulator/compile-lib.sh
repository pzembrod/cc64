#!/bin/bash
set -e

lib="${1}"

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${emulatordir}/basedir.shlib"
runtimedir="$(realpath --relative-to="$PWD" "${basedir}/runtime")"
libdir="$(realpath --relative-to="$PWD" "${basedir}/lib")"

cbmfiles="$(realpath --relative-to="$PWD" "${libdir}/cbmfiles")"
test -d "${cbmfiles}" || mkdir "${cbmfiles}"
for f in "${runtimedir}"/* "${libdir}/${lib}.c"; do
  "${emulatordir}/copy-to-emu.sh" "${f}" "${cbmfiles}/$(basename "${f}")"
done

rm -f "${cbmfiles}/${lib}".[hio]
export OUTFILES="${lib}.h ${lib}.i ${lib}.o"

export CBMFILES="${cbmfiles}"
"${emulatordir}/compile-in-emu.sh" "${lib}" cc64

for f in ${OUTFILES}; do
  "${emulatordir}/copy-from-emu.sh" "${cbmfiles}/${f}" "${libdir}/${f}"
done
