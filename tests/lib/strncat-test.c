
strncat_test() {
  static char s[] = "xx\0xxxxxx";
  assertEq(strncat(s, abcde, 10), s, "strncat(s, abcde, 10)");
  assertEq(s[2], 'a', "s[2]");
  assertEq(s[6], 'e', "s[6]");
  assertEq(s[7], '\0', "s[7]");
  assertEq(s[8], 'x', "s[8]");
  s[0] = '\0';
  assertEq(strncat(s, abcdx, 10), s, "strncat(s, abcdx, 10)");
  assertEq(s[4], 'x', "s[4]");
  assertEq(s[5], '\0', "s[5]");
  assertEq(strncat(s, "\0", 10), s, "strncat(s, \"\0\", 10)");
  assertEq(s[5], '\0', "s[5]");
  assertEq(s[6], 'e', "s[6]");
  assertEq(strncat(s, abcde, 0), s, "strncat(s, abcde, 0)");
  assertEq(s[5], '\0', "s[5]");
  assertEq(s[6], 'e', "s[6]");
  assertEq(strncat(s, abcde, 3), s, "strncat(s, abcde, 3)");
  assertEq(s[5], 'a', "s[5]");
  assertEq(s[7], 'c', "s[7]");
  assertEq(s[8], '\0', "s[8]");

  evaluateAsserts();
}
