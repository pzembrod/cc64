
strspn_test() {
  assertEq(strspn(abcde, "abc"), 3, "strspn(abcde, \"abc\")");
  assertEq(strspn(abcde, "b"), 0, "strspn(abcde, \"b\")");
  assertEq(strspn(abcde, abcde), 5, "strspn(abcde, abcde)");

  evaluateAsserts();
}
