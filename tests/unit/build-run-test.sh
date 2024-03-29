#!/bin/bash
set -e

testname="${1}"
platform="c64"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
cbmfiles="$(realpath --relative-to="$PWD" "${testdir}/${platform}files")"
logfile="${cbmfiles}/${testname}.log"
goldenfile="${testdir}/${testname}.golden"

rm -f "${logfile}"

keybuf="include ${testname}.fth\ndos s0:notdone"

export OUTFILES="${testname}.log"
export CBMFILES="${cbmfiles}"
"${emulatordir}/run-in-${platform}emu.sh" "vf-build-base" "${keybuf}"

petscii2ascii "${logfile}" | \
  grep -F 'test completed' || \
  (echo "Test did not complete: ${logfile}" && exit 1)

petscii2ascii "${logfile}" | \
  grep -E -A 1 'FAIL:' && \
  echo "Failure: ${logfile}" && exit 1 || true

petscii2ascii "${logfile}" | \
  grep -qF 'test completed with 0 errors' || \
  (echo "Test completed with errors: ${logfile}" && exit 1)

if [[ -f "${goldenfile}" ]]; then
  # golden file lines starting with #GOLDEN are considered comments:
  grep -v '^#GOLDEN ' "${goldenfile}" >"${goldenfile}.tmp"
  petscii2ascii "${logfile}" | ./filter.awk | diff "${goldenfile}.tmp" -
fi

