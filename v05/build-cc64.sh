#!/bin/bash
set -e

txt2s00 notdone notdone.S00

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -drive10type 1541 \
  -drive11type 1541 \
  -fs8 . \
  -fs8hidecbm \
  -9 ./src/cc64src1.d64 \
  -10 ./src/cc64src2.d64 \
  -11 ./src/peddi_src.d64 \
  -autostart uf-build-base.T64 \
  -keybuf "include build-cc64.fth\nsaveall cc64v05\ndos s0:notdone\n" \
  -warp \
  &

while  test -f notdone.S00
  do sleep 1
done
sleep 1

kill %1

make
