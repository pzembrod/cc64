#!/bin/bash
set -e

make uF83-382-c64.T64

rm -f uf-build-base

keybuf="1 drive 1 load\n1 drive 130 load 132 load\nsavesystem uf-build-base\n"

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -fs8 . \
  -9 ./src/cc64src1.d64 \
  -autostart "./uF83-382-c64.T64" \
  -keybuf "$keybuf" \

make uf-build-base.T64
