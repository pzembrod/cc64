/^INCLUDE$/ {
  system( \
    "sed -e \"s/P[(]PRINTF[(]/$PRINTF/g\" \"$SUBDIR\"/xprintf-test-inc.c");
}
!/^INCLUDE$/ { print; }
