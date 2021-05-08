#!/bin/bash

set -e

description="$@"

sizes=$(echo *.sizes|sort)

for s in ${sizes}; do
  echo "${s}"
  echo "$(tail -1 "${s}") ${description}" >> "./bin-size-register/${s}"
done
