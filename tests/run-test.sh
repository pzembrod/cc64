#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

testname="$1"
host_target="$2"

test -n "${host_target}" || host_target=c64_c64

IFS=_ read host target <<< "$2"

hostfiles="${host}files"
targetfiles="${target}files"

test -d "${targetfiles}" || mkdir "${targetfiles}"

# Build test binary
echo "char *name(){ return \"${testname}.out,s,w\"; } test(){ ${testname}_test (); }" \
 | cat "test-setup-${target}.h" "${testname}-test.c" - test-main.h \
 | tee "${testname}-generated.c" \
 | ascii2petscii - "${hostfiles}/${testname}.c"
rm -f "${hostfiles}/${testname}" "${testname}.T64"
CC64HOST="${host}" ./compile-in-vice.sh "cc ${testname}.c\ndos s0:notdone\n"

bin2t64 "${hostfiles}/${testname}" "${targetfiles}/${testname}.T64"
fulltestname="${testname}-${host_target}"

# Run test binary
rm -f "${targetfiles}/${testname}.out" "${fulltestname}.out"
CC64TARGET="${target}" ./test-in-vice.sh "${testname}"
petscii2ascii "${targetfiles}/${testname}.out" "${fulltestname}.out"

# Evaluate test output
echo "Test: ${fulltestname}" > tmp.result
diff "${testname}.golden" "${fulltestname}.out" >> tmp.result
result=$?
test $result -eq 0 \
  && echo "PASS: ${fulltestname}" >> tmp.result \
  || echo "FAIL: ${fulltestname}" >> tmp.result
cat tmp.result
mv tmp.result "${fulltestname}-result.txt"
exit $result
