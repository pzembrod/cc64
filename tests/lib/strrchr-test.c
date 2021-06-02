
strrchr_test() {
  static char abccd[] = "abccd";
  assertEq(strrchr(abcde, '\0'), &abcde[5], "strrchr(abcde, '\0')");
  assertEq(strrchr(abcde, 'e'), &abcde[4], "strrchr(abcde, 'e')");
  assertEq(strrchr(abcde, 'a'), &abcde[0], "strrchr(abcde, 'a')");
  assertEq(strrchr(abccd, 'c'), &abccd[3], "strrchr(abccd, 'c')");

  evaluateAsserts();
}
