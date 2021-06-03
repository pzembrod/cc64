
memset_test() {
  static char s[] = "xxxxxxxxx";
  assertEq(memset(s, 'o', 10), s, "memset(s, 'o', 10)");
  assertEq(s[9], 'o', "s[9]");
  assertEq(memset(s, '_', (0)), s, "memset(s, '_', (0))");
  assertEq(s[0], 'o', "s[0]");
  assertEq(memset(s, '_', 1), s, "memset(s, '_', 1)");
  assertEq(s[0], '_', "s[0]");
  assertEq(s[1], 'o', "s[1]");

  evaluateAsserts();
}
