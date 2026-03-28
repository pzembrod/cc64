#!/bin/bash

set -e

description="$@"

# Note: %-cc64.sizes, the plain binary sizes, are updated with
# every binary build. Profiler bucket sizes need to be explicitly
# calculated with a cc64size run.
make buckets.sizes

sizes=$(echo *.sizes|sort)

for s in ${sizes}; do
  echo "${s}"
  echo "$(tail -1 "${s}") ${description}" >> "./bin-size-register/${s}"
done
