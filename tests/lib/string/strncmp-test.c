
strncmp_test() {
  static char cmpabcde[] = "abcde\0f";
  static char cmpabcd_[] = "abcde\xfc";
  static char empty[] = "";
  static char x[] = "x";
  assertEq(strncmp(abcde, cmpabcde, 5), 0,
      "strncmp(abcde, cmpabcde, 5)");
  assertEq(strncmp(abcde, cmpabcde, 10), 0,
      "strncmp(abcde, cmpabcde, 10)");
  assertTrue(strncmp(abcde, abcdx, 5) < 0,
      "strncmp(abcde, abcdx, 5) < 0");
  assertTrue(strncmp(abcdx, abcde, 5) > 0,
      "strncmp(abcdx, abcde, 5) > 0");
  assertTrue(strncmp(empty, abcde, 5) < 0,
      "strncmp(empty, abcde, 5) < 0");
  assertTrue(strncmp(abcde, empty, 5) > 0,
      "strncmp(abcde, empty, 5) > 0");
  assertEq(strncmp(abcde, abcdx, 4), 0,
      "strncmp(abcde, abcdx, 4)");
  assertEq(strncmp(abcde, x, 0), 0,
      "strncmp(abcde, x, 0)");
  assertTrue(strncmp(abcde, x, 1) < 0,
      "strncmp(abcde, x, 1) < 0");
  assertTrue(strncmp(abcde, cmpabcd_, 10) < 0,
      "strncmp(abcde, cmpabcd_, 10) < 0");

  evaluateAsserts();
}
