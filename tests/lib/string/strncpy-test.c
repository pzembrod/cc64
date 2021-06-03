
strncpy_test() {
  static char s[] = "xxxxxxx";
  assertEq(strncpy(s, "", 1), s, "strncpy(s, \"\", 1)");
  assertEq(s[0], '\0', "s[0]");
  assertEq(s[1], 'x', "s[1]");
  assertEq(strncpy(s, abcde, 6), s, "strncpy(s, abcde, 6)");
  assertEq(s[0], 'a', "s[0]");
  assertEq(s[4], 'e', "s[4]");
  assertEq(s[5], '\0', "s[5]");
  assertEq(s[6], 'x', "s[6]");
  assertEq(strncpy(s, abcde, 7), s, "strncpy(s, abcde, 7)");
  assertEq(s[6], '\0', "s[6]");
  assertEq(strncpy(s, "xxxx", 3), s, "strncpy(s, \"xxxx\", 3)");
  assertEq(s[0], 'x', "s[0]");
  assertEq(s[2], 'x', "s[2]");
  assertEq(s[3], 'd', "s[3]");

  evaluateAsserts();
}
