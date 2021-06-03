
strstr_test() {
  static char s[] = "abcabcabcdabcde";
  assertEq(strstr(s, "x"), NULL, "strstr(s, \"x\")");
  assertEq(strstr(s, "xyz"), NULL, "strstr(s, \"xyz\")");
  assertEq(strstr(s, "a"), &s[0], "strstr(s, \"a\")");
  assertEq(strstr(s, "abc"), &s[0], "strstr(s, \"abc\")");
  assertEq(strstr(s, "abcd"), &s[6], "strstr(s, \"abcd\")");
  assertEq(strstr(s, "abcde"), &s[10], "strstr(s, \"abcde\")");

  evaluateAsserts();
}
