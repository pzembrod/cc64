#!/bin/bash

# Run peddi with script
peddi="$1"
testname="$2"

test -d c64files || mkdir c64files

rm -f "c64files/${testname}.txt" "${testname}.txt"
if [ -f "${testname}.before" ]
then
  ascii2petscii "${testname}.before" "c64files/${testname}.txt"
fi
./run-peddi.sh "$peddi" "$(printf "ed ${testname}.txt\n\
$(sed -e 's/\\/\\\\/g' ${testname}.keybuf | tr -d '\n')")"
petscii2ascii "c64files/${testname}.txt" "${testname}.out"

# Evaluate test output
echo "Test: $testname" > tmp.result
diff "${testname}.golden" "${testname}.out" >> tmp.result
result=$?
test $result -eq 0 \
  && echo "PASS: $testname" >> tmp.result \
  || echo "FAIL: $testname" >> tmp.result
cat tmp.result
mv tmp.result "${testname}-result.txt"
exit $result
