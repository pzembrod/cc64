#!/bin/bash
set -e

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -fs8 . \
  -9 ./src/cc64src1.d64 \
