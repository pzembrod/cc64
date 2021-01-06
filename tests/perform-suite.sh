#!/bin/bash
set -e

cc64="$1"
host_target="$2"

test -n "${host_target}" || host_target=c64_c64
IFS=_ read host target <<< "${host_target}"

cd "$(dirname "${BASH_SOURCE[0]}")"

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
basedir="$(realpath --relative-to="$PWD" "${testdir}/..")"
hostfiles="${testdir}/${host}files"
targetfiles="${testdir}/${target}files"

test -d "${targetfiles}" || mkdir "${targetfiles}"

tests=$(echo *-test.c| sed 's/-test\.c//g')
goldens=*.golden

# Build test binary
(
  cat "test-setup-${target}.h"
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
) | tee suite-generated.c | ascii2petscii - "${hostfiles}/suite.c"
rm -f "${hostfiles}/suite" "${targetfiles}/suite.T64"
CC64HOST="${host}" OUTFILES=suite \
  ./compile-in-emu.sh "cc suite.c\ndos s0:notdone\n" "$cc64"

if [ "${hostfiles}" != "${targetfiles}" ]
then
  cp "${hostfiles}/suite" "${targetfiles}/suite"
fi
bin2t64 "${hostfiles}/suite" "${targetfiles}/suite.T64"

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

suitename="${cc64}-suite-${host_target}"
# Run test binary
rm -f "${targetfiles}/suite.out" "${suitename}.out"
CC64TARGET="${target}" ./test-in-emu.sh suite
petscii2ascii "${targetfiles}/suite.out" "${suitename}.out"

# Evaluate test output
diff suite.joined-golden "${suitename}.out"
result=$?
test $result -eq 0 \
  && echo "${suitename} PASS" > "${suitename}.result" \
  || diff suite.joined-silver "${suitename}.out" > "${suitename}.result"
  # diff with suite.silver will additionally show test sections as diff.
cat "${suitename}.result"
exit $result
