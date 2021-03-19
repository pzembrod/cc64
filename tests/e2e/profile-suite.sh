#!/bin/bash
set -e

cc64="$1"

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
# keybuf="profile-cc64-1\ncc ${testname}.c\nlogfile ${testname}.log\n\
# report\nlogclose\n\

keybuf="exec cc64-1.pfs\nexec scanner1.pfs\ndos s0:notdone"
CC64HOST="${host}" OUTFILES=suite CBMFILES="${hostfiles}" \
  "${emulatordir}/run-in-${host}emu.sh" "${cc64}" "${keybuf}"

petscii2ascii "${hostfiles}/${testname}.log" suite.profile

# cmp "${hostfiles}/suite" reference/suite_c64
