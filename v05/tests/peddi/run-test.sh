#!/bin/bash

# Run peddi with script
rm -f c64files/"$1".txt "$1".txt
./run-peddi.sh "$(printf "ed ${1}.txt\n\
$(sed -e 's/\\n//g' -e 's/\\/\\\\/g' ${1}.in)")"
petscii2ascii c64files/"$1".txt "$1".out

# Evaluate test output
echo "Test: $1" > tmp.result
diff "$1".golden "$1".out >> tmp.result
result=$?
test $result -eq 0 \
  && echo "PASS: $1" >> tmp.result \
  || echo "FAIL: $1" >> tmp.result
cat tmp.result
mv tmp.result "$1"-result.txt
exit $result
