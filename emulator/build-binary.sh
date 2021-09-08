#!/bin/bash
set -e

platform="$1"
target="$2"
main_include="$3"
test -n "${main_include}" || main_include="${target}"

emulatordir="$(dirname "${BASH_SOURCE[0]}")"
source "${emulatordir}/basedir.shlib"
cbmfiles="$(realpath --relative-to="$PWD" "${basedir}/${platform}files")"
logfile="${cbmfiles}/${target}.log"

rm -f "${cbmfiles}/${target}"
rm -f "${logfile}"

keybuf="include enable-log.fth\nlogopen ${main_include}.log\n"
keybuf="${keybuf}include ${main_include}.fth\nsaveall ${target}\n"
keybuf="${keybuf}dos s0:notdone"
if [ "${platform}" == "c64" ]; then
  keybuf="include set-d000.fth\ncold\n${keybuf}"
fi

export OUTFILES="${target} ${target}.log"
"${emulatordir}/run-in-${platform}emu.sh" "vf-build-base" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep -F 'compile successful' || \
  (echo "check logfile ${logfile}" && exit 1)

echo "$(date +%F-%H%M) $(wc -c "${cbmfiles}/${target}")" \
  >> "${platform}-${target}.sizes"
