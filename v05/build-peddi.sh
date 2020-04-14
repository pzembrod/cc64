#!/bin/bash
set -e

make build-peddi.fth
touch peddi03

./build-in-vice.sh \
   "include build-peddi.fth\nsaveall peddi03\ndos s0:notdone\n"
