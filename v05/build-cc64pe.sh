#!/bin/bash
set -e

make build-cc64pe.fth
touch cc64v05pe

./build-in-vice.sh \
   "include build-cc64pe.fth\nsaveall cc64v05pe\ndos s0:notdone\n"
