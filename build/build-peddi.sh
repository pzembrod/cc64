#!/bin/bash
set -e

builddir="$(dirname "${BASH_SOURCE[0]}")"

"${builddir}/build-in-vice.sh" \
   "include peddi-main.fth\nsaveall peddi\n"
