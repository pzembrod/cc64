#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

tests=$(echo *-test.c| sed 's/-test\.c//g')
goldens=*.golden
cc64="$1"

test -d c64files || mkdir c64files

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

# Build golden (and silver) file.
# It is not named suite.golden so the make rules depending on *.golden
# don't trigger on this generated golden file being new.
rm -f suite.joined-golden suite.joined-silver
touch suite.joined-golden suite.joined-silver
for t in $tests; do
  echo "${t}-test:" >> suite.joined-golden  
  cat ${t}.golden >> suite.joined-golden
  # joined-silver doesn't contain test sections, so diffing against it
  # will highlight the test sections as well as actuall output diffs.
  cat ${t}.golden >> suite.joined-silver
done

suitename="${cc64}-suite"
# Run test binary
rm -f c64files/suite.out "${suitename}.out"
./test-in-vice.sh suite
petscii2ascii c64files/suite.out "${suitename}.out"

# Evaluate test output
diff suite.joined-golden "${suitename}.out"
result=$?
test $result -eq 0 \
  && echo "${suitename} PASS" > "${suitename}.result" \
  || diff suite.joined-silver "${suitename}.out" > "${suitename}.result"
  # diff with suite.silver will additionally show test sections as diff.
cat "${suitename}.result"
exit $result
