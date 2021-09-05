#!/bin/bash
set -e

cc64="$1"
host_target="$2"

test -n "${host_target}" || host_target=c64_c64
suitename="${cc64}-suite-${host_target}"
IFS=_ read host target <<< "${host_target}"

cd "$(dirname "${BASH_SOURCE[0]}")"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
hostfiles="${testdir}/${host}files"
targetfiles="${testdir}/${target}files"

test -d "${hostfiles}"   || mkdir "${hostfiles}"
test -d "${targetfiles}" || mkdir "${targetfiles}"

tests=$(echo *-test.c| sed 's/-test\.c//g')

# Create suite.c
source "${testdir}/concat-suite.shlib"

# Build test binary
rm -f "${hostfiles}/suite" "${targetfiles}/suite.T64"
CC64HOST="${host}" OUTFILES="suite suite.log" \
  ./compile-in-emu.sh "suite" "$cc64"
petscii2ascii "${hostfiles}/suite.log" "${suitename}.log"

if [ "${hostfiles}" != "${targetfiles}" ]
then
  cp "${hostfiles}/suite" "${targetfiles}/suite"
fi
bin2t64 "${hostfiles}/suite" "${targetfiles}/suite.T64"

# Build golden (and silver) file.
source "${testdir}/concat-golden-silver.shlib"

# Run test binary
rm -f "${targetfiles}/suite.out" "${suitename}.out"
CC64TARGET="${target}" ./run-in-emu.sh suite
petscii2ascii "${targetfiles}/suite.out" "${suitename}.out"

# Evaluate test output
source "${testdir}/evaluate-suite.shlib"

exit $result
