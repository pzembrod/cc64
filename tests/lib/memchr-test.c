
memchr_test() {
  assertEq(memchr( abcde, 'c', 5 ), &abcde[2],
      "memchr( abcde, 'c', 5 ) == &abcde[2]");
  assertEq(memchr( abcde, 'a', 1 ), &abcde[0],
      "memchr( abcde, 'a', 1 )");
  assertEq(memchr( abcde, 'a', 0 ), NULL,
      "memchr( abcde, 'a', 0 )");
  assertEq(memchr( abcde, '\0', 5 ), NULL,
      "memchr( abcde, '\0', 5 )");
  assertEq(memchr( abcde, '\0', 6 ), &abcde[5],
      "memchr( abcde, '\0', 6 )");

  evaluateAsserts();
}
