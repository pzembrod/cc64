#!/bin/bash

set -e

src="$1"
dst="$2"

if [[ "${src}" =~ \.[io]$ ]]; then
  cp -p "${src}" "${dst}"
  exit 0
fi

if [[ "${src}" =~ \.[ch]$ ]]; then
  ascii2petscii "${src}" "${dst}"
  touch -r  "${src}" "${dst}"
  exit 0
fi

echo "$0: Don't know how to copy ${src}" 1>&2
exit 1
