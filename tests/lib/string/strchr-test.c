
strchr_test() {
  static char abccd[] = "abccd";
  assertEq(strchr(abccd, 'x'), NULL, "strchr(abccd, 'x')");
  assertEq(strchr(abccd, 'a'), &abccd[0], "strchr(abccd, 'a')");
  assertEq(strchr(abccd, 'd'), &abccd[4], "strchr(abccd, 'd')");
  assertEq(strchr(abccd, '\0'), &abccd[5], "strchr(abccd, '\0')");
  assertEq(strchr(abccd, 'c'), &abccd[2], "strchr(abccd, 'c')");

  evaluateAsserts();
}
