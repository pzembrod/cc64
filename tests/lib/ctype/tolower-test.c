
tolower_test() {
  assertEq(tolower('A'), 'a', "tolower('A')");
  assertEq(tolower('Z'), 'z', "tolower('Z')");
  assertEq(tolower('a'), 'a', "tolower('a')");
  assertEq(tolower('z'), 'z', "tolower('z')");
  assertEq(tolower('@'), '@', "tolower('@')");
  assertEq(tolower('['), '[', "tolower('[')");
  assertEq(tolower(0), 0, "tolower(0)");
  assertEq(tolower(256), 256, "tolower(256)");

  evaluateAsserts();
}
