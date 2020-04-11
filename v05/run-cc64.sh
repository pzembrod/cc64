#!/bin/bash
# Run Vice emulator with charset adapted for use with C as generated
# by c-char-rom-gen, namely including the chars \^_{|}~ needed by C.

set -e

x64 \
  -virtualdev \
  +truedrive \
  -drive8type 1541 \
  -fs8 . \
  -fs8savep00 \
  -fs8hidecbm \
  -chargen c-chargen \
  -autostart cc64v05.T64 \
