#!/bin/bash
set -e

make build-cc64.fth.S00
touch cc64v05

./build-in-vice.sh \
   "include build-cc64.fth\nsaveall cc64v05\ndos s0:notdone\n"
