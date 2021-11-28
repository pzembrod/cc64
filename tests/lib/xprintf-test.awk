/^INCLUDE$/ {
  system( \
    "sed -e \"s/P[(]PRINTF[(]/$PRINTF/g\" stdio/xprintf-test-inc.c");
}
!/^INCLUDE$/ { print; }
