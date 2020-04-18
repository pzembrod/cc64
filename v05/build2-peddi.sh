#!/bin/bash
set -e

make c64files-dir 

./build2-in-vice.sh \
   "include build-peddi.fth\nsaveall peddi03\ndos s0:notdone\n"
