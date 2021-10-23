#!/bin/bash
set -e

subdir="$1"
host_target="$2"
shift
shift
extra_setup_paths=$@

test -n "${host_target}" || host_target=c64_c64
IFS=_ read host target <<< "${host_target}"

cd "$(dirname "${BASH_SOURCE[0]}")"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
hostfiles="${testdir}/${host}files"
targetfiles="${testdir}/${target}files"

test -d "${hostfiles}"   || mkdir "${hostfiles}"
test -d "${targetfiles}" || mkdir "${targetfiles}"

test_paths=$(echo ${subdir}/*-test.c| sed 's/-test\.c//g')
suitename="${subdir}-suite-${host_target}"
suiteshort="${subdir}-suite"

# Create suite.c
source "${testdir}/concat-suite.shlib"

# Build test binary
rm -f "${hostfiles}/${suiteshort}" "${targetfiles}/${suiteshort}.T64"
CC64HOST="${host}" OUTFILES="${suiteshort}" \
  ./compile-in-emu.sh "${suiteshort}"

if [ "${hostfiles}" != "${targetfiles}" ]
then
  cp "${hostfiles}/${suiteshort}" "${targetfiles}/${suiteshort}"
fi
bin2t64 "${hostfiles}/${suiteshort}" "${targetfiles}/${suiteshort}.T64"

# Build golden (and silver) file.
source "${testdir}/concat-golden-silver.shlib"

# Run test binary
rm -f "${targetfiles}/${suiteshort}.out" "${suitename}.out"
CC64TARGET="${target}" ./run-in-emu.sh "${suiteshort}"

# Fetch suite outfile and attach extra outfiles
source "${testdir}/concat-outfile.shlib"

# Evaluate test output
source "${testdir}/evaluate-suite.shlib"

exit $result
