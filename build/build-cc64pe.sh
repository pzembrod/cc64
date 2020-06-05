#!/bin/bash
set -e

builddir="$(dirname "${BASH_SOURCE[0]}")"

"${builddir}/build-in-vice.sh" \
   "include cc64pe-main.fth\nsaveall cc64pe\n"
