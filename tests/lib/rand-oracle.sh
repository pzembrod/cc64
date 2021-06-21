#!/bin/bash

set -e

rand_expect_c="$1"

./rand-oracle 6 > "${rand_expect_c}"
./rand-oracle 6 17 rand_expected_17 >> "${rand_expect_c}"
./rand-oracle 6 32767 rand_expected_32767 >> "${rand_expect_c}"
./rand-oracle 6 0 rand_expected_0 >> "${rand_expect_c}"
