#!/bin/bash

# Run peddi with script
rm -f c64files/"$1".txt "$1".txt
if [ -f "$1.before" ]
then
  ascii2petscii "$1.before" c64files/"$1".txt
fi
./run-peddi.sh "$(printf "ed ${1}.txt\n\
$(sed -e 's/\\/\\\\/g' ${1}.keybuf | tr -d '\n')")"
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
