#!/bin/bash
set -e

testname="$1"
host_target="$2"

test -n "${host_target}" || host_target=c64_c64
fulltestname="${testname}-${host_target}"
IFS=_ read host target <<< "${host_target}"

cd "$(dirname "${BASH_SOURCE[0]}")"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${testdir}/basedir.shlib"
hostfiles="${testdir}/${host}files"
targetfiles="${testdir}/${target}files"

test -d "${hostfiles}"   || mkdir "${hostfiles}"
test -d "${targetfiles}" || mkdir "${targetfiles}"

# Build test binary
echo "char *name(){ return \"${testname}.out,s,w\"; } test(){ ${testname}_test (); }" \
 | cat "test-setup-${target}.h" "${testname}-test.c" - test-main.h \
 | tee "${testname}-generated.c" \
 | ascii2petscii - "${hostfiles}/${testname}.c"
rm -f "${hostfiles}/${testname}" "${targetfiles}/${testname}.T64"
CC64HOST="${host}" OUTFILES="${testname} ${testname}.log" \
  ./compile-in-emu.sh "${testname}"
petscii2ascii "${hostfiles}/${testname}.log" "${fulltestname}.log"

if [ "${hostfiles}" != "${targetfiles}" ]
then
  cp "${hostfiles}/${testname}" "${targetfiles}/${testname}"
fi
bin2t64 "${hostfiles}/${testname}" "${targetfiles}/${testname}.T64"

# Run test binary
rm -f "${targetfiles}/${testname}.out" "${fulltestname}.out"
CC64TARGET="${target}" ./run-in-emu.sh "${testname}"
petscii2ascii "${targetfiles}/${testname}.out" "${fulltestname}.out"

# Evaluate test output
rm -f tmp.result
echo "Test: ${fulltestname}" > tmp.result
set +e
diff "${testname}.golden" "${fulltestname}.out" >> tmp.result
result=$?
set -e
test $result -eq 0 \
  && echo "PASS: ${fulltestname}" >> tmp.result \
  || echo "FAIL: ${fulltestname}" >> tmp.result
cat tmp.result
mv -f tmp.result "${fulltestname}.result"
exit $result
