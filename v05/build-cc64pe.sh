#!/bin/bash
set -e

basedir="$(dirname "${BASH_SOURCE[0]}")"

"${basedir}/build-in-vice.sh" \
   "include cc64pe-main.fth\nsaveall cc64v05pe\n"
