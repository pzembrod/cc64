#!/bin/bash
set -e

make c64files-dir 

./build2-in-vice.sh \
   "include build-cc64.fth\nsaveall cc64v05\n"
