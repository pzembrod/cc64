#!/bin/bash
set -e

testname="$1"
host_target="$2"

test -n "${host_target}" || host_target=c64_c64
IFS=_ read host target <<< "${host_target}"

cd "$(dirname "${BASH_SOURCE[0]}")"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
hostfiles="${testdir}/${host}files"

test -d "${hostfiles}" || mkdir "${hostfiles}"

rm -f "${hostfiles}/${testname}"*
ascii2petscii "${testname}.c" "${hostfiles}/${testname}.c"
CC64HOST="${host}" OUTFILES="${testname}.h" \
  ./compile-in-emu.sh "cc ${testname}.c\ndos s0:notdone"

petscii2ascii "${hostfiles}/${testname}.h" "${testname}.h.out"

# Evaluate test output
rm -f tmp.result
echo "Test: ${testname}" > tmp.result
set +e
diff "${testname}.golden" "${testname}.h.out" >> tmp.result
result=$?
set -e
test $result -eq 0 \
  && echo "PASS: ${testname}" >> tmp.result \
  || echo "FAIL: ${testname}" >> tmp.result
cat tmp.result
mv -f tmp.result "${testname}.result"
exit $result
