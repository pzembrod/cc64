
strcspn_test() {
  assertEq(strcspn(abcde, "x"), 5, "strcspn(abcde, \"x\")");
  assertEq(strcspn(abcde, "xyz"), 5, "strcspn(abcde, \"xyz\")");
  assertEq(strcspn(abcde, "zyx"), 5, "strcspn(abcde, \"zyx\")");
  assertEq(strcspn(abcdx, "x"), 4, "strcspn(abcdx, \"x\")");
  assertEq(strcspn(abcdx, "xyz"), 4, "strcspn(abcdx, \"xyz\")");
  assertEq(strcspn(abcdx, "zyx"), 4, "strcspn(abcdx, \"zyx\")");
  assertEq(strcspn(abcde, "a"), 0, "strcspn(abcde, \"a\")");
  assertEq(strcspn(abcde, "abc"), 0, "strcspn(abcde, \"abc\")");
  assertEq(strcspn(abcde, "cba"), 0, "strcspn(abcde, \"cba\")");

  evaluateAsserts();
}
