
fcall_1ptr_test() {
  _fastcall int (*fp)() = tolower;

  assertEq((*fp)('A'), 'a', "(*fp)('A')");
  assertEq((*fp)('Z'), 'z', "(*fp)('Z')");
  assertEq((*fp)('a'), 'a', "(*fp)('a')");
  assertEq((*fp)('z'), 'z', "(*fp)('z')");
  assertEq((*fp)('@'), '@', "(*fp)('@')");
  assertEq((*fp)('['), '[', "(*fp)('[')");
  assertEq((*fp)(0), 0, "(*fp)(0)");
  assertEq((*fp)(256), 256, "(*fp)(256)");
}

fcall_2ptrs_test() {
  _fastcall int (*fp_lo)(), (*fp_up)();
  fp_lo = tolower;
  fp_up = toupper;

  assertEq((*fp_lo)((*fp_up)('a')), 'a', "(*fp_lo)((*fp_up)('a'))");
  assertEq((*fp_lo)((*fp_up)('A')), 'a', "(*fp_lo)((*fp_up)('A'))");
  assertEq((*fp_lo)((*fp_up)(66)), 66, "(*fp_lo)((*fp_up)(66))");

  assertEq((*fp_up)((*fp_lo)(193)), 193, "(*fp_up)((*fp_lo)(193))");
  assertEq((*fp_up)((*fp_lo)(97)), 193, "(*fp_up)((*fp_lo)(97))");
}

fcall_3ptrs_test() {
  _fastcall int (*fp_lo)(), (*fp_up)(), (*fp_iu)();
  fp_lo = tolower;
  fp_up = toupper;
  fp_iu = isupper;
  
  assertTrue((*fp_iu)((*fp_up)((*fp_lo)(97))),
      "(*fp_iu)((*fp_up)((*fp_lo)(97)))");
  assertTrue(!(*fp_iu)((*fp_lo)((*fp_up)(66))),
      "(*fp_iu)((*fp_lo)((*fp_up)(66)))");
}

fcallptr_test() {
  fcall_1ptr_test();
  fcall_2ptrs_test();
  fcall_3ptrs_test();

  evaluateAsserts();
}
