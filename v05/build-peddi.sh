#!/bin/bash
set -e

make build-peddi.fth
touch peddi02

./build-in-vice.sh \
   "include build-peddi.fth\nsaveall peddi02\ndos s0:notdone\n"
