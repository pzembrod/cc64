#!/bin/bash
set -e

builddir="$(dirname "${BASH_SOURCE[0]}")"

"${builddir}/build-in-vice.sh" \
   "include cc64-main.fth\nsaveall cc64\n"
