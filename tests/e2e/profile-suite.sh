#!/bin/bash
set -e

cc64="$1"
shift
metrics="$@"

host="c64"

cd "$(dirname "${BASH_SOURCE[0]}")"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
emulatordir="$(realpath --relative-to="$PWD" "${basedir}/emulator")"
hostfiles="${testdir}/${host}files"

test -d "${hostfiles}"   || mkdir "${hostfiles}"

tests=$(echo *-test.c| sed 's/-test\.c//g')

# Create suite.c
target="${host}"
source "${testdir}/concat-suite.shlib"

# Build test binary
rm -f "${hostfiles}/suite" "${hostfiles}/suite.T64"
testname="suite"
rm -f "${hostfiles}/${testname}.log"

keybuf=""
outfiles=""
for metric in "$@"; do
  keybuf="${keybuf}exec ${metric}.pfs\n"
  outfiles="${outfiles} ${metric}.profile"
done
keybuf="${keybuf}dos s0:notdone"
#if [ -n "${metric}" ]; then
#  keybuf="exec ${metric}.pfs\ndos s0:notdone"
#fi
export CC64HOST="${host}"
export OUTFILES="${outfiles}"
export CBMFILES="${hostfiles}"
"${emulatordir}/run-in-${host}emu.sh" "${cc64}" "${keybuf}"

for profile in ${outfiles}; do
  petscii2ascii "${hostfiles}/${profile}" "${profile}"
done

# cmp "${hostfiles}/suite" reference/suite_c64
