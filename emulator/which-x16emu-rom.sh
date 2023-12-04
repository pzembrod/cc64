#!/bin/bash
set -e

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
source "${emulatordir}/basedir.shlib"

x16emu_name="$(which x16emu)"
x16emu_binary="$(realpath "--relative-to=$PWD" "${x16emu_name}")"
x16emu_dir="$(dirname "${x16emu_binary}")"
x16emu_rom="${x16emu_dir}/rom.bin"
echo "${x16emu_rom}"
