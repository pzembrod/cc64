#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

testname="$1"

test -d c64files || mkdir c64files

# Build test binary
echo "char *name(){ return \"${testname}.out,s,w\"; } test(){ ${testname}_test (); }" \
 | cat test-setup.h "${testname}-test.c" - test-main.h \
 | tee "${testname}-generated.c" \
 | ascii2petscii - "c64files/${testname}.c"
rm -f "c64files/${testname}" "${testname}.T64"
./compile-in-vice.sh "cc ${testname}.c\ndos s0:notdone\n"
bin2t64 "c64files/${testname}" "${testname}.T64"

# Run test binary
rm -f "c64files/${testname}.out" "${testname}.out"
./test-in-vice.sh "${testname}"
petscii2ascii "c64files/${testname}.out" "${testname}.out"

# Evaluate test output
echo "Test: ${testname}" > tmp.result
diff "${testname}.golden" "${testname}.out" >> tmp.result
result=$?
test $result -eq 0 \
  && echo "PASS: ${testname}" >> tmp.result \
  || echo "FAIL: ${testname}" >> tmp.result
cat tmp.result
mv tmp.result "${testname}-result.txt"
exit $result
