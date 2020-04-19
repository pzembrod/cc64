#!/bin/bash
set -e

basedir="$(dirname "${BASH_SOURCE[0]}")"

"${basedir}/build-in-vice.sh" \
   "include build-peddi.fth\nsaveall peddi03\n"
