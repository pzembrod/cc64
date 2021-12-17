
fcallptr_test() {
  _fastcall int (*fp)(), (*fp2)();
  fp = tolower;

  assertEq((*fp)('A'), 'a', "(*fp)('A')");
  assertEq((*fp)('Z'), 'z', "(*fp)('Z')");
  assertEq((*fp)('a'), 'a', "(*fp)('a')");
  assertEq((*fp)('z'), 'z', "(*fp)('z')");
  assertEq((*fp)('@'), '@', "(*fp)('@')");
  assertEq((*fp)('['), '[', "(*fp)('[')");
  assertEq((*fp)(0), 0, "(*fp)(0)");
  assertEq((*fp)(256), 256, "(*fp)(256)");

  evaluateAsserts();
}
