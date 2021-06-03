
strcpy_test() {
  static char s[] = "xxxxx";
  assertEq(strcpy(s, ""), s, "strcpy(s, \"\")");
  assertEq(s[0], '\0', "s[0]");
  assertEq(s[1], 'x', "s[1]");
  assertEq(strcpy(s, abcde), s, "strcpy(s, abcde)");
  assertEq(s[0], 'a', "s[0]");
  assertEq(s[4], 'e', "s[4]");
  assertEq(s[5], '\0', "s[5]");

  evaluateAsserts();
}
