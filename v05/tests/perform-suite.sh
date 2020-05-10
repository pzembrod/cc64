#!/bin/bash

tests=$(echo *-test.c| sed 's/-test\.c//g')
goldens=*.golden
cc64=""
if [ -n "$1" ]
then
  cc64="$1"
fi

# Build test binary
(
  cat test-setup.h
  echo "char *name(){ return \"suite.out,s,w\"; }"
  for t in $tests; do
    cat ${t}-test.c
  done
  echo "test(){"
  for t in $tests; do
    echo "  println(\"${t}-test:\");"
    echo "  ${t}_test();"
  done
  echo "}"
  cat test-main.h
) | tee suite-generated.c | ascii2petscii - c64files/suite.c
rm -f c64files/suite suite.T64
./compile-in-vice.sh "cc suite.c\ndos s0:notdone\n" "$cc64"
bin2t64 c64files/suite suite.T64

# Build golden file
rm -f suite.golden suite.silver
touch suite.golden suite.silver
for t in $tests; do
  echo "${t}-test:" >> suite.golden  
  cat ${t}.golden >> suite.golden
  # suite.silver doesn't contain test sections, so diffing against it
  # will highlight the test sections as well as actuall output diffs.
  cat ${t}.golden >> suite.silver
done

# Run test binary
rm -f c64files/suite.out suite.out
./test-in-vice.sh suite
petscii2ascii c64files/suite.out suite.out

# Evaluate test output
diff suite.golden suite.out
result=$?
test $result -eq 0 \
  && echo "suite PASS" > suite.result \
  || diff suite.silver suite.out > suite.result
  # diff with suite.silver will additionally show test sections as diff.
cat suite.result
exit $result
