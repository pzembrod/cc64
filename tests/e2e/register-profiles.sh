#!/bin/bash

set -e

name="$1"
shift
description="$@"

date_full="$(date -Iseconds)"
date_name="$(date -d "${date_full}" +%F-%H%M)"

profiles=$(echo *.profile|sort)

echo "name=name-${date_name}-${name}"
echo "${date_full}"
echo "description=y${description}y"
echo "profiles=${profiles}"

for p in ${profiles}; do
  echo $p
  p_base="$(basename -s .profile "${p}")"
  ( echo "${date_full}"
    echo "${description}"
    cat "${p}"
  ) > "./profile-register/${p_base}-${date_name}-${name}.profile"
done
