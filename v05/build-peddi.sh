#!/bin/bash
set -e

make c64files-dir 

./build-in-vice.sh \
   "include build-peddi.fth\nsaveall peddi03\n"
