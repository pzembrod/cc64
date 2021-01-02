#!/bin/bash
set -e

sfdisk="${1}"
img="${2}"

rm -f "${img}" "${img}.tmp"
dd if=/dev/zero of="${img}.tmp" count=64 bs=1M
sfdisk -w always -W always "${img}.tmp" < "${sfdisk}"
mformat -i "${img}.tmp" -F
mv "${img}.tmp" "${img}"
