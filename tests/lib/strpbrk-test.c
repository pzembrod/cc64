
strpbrk_test() {
  assertEq(strpbrk(abcde, "x"), NULL, "strpbrk(abcde, \"x\")");
  assertEq(strpbrk(abcde, "xyz"), NULL, "strpbrk(abcde, \"xyz\")");
  assertEq(strpbrk(abcdx, "x"), &abcdx[4], "strpbrk(abcdx, \"x\")");
  assertEq(strpbrk(abcdx, "xyz"), &abcdx[4], "strpbrk(abcdx, \"xyz\")");
  assertEq(strpbrk(abcdx, "zyx"), &abcdx[4], "strpbrk(abcdx, \"zyx\")");
  assertEq(strpbrk(abcde, "a"), &abcde[0], "strpbrk(abcde, \"a\")");
  assertEq(strpbrk(abcde, "abc"), &abcde[0], "strpbrk(abcde, \"abc\")");
  assertEq(strpbrk(abcde, "cba"), &abcde[0], "strpbrk(abcde, \"cba\")");

  evaluateAsserts();
}
