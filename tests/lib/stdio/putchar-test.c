
putchar_test() {
  int i;
  tst_chkout(tst_file_no);
  for (i='0'; i <= '9'; ++i) {
    assertEq(putchar(i), i, "'0'..'9': putchar(i)");
  }
  assertEq(putchar(13), 13, "putchar(13)");
  assertEq(putchar('@'), '@', "putchar('@')");
  assertEq(putchar(0x150), EOF, "putchar(256)");
  for (i='a'; i <= 'm'; ++i) {
    assertEq(putchar(i), i, "'a'..'m': putchar(i)");
  }
  assertEq(putchar('\n'), '\n', "putchar('\n')");
  tst_clrchn();

  evaluateAsserts();
}
