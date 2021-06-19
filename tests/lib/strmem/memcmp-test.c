
memcmp_test() {
  static char xxxxx[] = "xxxxx";
  assertTrue( memcmp( abcde, abcdx, 5 ) < 0,
      "memcmp( abcde, abcdx, 5 ) < 0");
  assertEq( memcmp( abcde, abcdx, 4 ), 0,
      "memcmp( abcde, abcdx, 4 )");
  assertEq( memcmp( abcde, xxxxx, 0 ), 0,
      "memcmp( abcde, xxxxx, 0 )");
  assertTrue( memcmp( xxxxx, abcde, 1 ) > 0,
      "memcmp( xxxxx, abcde, 1 ) > 0");

  evaluateAsserts();
}
