
strcmp_test() {
  static char cmpabcde[] = "abcde";
  static char cmpabcd_[] = "abcd\xfc";
  static char empty[] = "";
  assertEq(strcmp(abcde, cmpabcde), 0, "strcmp(abcde, cmpabcde)");
  assertTrue(strcmp(abcde, abcdx) < 0, "strcmp(abcde, abcdx) < 0");
  assertTrue(strcmp(abcdx, abcde) > 0, "strcmp(abcdx, abcde) > 0");
  assertTrue(strcmp(empty, abcde) < 0, "strcmp(empty, abcde) < 0");
  assertTrue(strcmp(abcde, empty) > 0, "strcmp(abcde, empty) > 0");
  assertTrue(strcmp(abcde, cmpabcd_) < 0, "strcmp(abcde, cmpabcd_) < 0");

  evaluateAsserts();
}
