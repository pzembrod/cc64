#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

# Build test binary
echo "char *name(){ return \"$1.out,s,w\"; } test(){ ${1}_test (); }" \
 | cat test-setup.h "$1"-test.c - test-main.h \
 | tee "$1"-generated.c \
 | ascii2petscii - c64files/"$1".c
rm -f c64files/"$1" "$1".T64
./compile-in-vice.sh "cc "$1".c\ndos s0:notdone\n"
bin2t64 c64files/"$1" "$1".T64

# Run test binary
rm -f c64files/"$1".out "$1".out
./test-in-vice.sh "$1"
petscii2ascii c64files/"$1".out "$1".out

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
