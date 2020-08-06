#!/bin/bash
set -e

emulatordir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

platform="$1"
case "$platform" in
  "c64")
    echo "x64 -chargen ${emulatordir}/c-chargen"
    ;;
  "c16")
    echo "xplus4"
    ;;
  *)
    echo "Unknown platform '$platform'" 1>&2
    echo "xunknown-emulator"
    exit 1
    ;;
esac
