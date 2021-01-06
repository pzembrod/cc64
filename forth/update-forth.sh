#!/bin/bash
set -e

cc64forthdir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
volksforthcbmdir="$(realpath --relative-to="$PWD" "${cc64forthdir}/../../VolksForth/6502/C64/cbmfiles")"

cp "${volksforthcbmdir}/v4th-c64" "${cc64forthdir}/"
cp "${volksforthcbmdir}/v4th-c16+" "${cc64forthdir}/"
cp "${volksforthcbmdir}/v4th-x16" "${cc64forthdir}/"
