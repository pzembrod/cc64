#!/bin/bash
set -e

emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"

PLATFORM=c16 "${emulatordir}/run-in-vice.sh" "$1" "$2"
