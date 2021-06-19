
isupper_test() {
  assertTrue(isupper('A'), "!isupper('A')");
  assertTrue(isupper('Z'), "!isupper('Z')");
  assertTrue(!isupper('a'), "isupper('a')");
  assertTrue(!isupper('z'), "isupper('z')");
  assertTrue(!isupper(' '), "!isupper(' ')");
  assertTrue(!isupper('@'), "!isupper('@')");
  assertTrue(!isupper(0), "!isupper(0)");
  assertTrue(!isupper(256), "!isupper(256)");

  evaluateAsserts();
}
