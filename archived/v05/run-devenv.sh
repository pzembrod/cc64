#!/bin/bash
# Run ultraForth development environment aka uF with editor and tools,
# in VICE emulator with charset adapted for use with C as generated
# by c-char-rom-gen, namely including the chars \^_{|}~ needed by C.

set -e

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -drive9type 1541 \
  -drive10type 1541 \
  -drive11type 1541 \
  -fs8 . \
  -9 ./src/cc64src1.d64 \
  -10 ./src/cc64src2.d64 \
  -11 ./src/peddi_src.d64 \
  -chargen c-chargen \
  -symkeymap ./x11_sym_uf_de.vkm \
  -keymap 2 \
  -autostart devenv-uF83.T64 \

