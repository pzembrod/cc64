
memmove_test() {
  static char s[] = "xxxxabcde";
  assertEq(memmove(s, s + 4, 5), s, "memmove(s, s + 4, 5)");
  assertEq(s[0], 'a', "s[0]");
  assertEq(s[4], 'e', "s[4]");
  assertEq(s[5], 'b', "s[5]");
  assertEq(memmove(s + 4, s, 5), s + 4, "memmove(s + 4, s, 5)");
  assertEq(s[4], 'a', "s[4]");

  evaluateAsserts();
}
