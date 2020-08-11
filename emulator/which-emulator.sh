#!/bin/bash
set -e

emulatordir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

platform="$1"
case "$platform" in
  "c64")
    echo x64 -chargen ${emulatordir}/c-chargen \
    -symkeymap ${emulatordir}/x11_sym_c64_vf_de.vkm -keymap 2
    ;;
  "c16")
    echo xplus4 \
    -symkeymap ${emulatordir}/x11_sym_c16_vf_de.vkm -keymap 2
    ;;
  *)
    echo "Unknown platform '$platform'" 1>&2
    echo "xunknown-emulator"
    exit 1
    ;;
esac
