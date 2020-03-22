#!/bin/bash
set -e

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -drive10type 1541 \
  -fs8 . \
  -fs8savep00 \
  -fs8hidecbm \
  -9 ./src/cc64src1.d64 \
  -10 ./src/cc64src2.d64
