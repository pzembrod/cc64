#!/bin/bash

# TODO: Remove script again once X16 R39 is standard.

set -e

testdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"

export PATH="${HOME}/x16-r39:${PATH}"
echo "PATH = ${PATH}"
export X16ROM="${HOME}/x16-r39/rom.bin"
echo "X16ROM = ${X16ROM}"
"${testdir}/compile-run-suite.sh" "$@"
