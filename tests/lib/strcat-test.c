
strcat_test() {
  static char s[] = "xx\0xxxxxx";
  assertEq(strcat(s, abcde), s, "strcat(s, abcde)");
  assertEq(s[2], 'a', "s[2]");
  assertEq(s[6], 'e', "s[6]");
  assertEq(s[7], '\0', "s[7]");
  assertEq(s[8], 'x', "s[8]");
  s[0] = '\0';
  assertEq(strcat(s, abcdx), s, "strcat(s, abcdx)");
  assertEq(s[4], 'x', "s[4]");
  assertEq(s[5], '\0', "s[5]");
  assertEq(strcat(s, "\0"), s, "strcat(s, \"\0\")");
  assertEq(s[5], '\0', "s[5]");
  assertEq(s[6], 'e', "s[6]");

  evaluateAsserts();
}
