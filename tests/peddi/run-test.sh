#!/bin/bash

# Run peddi with script
peddi="$1"
testname="$2"
platform="$3"

test -n "$platform" || platform=c64

cbmfiles="${platform}files"

test -d "${cbmfiles}" || mkdir "${cbmfiles}"

rm -f "${cbmfiles}/${testname}.txt" "${testname}.txt"
if [ -f "${testname}.before" ]
then
  ascii2petscii "${testname}.before" "${cbmfiles}/${testname}.txt"
fi

PLATFORM="${platform}" ./run-peddi.sh "$peddi" \
"$(printf "ed ${testname}.txt\n\
$(sed -e 's/\\/\\\\/g' ${testname}.keybuf | tr -d '\n')")"

petscii2ascii "${cbmfiles}/${testname}.txt" "${testname}.out"

# Evaluate test output
echo "Test: $testname" > tmp.result
diff "${testname}.golden" "${testname}.out" >> tmp.result
result=$?
test $result -eq 0 \
  && echo "PASS: $testname" >> tmp.result \
  || echo "FAIL: $testname" >> tmp.result
cat tmp.result
mv tmp.result "${testname}-${platform}-result.txt"
exit $result
